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

{ #category : 'private' }
TFGILWorker >> applyThreadName [

	name ifNil: [ ^ self ].
	self isNull ifTrue: [ ^ self ].
	self primitiveSetWorkerName: name, ' (GIL)'
]

{ #category : 'executing' }
TFGILWorker >> executeFunction: aTFExternalFunction withArguments: arguments usingSemaphore: anInteger [

	<primitive: 'primitiveGILWorkerCallout' error: ec>

	self primitiveFailed
]
