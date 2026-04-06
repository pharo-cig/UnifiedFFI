"
I represent the launcher-provided GIL worker that is bound to the process main thread.
It is only available when the VM was started with --gil-worker.
"
Class {
	#name : 'TFGILMainThreadRunner',
	#superclass : 'TFMainThreadRunner',
	#traits : 'TFTGILWorker',
	#classTraits : 'TFTGILWorker classTrait',
	#category : 'ThreadedFFI-Worker',
	#package : 'ThreadedFFI',
	#tag : 'Worker'
}

{ #category : 'accessing' }
TFGILMainThreadRunner class >> default [

	^ self uniqueInstance
]

{ #category : 'testing' }
TFGILMainThreadRunner class >> isAvailable [

	<primitive: 'primitiveHasMainThreadGILWorker' error: ec>

	^ false
]

{ #category : 'accessing' }
TFGILMainThreadRunner class >> runnerName [

	^ 'Main Thread (GIL)'
]

{ #category : 'accessing' }
TFGILMainThreadRunner class >> uniqueInstance [

	self isAvailable 
		ifFalse: [ self error: 'Main-thread GIL worker requires the VM to be started with --gil-worker' ].
	
	^ super uniqueInstance
]

{ #category : 'private' }
TFGILMainThreadRunner >> primitiveCreateWorker [

	^ self
]

{ #category : 'private' }
TFGILMainThreadRunner >> workerAddress [

	^ (ExternalAddress loadSymbol: 'mainThreadGILWorker') pointerAt: 1
]
