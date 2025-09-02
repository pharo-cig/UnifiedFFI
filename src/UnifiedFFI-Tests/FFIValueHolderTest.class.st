Class {
	#name : 'FFIValueHolderTest',
	#superclass : 'TestCase',
	#category : 'UnifiedFFI-Tests',
	#package : 'UnifiedFFI-Tests'
}

{ #category : 'accessing' }
FFIValueHolderTest >> ffiMethodCharPointerPointer: value [

	^ self 
		ffiCall: #(int TestCharPointerPointerValueHolder(char **value))
		module: 'to-test'
		options: #(+optCallbackCall)
]

{ #category : 'accessing' }
FFIValueHolderTest >> ffiMethodInt: value [

	^ self 
		ffiCall: #(int TestIntValueHolder(int *value))
		module: 'to-test'
		options: #(+optCallbackCall)
]

{ #category : 'accessing' }
FFIValueHolderTest >> ffiMethodIntPointer: value [

	^ self 
		ffiCall: #(int TestIntPointerValueHolder(int *value))
		module: 'to-test'
		options: #(+optCallbackCall)
]

{ #category : 'accessing' }
FFIValueHolderTest >> ffiMethodStructPointerPointer: value [

	^ self 
		ffiCall: #(int TestStructPointerPointerValueHolder(FFITestStructure **value))
		module: 'to-test'
		options: #(+optCallbackCall)
]

{ #category : 'accessing' }
FFIValueHolderTest >> ffiMethodStructure: value [

	^ self 
		ffiCall: #(int TestStructureValueHolder (FFITestStructure *value))
		module: 'to-test'
		options: #(+optCallbackCall)
]

{ #category : 'running' }
FFIValueHolderTest >> tearDown [

	self class methods
		select: [ :each | (each selector beginsWith: 'ffi') and: [ each hasProperty: #ffiNonCompiledMethod ] ]
		thenDo: [ :each | FFIMethodRegistry uniqueInstance resetMethod: each ].
	FFICallbackFunctionResolution reset.
	
	super tearDown
]

{ #category : 'tests' }
FFIValueHolderTest >> testBasicTypeCanBeHolded [
	| holder |

	holder := FFIInt64 newValueHolder.

	self assert: holder type class equals: FFIInt64.
	self assert: (holder getHandle isKindOf: ByteArray).
	self assert: holder getHandle size equals: FFIInt64 newBuffer size.	
	holder value: 42.
	self assert: holder value equals: 42.
	
	self 
		assert: holder getHandle 
		equals: (FFIInt64 newBuffer
			signedLongAt: 1 put: 42;
			yourself)
]

{ #category : 'tests' }
FFIValueHolderTest >> testCallBasicValueWithValueHolder [
	| holder result resultValue |
	
	holder :=  FFIInt64 newValueHolder.
	
	FFICallbackFunctionResolution 
		registerCallback: (FFICallback 
			signature: #(int (void *aValue)) 
			block: [ :aValue |
				aValue signedLongAt: 1 put: 42.
				1 ])
		as: #TestIntValueHolder.

	result := self ffiMethodInt: holder.
	
	self assert: result equals: 1.
	resultValue := holder value.
	self assert: resultValue equals: 42
]

{ #category : 'tests' }
FFIValueHolderTest >> testCallCharPointerPointerWithValueHolder [
	| holder result string |
	
	holder :=  FFIOop newValueHolder.
	
	FFICallbackFunctionResolution 
		registerCallback: (FFICallback 
			signature: #(int (char **aValue)) 
			block: [ :aValue |
				| externalString |
				externalString := ExternalAddress fromString: 'Hello, World'.
				aValue pointerAt: 1 put: externalString.
				1 ])
		as: #TestCharPointerPointerValueHolder.

	result := self ffiMethodCharPointerPointer: holder.
	
	self assert: result equals: 1.
	string := holder value.
	self 
		assert: string utf8StringFromCString
		equals: 'Hello, World'.
	string free
]

{ #category : 'tests' }
FFIValueHolderTest >> testCallIntPointerWithValueHolder [
	| holder result resultIntegers |
	
	"since I will keep a list of integers (and not just one integer), 
	 I will need a pointer holder (otherwise the buffer will have a wrong size)"
	holder :=  FFIOop newValueHolder.

	FFICallbackFunctionResolution 
		registerCallback: (FFICallback 
			signature: #(int (int *aValue)) 
			block: [ :aValue |
				| integers |
				integers := ExternalAddress allocate: FFIInt32 externalTypeSize * 5.
				integers signedLongAt: 1 put: 1.
				integers signedLongAt: 5 put: 2.
				integers signedLongAt: 9 put: 3.
				integers signedLongAt: 13 put: 4.
				integers signedLongAt: 17 put: 42.
				aValue pointerAt: 1 put: integers.
				1 ])
		as: #TestIntPointerValueHolder.

	result := self ffiMethodIntPointer: holder.

	self assert: result equals: 1.
	resultIntegers := holder arrayOf: #int size: 5.
	self 
		assert: resultIntegers
		equals: #(1 2 3 4 42).
	holder value free
]

{ #category : 'tests' }
FFIValueHolderTest >> testCallStructPointerPointerWithValueHolder [
	"The test validates that a structuture can be passed to in struct** format 
	 and the value holder will be capable of give back a list of structs. 
	 This is needed, for example, on functions like clang_tokenize (libclang), 
	 who has this signature: 
	 
	 CINDEX_LINKAGE void clang_tokenize (
	 		CXTranslationUnit  	TU,
			CXSourceRange  		Range,
			CXToken **  		Tokens,
			unsigned *  		NumTokens) 	
	
	Here, we want to test the CXToken **Tokens part. 
	To test it, I install first a function which the signature to test, using 
	the optCallbackCall mechanism of uFFI that allows me to install a callback as a 
	function. 
	Once I have the function installed, I call it and proceed to test the answer (this 
	is the real test), and validate I can get a list of structures from the value 
	holder"
	| holder result |
	
	holder :=  FFITestStructure newValueHolder.
	
	"Install callback as function TestStructPointerPointerValueHolder"
	FFICallbackFunctionResolution 
		registerCallback: (FFICallback 
			signature: #(int (FFITestStructure **aValue)) 
			block: [ :aValue |
				| bytes allocated |
				bytes := ByteArray streamContents: [ :stream |
					0 to: 2 do: [ :i | 
						stream nextPutAll: (FFITestStructure new 
							long: 42 + i;
							getHandle) ] ].
				allocated := ExternalAddress allocate:bytes size.
				LibC memCopy: bytes to: allocated size: bytes size.
				aValue pointerAt: 1 put: allocated.
				3 ])
		as: #TestStructPointerPointerValueHolder.
	"Call function"
	result := self ffiMethodStructPointerPointer: holder.
	
	"Assert results"
	self assert: result equals: 3.
	self 
		assert: ((holder arrayOfSize: 3) collect: #long) 
		equals: #(42 43 44).
		
	"Free allocated value. Yes, this leaks if the test fails."
	holder value getHandle free.
]

{ #category : 'tests' }
FFIValueHolderTest >> testCallStructureWithValueHolder [
	| holder result resultStruct |
	
	holder :=  FFITestStructure newValueHolder.
	
	FFICallbackFunctionResolution 
		registerCallback: (FFICallback 
			signature: #(int (void *aValue)) 
			block: [ :aValue |
				| struct |
				struct := FFITestStructure externalNew.
				struct byte: 42.
				aValue pointerAt: 1 put: struct getHandle.
				1 ])
		as: #TestStructureValueHolder.

	result := self ffiMethodStructure: holder.
	
	self assert: result equals: 1.
	resultStruct := holder value.
	self assert: resultStruct byte equals: 42.
	resultStruct free
]

{ #category : 'tests' }
FFIValueHolderTest >> testOpaqueObjectTypeCanBeHolded [
	| holder |

	holder := FFIOpaqueObject newValueHolder.

	self assert: holder type class equals: FFIOpaqueObject.
	self assert: (holder getHandle isKindOf: ByteArray).
	self assert: holder getHandle size equals: FFIOpaqueObject newBuffer size.	

	holder value: (FFIOpaqueObject fromHandle: (ExternalAddress fromAddress: 42)).
	self assert: holder value getHandle equals: (ExternalAddress fromAddress: 42)
]

{ #category : 'tests' }
FFIValueHolderTest >> testStructureTypeCanBeHolded [
	| holder |
	
	holder :=  FFITestStructure newValueHolder.
	self assert: holder type class equals: FFITestStructure.
	self assert: (holder getHandle isKindOf: ByteArray).
	self assert: holder getHandle size equals: FFITestStructure newBuffer size.	
	"this can't be like this (the structure tries to be filled with the handle)"
	"holder value: (structClass fromHandle: (ExternalAddress fromAddress: 42)).
	self assert: holder value getHandle equals: (ExternalAddress fromAddress: 42)"
]
