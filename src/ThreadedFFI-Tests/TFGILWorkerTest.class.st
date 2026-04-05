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

{ #category : 'accessing' }
TFGILWorkerTest >> libraryPath [

	OSPlatform current isUnix ifTrue: [ ^ 'libTestLibrary.so' ].
	OSPlatform current isMacOS ifTrue: [ ^ 'libTestLibrary.dylib' ].
	OSPlatform current isWindows ifTrue: [ ^ 'TestLibrary.dll' ].

	self error: 'Unsupported Platform'
]

{ #category : 'tests' }
TFGILWorkerTest >> testDeferEvaluatesBlockAndReturnsValue [

	self assert: (TFGILWorker default defer: [ 40 + 2 ]) equals: 42
]

{ #category : 'tests' }
TFGILWorkerTest >> testCallbackExecutesInsideGILWorkerContext [

	| callback function returnValue ranInGILContext worker |
	worker := TFGILWorker default.
	ranInGILContext := false.

	callback := (TFCallback
		forCallback: [ :value |
			ranInGILContext := worker isInGILWorkerContext.
			value + 1 ]
		parameters: { TFBasicType sint32 }
		returnType: TFBasicType sint32
		runner: worker)
			runStrategy: worker callbackRunningStrategy;
			yourself.

	function := TFExternalFunction
		name: 'singleCallToCallback'
		moduleName: self libraryPath
		definition: (TFFunctionDefinition
			parameterTypes: { TFBasicType pointer. TFBasicType sint32 }
			returnType: TFBasicType sint32).

	returnValue := worker invokeFunction: function withArguments: { callback getHandle. 3 }.

	self assert: returnValue equals: 5.
	self assert: ranInGILContext
]
