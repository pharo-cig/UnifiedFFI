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

{ #category : 'executing' }
TFGILWorker >> executeFunction: aTFExternalFunction withArguments: arguments usingSemaphore: anInteger [

	<primitive: 'primitiveGILWorkerCallout' error: ec>

	self primitiveFailed
]

{ #category : 'executing' }
TFGILWorker >> defer: aBlock [

	| resultHolder deferredProcess |
	resultHolder := Array new: 2.
	deferredProcess := [
		[ resultHolder
			at: 1 put: true;
			at: 2 put: aBlock value ]
			on: Exception
			do: [ :ex |
				resultHolder
					at: 1 put: false;
					at: 2 put: ex ].
		self primitiveLeaveGILWorkerContext ] newProcess.

	self primitiveGILWorkerDeferProcess: deferredProcess.

	(resultHolder at: 1)
		ifTrue: [ ^ resultHolder at: 2 ].

	(resultHolder at: 2) signal
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
