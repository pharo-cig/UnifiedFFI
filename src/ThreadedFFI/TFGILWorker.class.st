"
I am a threaded FFI worker that routes callouts through the VM GIL worker primitive.
Like TFWorker, multiple instances may exist to declare different GIL-capable FFI runners
in the image. The VM is responsible for serializing actual interpreter/GIL ownership so
only one such worker holds it at a given moment.
"
Class {
	#name : 'TFGILWorker',
	#superclass : 'TFWorker',
	#category : 'ThreadedFFI-Worker',
	#package : 'ThreadedFFI',
	#tag : 'Worker'
}

{ #category : 'accessing' }
TFGILWorker class >> default [

	^ self named: 'default-gil'
]

{ #category : 'accessing' }
TFGILWorker class >> named: aName [

	| worker |
	worker := super named: aName.
	worker ensureInitialized.
	^ worker
]

{ #category : 'accessing' }
TFGILWorker >> callbackRunningStrategy [

	self ensureDirectCallbackProcessRegistered.
	^ TFCallbackForkRunStrategy new
]

{ #category : 'executing' }
TFGILWorker >> defer: aBlock [

	| resultHolder deferredProcess |
	self ensureInitialized.
	resultHolder := Array new: 2.
	deferredProcess := [
		[ 
			resultHolder
				at: 1 put: true;
				at: 2 put: aBlock value ]
				on: Exception do: [ :e |
					resultHolder
						at: 1 put: false;
						at: 2 put: e ].
		self primitiveLeaveGILWorkerContext ] 
	newProcess.

	self primitiveGILWorkerDeferProcess: deferredProcess.

	resultHolder first
		ifTrue: [ ^ resultHolder second ].

	resultHolder second signal
]

{ #category : 'executing' }
TFGILWorker >> ensureDirectCallbackProcessRegistered [

	self primitiveRegisterGILDirectCallbackProcess: TFCallbackQueue uniqueInstance callbackProcess
]

{ #category : 'executing' }
TFGILWorker >> executeFunction: aTFExternalFunction withArguments: arguments usingSemaphore: anInteger [

	<primitive: 'primitiveGILWorkerCallout' error: ec>

	self primitiveFailed
]

{ #category : 'testing' }
TFGILWorker >> isInGILWorkerContext [

	<primitive: 'primitiveIsInGILWorkerContext' error: ec>

	self primitiveFailed
]

{ #category : 'executing' }
TFGILWorker >> primitiveGILWorkerDeferProcess: aProcess [

	<primitive: 'primitiveGILWorkerDeferProcess' error: ec>

	self primitiveFailed
]

{ #category : 'executing' }
TFGILWorker >> primitiveLeaveGILWorkerContext [

	<primitive: 'primitiveLeaveGILWorkerContext' error: ec>

	self primitiveFailed
]

{ #category : 'executing' }
TFGILWorker >> primitiveRegisterGILDirectCallbackProcess: aProcess [

	<primitive: 'primitiveRegisterGILDirectCallbackProcess' error: ec>

	self primitiveFailed
]
