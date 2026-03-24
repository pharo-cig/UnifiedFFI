Class {
	#name : 'FFIStructFieldSlot',
	#superclass : 'Slot',
	#instVars : [
		'type',
		'offset'
	],
	#category : 'UnifiedFFI-Base',
	#package : 'UnifiedFFI',
	#tag : 'Base'
}

{ #category : 'comparing' }
FFIStructFieldSlot >> = other [

	^ super = other and: [
		self type = other type and: [
		self offset = other offset ] ]
]

{ #category : 'code generation' }
FFIStructFieldSlot >> emitStore: aMethodBuilder [
	"generate bytecode 'type basicHandle: handle at: offset put: aValue'"

	| tempName |
	tempName := '0slotTempForStackManipulation'.
	aMethodBuilder
		addTemp: tempName;
		storeTemp: tempName;
		popTop;
		pushLiteral: type;
		pushInstVar: 1; "handle"
		pushLiteral: offset;
		pushTemp: tempName;
		send: #basicHandle:at:put:
]

{ #category : 'code generation' }
FFIStructFieldSlot >> emitValue: methodBuilder [
	"generate bytecode for 'type basicHandle: handle at: offset"

	methodBuilder
		pushLiteral: type;
		pushInstVar: 1; "handle"
		pushLiteral: offset;
		send: #basicHandle:at:
]

{ #category : 'accessing' }
FFIStructFieldSlot >> offset [

	^ offset
]

{ #category : 'accessing' }
FFIStructFieldSlot >> offset: anInteger [

	offset := anInteger
]

{ #category : 'printing' }
FFIStructFieldSlot >> printOn: aStream [

	super printOn: aStream

"	aStream
		store: self name;
		nextPutAll: ' => (';
		nextPutAll: self class name;
		nextPutAll: ' type: (';
		print: type;
		nextPutAll: '); offset: ';
		print: offset;
		nextPutAll: ')'"
]

{ #category : 'meta-object-protocol' }
FFIStructFieldSlot >> read: anObject [
	<reflection: 'Object Inspection - State inspection'>

	^ type basicHandle: anObject getHandle at: offset
]

{ #category : 'accessing' }
FFIStructFieldSlot >> type [

	^ type
]

{ #category : 'accessing' }
FFIStructFieldSlot >> type: aFFIExternalType [

	type := aFFIExternalType
]

{ #category : 'meta-object-protocol' }
FFIStructFieldSlot >> write: aValue to: anObject [
	<reflection: 'Object Modification - State modification'>

	type basicHandle: anObject getHandle at: offset put: aValue
]
