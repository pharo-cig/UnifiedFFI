"
I am a test library using the VM GIL worker runner.
"
Class {
	#name : 'TFTestLibraryUsingGILWorker',
	#superclass : 'TFTestLibraryUsingSameThreadRunner',
	#category : 'ThreadedFFI-UFFI-Tests',
	#package : 'ThreadedFFI-UFFI-Tests'
}

{ #category : 'accessing' }
TFTestLibraryUsingGILWorker >> runner [

	^ TFGILWorker default
]
