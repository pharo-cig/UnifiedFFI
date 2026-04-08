"
I provide GIL-specific worker behavior shared by GIL-capable runners.
"
Trait {
	#name : 'TFTGILWorker',
	#instVars : [
		'callbackRunner',
		'name'
	],
	#category : 'ThreadedFFI-Worker',
	#package : 'ThreadedFFI',
	#tag : 'Worker'
}

{ #category : 'private' }
TFTGILWorker >> applyThreadName [

	name ifNil: [ ^ self ].
	self isNull ifTrue: [ ^ self ].
	self primitiveSetGILWorkerName: name, ' (GIL)'
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
TFTGILWorker >> waitForCallbackReturnOrderingOn: aCallbackInvocation [

	self isInGILWorkerContext
		ifTrue: [ ^ self cannotReturnCallbackInWrongOrder: aCallbackInvocation ].

	^ callbackReturnSemaphore wait
]

{ #category : 'private' }
TFTGILWorker >> withCallbackStackLockDo: aBlock [

	self isInGILWorkerContext
		ifTrue: [ ^ aBlock value ].

	^ stackProtect critical: aBlock
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
	^ ((callbackRunner isNil) or: [ callbackRunner isNull ])
		ifTrue: [
			callbackRunner := TFCallbackWorkerProxy
				forHandle: self primitiveGetGILWorkerInnerAddress
				owner: self ]
		ifFalse: [ callbackRunner ]
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
TFTGILWorker >> primitiveGILWorkerDeferProcess: aProcess [

	<primitive: 'primitiveGILWorkerDeferProcess' error: ec>

	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveGetGILWorkerInnerAddress [

	<primitive: 'primitiveGetGILWorkerInnerAddress' error: ec>

	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveDetachGILWorkerContext [

	<primitive: 'primitiveDetachGILWorkerContext' error: ec>

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
TFTGILWorker >> primitiveSetGILWorkerName: aString [

	<primitive: 'primitiveSetGILWorkerName'>

	self primitiveFailed
]
