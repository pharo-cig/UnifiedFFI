"
I am a lightweight runner used only for callbacks.
I wrap an already-existing worker handle and initialize only the image-side
callback bookkeeping structures.
"
Class {
	#name : 'TFCallbackWorkerProxy',
	#superclass : 'TFRunner',
	#category : 'ThreadedFFI-Worker',
	#package : 'ThreadedFFI',
	#tag : 'Worker'
}

{ #category : 'instance creation' }
TFCallbackWorkerProxy class >> forHandle: aHandle [

	^ self new
		setHandle: aHandle;
		doInitialize;
		yourself
]
