"
I am a lightweight runner used only for callbacks.
I wrap an already-existing worker handle and initialize only the image-side
callback bookkeeping structures.
"
Class {
	#name : 'TFCallbackWorkerProxy',
	#superclass : 'TFRunner',
	#instVars : [
		'ownerRunner'
	],
	#category : 'ThreadedFFI-Worker',
	#package : 'ThreadedFFI',
	#tag : 'Worker'
}

{ #category : 'instance creation' }
TFCallbackWorkerProxy class >> forHandle: aHandle owner: aRunner [

	^ self new
		setHandle: aHandle;
		ownerRunner: aRunner;
		doInitialize;
		yourself
]

{ #category : 'accessing' }
TFCallbackWorkerProxy >> callbackProcess [

	^ ownerRunner callbackProcess
]

{ #category : 'accessing' }
TFCallbackWorkerProxy >> callbackRunningStrategy [

	^ ownerRunner callbackRunningStrategy
]

{ #category : 'accessing' }
TFCallbackWorkerProxy >> directCallbackProcess [

	^ ownerRunner directCallbackProcess
]

{ #category : 'executing' }
TFCallbackWorkerProxy >> executeCallback: aCallbackInvocation [

	^ ownerRunner executeCallback: aCallbackInvocation
]

{ #category : 'accessing' }
TFCallbackWorkerProxy >> lookupCallback: anExternalAddress [

	^ ownerRunner lookupCallback: anExternalAddress
]

{ #category : 'accessing' }
TFCallbackWorkerProxy >> ownerRunner [

	^ ownerRunner
]

{ #category : 'accessing' }
TFCallbackWorkerProxy >> ownerRunner: aRunner [

	ownerRunner := aRunner
]

{ #category : 'accessing' }
TFCallbackWorkerProxy >> registerCallback: aCallback [

	^ ownerRunner registerCallback: aCallback
]

{ #category : 'executing' }
TFCallbackWorkerProxy >> returnCallback: aCallbackInvocation [

	^ ownerRunner returnCallback: aCallbackInvocation
]
