Class {
	#name : 'TFGILWorkerTest',
	#superclass : 'TestCase',
	#category : 'ThreadedFFI-Tests',
	#package : 'ThreadedFFI-Tests'
}

{ #category : 'running' }
TFGILWorkerTest >> runCaseManaged [

	TFFIBackend isAvailable ifFalse: [ ^ self skip ].

	super runCaseManaged
]

{ #category : 'tests' }
TFGILWorkerTest >> testDeferEvaluatesBlockAndReturnsValue [

	self assert: (TFGILWorker default defer: [ 40 + 2 ]) equals: 42
]
