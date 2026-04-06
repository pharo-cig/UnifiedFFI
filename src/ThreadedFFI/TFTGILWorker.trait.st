"
I provide GIL-specific worker behavior shared by GIL-capable runners.
"
Trait {
	#name : 'TFTGILWorker',
	#category : 'ThreadedFFI-Worker',
	#package : 'ThreadedFFI',
	#tag : 'Worker'
}

{ #category : 'accessing' }
TFTGILWorker >> callbackRunningStrategy [

	self ensureDirectCallbackProcessRegistered.
	^ TFCallbackForkRunStrategy new
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

{ #category : 'private' }
TFTGILWorker >> ensureDirectCallbackProcessRegistered [

	self primitiveRegisterGILDirectCallbackProcess: TFCallbackQueue uniqueInstance callbackProcess
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
TFTGILWorker >> primitiveLeaveGILWorkerContext [

	<primitive: 'primitiveLeaveGILWorkerContext' error: ec>

	self primitiveFailed
]

{ #category : 'private' }
TFTGILWorker >> primitiveRegisterGILDirectCallbackProcess: aProcess [

	<primitive: 'primitiveRegisterGILDirectCallbackProcess' error: ec>

	self primitiveFailed
]
