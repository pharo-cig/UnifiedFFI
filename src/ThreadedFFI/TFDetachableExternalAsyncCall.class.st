"
I am an asynchronous call that uses the detachable GIL worker callout path.
This is intended for long-running foreign functions that should release
interpreter ownership around the outer native call while preserving callback
reattach semantics on the same worker thread.
"
Class {
	#name : 'TFDetachableExternalAsyncCall',
	#superclass : 'TFPooledExternalAsyncCall',
	#category : 'ThreadedFFI-Base',
	#package : 'ThreadedFFI',
	#tag : 'Base'
}

{ #category : 'operations' }
TFDetachableExternalAsyncCall >> doExecuteOn: aRunner [

	| aTaskAddress |

	aTaskAddress := aRunner
		executeDetachableFunction: function
		withArguments: parameterArray
		usingSemaphore: self semaphoreIndex.

	self semaphore isSignaled
		ifFalse: [ self semaphore wait ].

	^ aRunner readReturnValueFromTask: aTaskAddress
]
