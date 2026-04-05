"
I execute callback bodies on the borrowed-owner GIL worker thread by reusing
the defer: path instead of running them on the generic callback queue process.
"
Class {
	#name : 'TFGILWorkerCallbackRunStrategy',
	#superclass : 'Object',
	#category : 'ThreadedFFI-Callbacks',
	#package : 'ThreadedFFI',
	#tag : 'Callbacks'
}

{ #category : 'executing' }
TFGILWorkerCallbackRunStrategy >> executeCallback: aCallbackInvocation on: aTFRunner [

	aTFRunner handleExceptionDuring: [
		aTFRunner defer: [ aCallbackInvocation execute ] ]
]
