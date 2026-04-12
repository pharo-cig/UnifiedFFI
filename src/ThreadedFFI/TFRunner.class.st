"
When executing a callout or a callback the invocation pass all through a runner.
There are different kinds of runners.
Each has different policies to run the FFI calls and callbacks.
"
Class {
	#name : 'TFRunner',
	#superclass : 'FFIExternalReference',
	#instVars : [
		'name',
		'callbackRunner',
		'callbackInvocationStack',
		'stackProtect',
		'exceptionHandler',
		'semaphorePool',
		'callbackReturnSemaphore',
		'directCallbackProcess'
	],
	#category : 'ThreadedFFI-Worker',
	#package : 'ThreadedFFI',
	#tag : 'Worker'
}

{ #category : 'private' }
TFRunner >> applyThreadName [

	name ifNil: [ ^ self ].
	self isNull ifTrue: [ ^ self ].
	self primitiveSetWorkerName: name
]

{ #category : 'accessing' }
TFRunner >> callbackProcess [

	^ TFCallbackQueue uniqueInstance callbackProcess
]

{ #category : 'accessing' }
TFRunner >> callbackRunningStrategy [

	^ TFCallbackForkRunStrategy new
]

{ #category : 'errors' }
TFRunner >> cannotReturnCallbackFromOldSession: aCallbackInvocation [

	^ TFInvalidSessionCallbackReturn new
		callbackInvocation: aCallbackInvocation;
		signal
]

{ #category : 'errors' }
TFRunner >> cannotReturnCallbackInWrongOrder: aCallbackInvocation [

	^ TFIncorrectOrderCallbackReturn new
		callbackInvocation: aCallbackInvocation;
		previousCallbacks: (callbackInvocationStack copyUpTo: aCallbackInvocation);
		signal
]

{ #category : 'deferred message' }
TFRunner >> defer: aBlock [
	"this just have sense in the context of GIL worker"

	^ aBlock value 
]

{ #category : 'deferred message' }
TFRunner >> deferDetachable: aBlock [
	"Detachable borrowed sessions only have special meaning for GIL workers."

	^ self defer: aBlock
]

{ #category : 'accessing' }
TFRunner >> directCallbackProcess [

	(directCallbackProcess isNotNil and: [ directCallbackProcess isTerminated not ])
		ifTrue: [ ^ directCallbackProcess ].

	directCallbackProcess := [
		[ true ] whileTrue: [
			Processor activeProcess suspend.
			[ self executePendingCallback ]
				on: Exception
				do: [ :ex | ex pass ] ] ] newProcess.
	directCallbackProcess priority: Processor highIOPriority.
	directCallbackProcess name: self name, ' Direct Callback'.
	directCallbackProcess resume.
	^ directCallbackProcess
]

{ #category : 'executing' }
TFRunner >> doInitialize [

	callbackRunner := nil.
	callbackInvocationStack := Stack new.
	stackProtect := Semaphore forMutualExclusion.
	directCallbackProcess := nil.
	semaphorePool ifNotNil: [ semaphorePool release ].
	semaphorePool := self newSemaphorePool.
	self directCallbackProcess
]

{ #category : 'executing' }
TFRunner >> ensureInitialized [
	"Only initialize if the image has been restarted and thus I have no handle"
	self isNull ifTrue: [ self doInitialize ]
]

{ #category : 'errors' }
TFRunner >> exceptionHandler [

	^ exceptionHandler ifNil: [
		exceptionHandler := TFForkCallbackExceptionHandler new ]
]

{ #category : 'errors' }
TFRunner >> exceptionHandler: anExceptionHandler [

	exceptionHandler := anExceptionHandler
]

{ #category : 'executing' }
TFRunner >> executeCallback: aCallbackInvocation [
	"Entry point to execute a callback invocation.
	Runs the callback in a separate green thread and stack it.
	The stack gives information about the order in which callbacks should return.
	If a callback does not return in the right order, an exception is thrown.

	To guarantee the stack is not modified while this method runs, this method should be called from a high priority process.
	  => no callbacks should finish while this method runs."

	self withCallbackStackLockDo: [ callbackInvocationStack push: aCallbackInvocation ].
	aCallbackInvocation callback runStrategy executeCallback: aCallbackInvocation on: self
]

{ #category : 'executing' }
TFRunner >> executeDirectCallback: aCallbackInvocation [

	self withCallbackStackLockDo: [ callbackInvocationStack push: aCallbackInvocation ].
	self handleExceptionDuring: [ aCallbackInvocation execute ]
]

{ #category : 'operations' }
TFRunner >> executePendingCallback [

	| aCallbackInvocation |

	aCallbackInvocation := self nextPendingCallback.
	aCallbackInvocation ifNil: [ ^ self ].
	aCallbackInvocation getHandle isNull ifTrue: [ ^ self ].

	aCallbackInvocation callback: ((self lookupCallback: aCallbackInvocation callbackData)
		ifNil: [ self error: 'Callback not found.' ]).
	self executeDirectCallback: aCallbackInvocation
]

{ #category : 'accessing' }
TFRunner >> forCallback [

	^ self
]

{ #category : 'errors' }
TFRunner >> handleExceptionDuring: aBlock [

	self exceptionHandler handleExceptionDuring: aBlock
]

{ #category : 'executing' }
TFRunner >> invokeFunction: aTFExternalFunction [

	^ self invokeFunction: aTFExternalFunction withArguments: #()
]

{ #category : 'executing' }
TFRunner >> invokeFunction: aTFExternalFunction withArguments: aCollection [

	^ (TFPooledExternalAsyncCall forFunction: aTFExternalFunction)
		parameters: aCollection;
		executeOn: self
]

{ #category : 'executing' }
TFRunner >> invokeDetachableFunction: aTFExternalFunction withArguments: aCollection [

	^ self invokeFunction: aTFExternalFunction withArguments: aCollection
]

{ #category : 'testing' }
TFRunner >> isGILWorker [

	^ false
]

{ #category : 'private' }
TFRunner >> lookupCallback: anExternalAddress [

	^ TFCallbackQueue uniqueInstance lookupCallback: anExternalAddress
]

{ #category : 'accessing' }
TFRunner >> name [

	^ name
]

{ #category : 'accessing' }
TFRunner >> name: aName [

	name := aName.
	self isNull ifFalse: [ self applyThreadName ]
]

{ #category : 'private' }
TFRunner >> newSemaphorePool [

	^ TFPool
		newProvider: (MessageSend receiver: TFExternalSemaphore selector: #new)
		size: self semaphorePoolSize
		releaseBlock: #release "This is ugly... but do not change it to a block, if you change it to a block it will have a reference to self. Creating a loop in the references and leaking memory"
]

{ #category : 'private' }
TFRunner >> nextPendingCallback [

	^ TFCallbackQueue uniqueInstance nextPendingCallback
]

{ #category : 'private' }
TFRunner >> primitivePerformWorkerCall: aTFExternalFunction
		withArguments: argumentHolder
		withReturnHolder: aReturnHolder
		usingSemaphore: anInteger [

	^ self subclassResponsibility
]

{ #category : 'private' }
TFRunner >> primitiveSetWorkerName: aString [

	<primitive: 'primitiveSetWorkerName'>

	^ self primitiveFailed
]

{ #category : 'accessing' }
TFRunner >> registerCallback: aCallback [

	^ TFCallbackQueue uniqueInstance registerCallback: aCallback
]

{ #category : 'executing' }
TFRunner >> release [

	semaphorePool ifNotNil: [
		semaphorePool release.
		semaphorePool := nil ].

	directCallbackProcess ifNotNil: [
		directCallbackProcess terminate.
		directCallbackProcess := nil ].

	handle beNull.
	"If the stack is not initialized it means this worker was never used for callbacks"
	stackProtect ifNil: [ ^ self ].
	self withCallbackStackLockDo: [
		callbackInvocationStack := nil ]
]

{ #category : 'executing' }
TFRunner >> returnCallback: aCallbackInvocation [
	"Entry point to return a callback invocation.
	Check the callbackInvocation stack to see if the given invocation is the last one.
	If so, it can return safely.
	Otherwise, throw an exception as returning means a bug in your application.
	The user must guarantee callbacks return in the correct order"

	callbackReturnSemaphore ifNil: [
		callbackReturnSemaphore := Semaphore new ].

	aCallbackInvocation isNull
		ifTrue: [ ^ self ].

	callbackInvocationStack isEmptyOrNil ifTrue: [
		^ self cannotReturnCallbackFromOldSession: aCallbackInvocation].

	self withCallbackStackLockDo: [
		(callbackInvocationStack top == aCallbackInvocation)
			ifTrue: [
				(self isGILWorker and: [ self isInGILWorkerContext ])
					ifTrue: [
						callbackInvocationStack pop.
						self signalCallbackReturnSemaphore.
						"primitiveCallbackReturn hands control back to the foreign
						callback caller on the direct GIL path, so Smalltalk-side
						bookkeeping must already be complete."
						aCallbackInvocation returnExecution.
						self error:
							'Direct GIL callback return unexpectedly resumed after primitiveCallbackReturn' ].

				aCallbackInvocation returnExecution
					ifTrue: [
						"If we are starting a session and an execution was executed, it
						 may happen that the stack is empty."
						callbackInvocationStack ifEmpty: [ ^ self ].
						callbackInvocationStack pop.
						self signalCallbackReturnSemaphore.
						^ self ]] ].
	"failed"
	self waitForCallbackReturnOrderingOn: aCallbackInvocation.
	self returnCallback: aCallbackInvocation
]

{ #category : 'private' }
TFRunner >> waitForCallbackReturnOrderingOn: aCallbackInvocation [

	callbackReturnSemaphore wait
]

{ #category : 'private' }
TFRunner >> signalCallbackReturnSemaphore [

	[ callbackReturnSemaphore signalAll ] valueUnpreemptively
]

{ #category : 'private' }
TFRunner >> withCallbackStackLockDo: aBlock [

	^ stackProtect critical: aBlock
]

{ #category : 'accessing' }
TFRunner >> semaphorePool [

	self ensureInitialized.
	^ semaphorePool
]

{ #category : 'accessing' }
TFRunner >> semaphorePoolSize [

	^ 5
]
