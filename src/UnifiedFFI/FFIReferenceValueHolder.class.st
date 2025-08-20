"
This is a special `FFIValueHolder` for referenced objects (structs, opaque objects, etc.)
"
Class {
	#name : 'FFIReferenceValueHolder',
	#superclass : 'FFIValueHolder',
	#category : 'UnifiedFFI-Objects',
	#package : 'UnifiedFFI',
	#tag : 'Objects'
}

{ #category : 'accessing' }
FFIReferenceValueHolder >> arrayOfSize: aNumber [
	| next |

	next := ExternalAddress new 
		adoptAddress: self getHandle;
		yourself.
	^ Array streamContents: [ :stream |
		aNumber timesRepeat: [
			| value |
			value := self typeClass fromHandle: next.
			stream nextPut: value.
			next := next + self typeSize ] ]
]

{ #category : 'private' }
FFIReferenceValueHolder >> typeClass [

	^ self type class
]

{ #category : 'private' }
FFIReferenceValueHolder >> typeSize [

	^ (self typeClass inheritsFrom: FFIStructure)
		ifTrue: [ self typeClass structureSize ]
		ifFalse: [ FFIExternalType pointerSize ]
]

{ #category : 'accessing' }
FFIReferenceValueHolder >> value: anOpaqueObject [

	^ super value: anOpaqueObject getHandle
]
