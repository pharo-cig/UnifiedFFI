"
I represent the launcher-provided GIL worker that is bound to the process main thread.
It is only available when the VM was started with --gil-worker.
"
Class {
	#name : 'TFGILMainThreadWorker',
	#superclass : 'TFMainThreadRunner',
	#traits : 'TFTGILWorker',
	#classTraits : 'TFTGILWorker classTrait',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'ThreadedFFI-Worker',
	#package : 'ThreadedFFI',
	#tag : 'Worker'
}

{ #category : 'accessing' }
TFGILMainThreadWorker class >> default [

	^ self uniqueInstance
]

{ #category : 'testing' }
TFGILMainThreadWorker class >> isAvailable [

	<primitive: 'primitiveHasMainThreadGILWorker' error: ec>

	^ false
]

{ #category : 'accessing' }
TFGILMainThreadWorker class >> uniqueInstance [

	self isAvailable ifFalse: [ self error: 'Main-thread GIL worker requires the VM to be started with --gil-worker' ].
	^ uniqueInstance ifNil: [
		uniqueInstance := self new
			name: 'Main Thread GIL';
			yourself ]
]

{ #category : 'private' }
TFGILMainThreadWorker >> doInitialize [

	super doInitialize.
	MainThreadHandle := self workerAddress.
	handle := MainThreadHandle.
	self applyThreadName
]

{ #category : 'private' }
TFGILMainThreadWorker >> primitiveCreateWorker [

	^ self
]

{ #category : 'private' }
TFGILMainThreadWorker >> workerAddress [

	^ (ExternalAddress loadSymbol: 'mainThreadGILWorker') pointerAt: 1
]
