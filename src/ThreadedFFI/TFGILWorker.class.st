"
I am a threaded FFI worker that routes callouts through the VM GIL worker primitive.
Like TFWorker, multiple instances may exist to declare different GIL-capable FFI runners
in the image. The VM is responsible for serializing actual interpreter/GIL ownership so
only one such worker holds it at a given moment.
"
Class {
	#name : 'TFGILWorker',
	#superclass : 'TFWorker',
	#traits : 'TFTGILWorker',
	#classTraits : 'TFTGILWorker classTrait',
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

{ #category : 'executing' }
TFGILWorker >> executeFunction: aTFExternalFunction withArguments: arguments usingSemaphore: anInteger [

	<primitive: 'primitiveGILWorkerCallout' error: ec>

	self primitiveFailed
]

{ #category : 'executing' }
TFGILWorker >> executeDetachableFunction: aTFExternalFunction withArguments: arguments usingSemaphore: anInteger [

	<primitive: 'primitiveDetachableGILWorkerCallout' error: ec>

	self primitiveFailed
]

{ #category : 'private' }
TFGILWorker >> primitiveCreateWorker [

	<primitive: 'primitiveCreateGILWorker'>

	^ self primitiveFailed
]

{ #category : 'private' }
TFGILWorker >> primitiveReleaseWorker [

	<primitive: 'primitiveReleaseGILWorker'>

	^ self primitiveFailed
]
