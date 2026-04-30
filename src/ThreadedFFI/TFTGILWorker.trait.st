"
I provide GIL-specific worker behavior shared by GIL-capable runners.
"
Trait {
	#name : 'TFTGILWorker',
	#category : 'ThreadedFFI-Worker',
	#package : 'ThreadedFFI',
	#tag : 'Worker'
}

{ #category : 'private' }
TFTGILWorker >> applyThreadName [

	self name ifNil: [ ^ self ].
	self isNull ifTrue: [ ^ self ].
	self primitiveSetGILWorkerName: self name, ' (GIL)'
]

{ #category : 'accessing' }
TFTGILWorker >> callbackDetachPolicy [
	self ensureInitialized.
	^ self primitiveGetGILWorkerCallbackDetachPolicy
]

{ #category : 'accessing' }
TFTGILWorker >> callbackDetachPolicy: aPolicy [

	self ensureInitialized.
	self primitiveSetGILWorkerCallbackDetachPolicy: (self callbackDetachPolicyValueFor: aPolicy)
]

{ #category : 'private' }
TFTGILWorker >> callbackDetachPolicyValueFor: aPolicy [
	
	aPolicy isInteger ifTrue: [
		(aPolicy = 0 or: [ aPolicy = 1 ])
			ifTrue: [ ^ aPolicy ].
		self error: 'Invalid GIL callback detach policy: ', aPolicy printString ].

	aPolicy = #immediate ifTrue: [ ^ 0 ].
	aPolicy = #hybrid ifTrue: [ ^ 1 ].
	
	self error: 'Invalid GIL callback detach policy: ', aPolicy printString
]

{ #category : 'accessing' }
TFTGILWorker >> callbackRunningStrategy [

	self ensureDirectCallbackProcessRegistered.
	^ TFCallbackSameProcessRunStrategy uniqueInstance
]

{ #category : 'executing' }
TFTGILWorker >> defer: aBlock [
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
TFTGILWorker >> deferDetachable: aBlock [
	| deferredProcess |

	self ensureInitialized.
	deferredProcess := aBlock newProcess.
	self primitiveGILWorkerDeferProcess: deferredProcess.
	^ deferredProcess
]

{ #category : 'private' }
TFTGILWorker >> ensureDirectCallbackProcessRegistered [

	self primitiveRegisterGILDirectCallbackProcess: self directCallbackProcess
]

{ #category : 'private' }
TFTGILWorker >> executeDetachableFunction: aTFExternalFunction withArguments: arguments usingSemaphore: anInteger [
	<primitive: 'primitiveDetachableGILWorkerCallout' error: ec>
	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> executeFunction: aTFExternalFunction withArguments: arguments usingSemaphore: anInteger [
	<primitive: 'primitiveGILWorkerCallout' error: ec>
   	self primitiveFailed
]

{ #category : 'accessing' }
TFTGILWorker >> forCallback [
 
	self ensureInitialized.
	self ensureDirectCallbackProcessRegistered.
	^ ((self callbackRunner isNil) or: [ self callbackRunner isNull ])
		ifTrue: [
			self callbackRunner: (TFCallbackWorkerProxy
				forHandle: self primitiveGetGILWorkerInnerAddress
				owner: self) ]
		ifFalse: [ self callbackRunner ]
]

{ #category : 'executing' }
TFTGILWorker >> invokeDetachableFunction: aTFExternalFunction withArguments: aCollection [

	^ (TFDetachableExternalAsyncCall forFunction: aTFExternalFunction)
		parameters: aCollection;
		executeOn: self
]

{ #category : 'testing' }
TFTGILWorker >> isGILWorker [

	^ true
]

{ #category : 'testing' }
TFTGILWorker >> isInGILWorkerContext [

	<primitive: 'primitiveIsInGILWorkerContext' error: ec>

	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveActivatePendingGILWorkerDetach [

	<primitive: 'primitiveActivatePendingGILWorkerDetach' error: ec>

	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveDetachGILWorkerContext [

	<primitive: 'primitiveDetachGILWorkerContext' error: ec>

	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveGILWorkerDeferProcess: aProcess [

	<primitive: 'primitiveGILWorkerDeferProcess' error: ec>

	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveGetActivatePendingGILWorkerDetachInnerAddress [

	<primitive: 'primitiveGetActivatePendingGILWorkerDetachInnerAddress' error: ec>

	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveGetGILWorkerCallbackDetachPolicy [
	<primitive: 'primitiveGetGILWorkerCallbackDetachPolicy' error: ec>
	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveGetGILWorkerInnerAddress [

	<primitive: 'primitiveGetGILWorkerInnerAddress' error: ec>

	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveLeaveGILWorkerContext [

	<primitive: 'primitiveLeaveGILWorkerContext' error: ec>

	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveReattachGILWorkerContext [

	<primitive: 'primitiveReattachGILWorkerContext' error: ec>

	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveRegisterGILDirectCallbackProcess: aProcess [

	<primitive: 'primitiveRegisterGILDirectCallbackProcess' error: ec>

	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveSetGILWorkerCallbackDetachPolicy: anInteger [
	<primitive: 'primitiveSetGILWorkerCallbackDetachPolicy' error: ec>
	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveSetGILWorkerName: aString [

	<primitive: 'primitiveSetGILWorkerName'>

	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> signalCallbackReturnSemaphore [

	self isInGILWorkerContext
		ifTrue: [ ^ self callbackReturnSemaphore signalAll ].

	^ [ self callbackReturnSemaphore signalAll ] valueUnpreemptively
]

{ #category : 'private' }
TFTGILWorker >> waitForCallbackReturnOrderingOn: aCallbackInvocation [

	self isInGILWorkerContext
		ifTrue: [ ^ self cannotReturnCallbackInWrongOrder: aCallbackInvocation ].

	^ self callbackReturnSemaphore wait
]

{ #category : 'private' }
TFTGILWorker >> withCallbackStackLockDo: aBlock [

	self isInGILWorkerContext
		ifTrue: [ ^ aBlock value ].

	^ self stackProtect critical: aBlock
]
