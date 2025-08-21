"
This is a special `FFIValueHolder` for referenced objects (structs, opaque objects, etc.)
"
Class {
	#name : 'FFIReferenceValueHolder',
	#superclass : 'FFIValueHolder',
	#instVars : [
		'typeSize'
	],
	#category : 'UnifiedFFI-Objects',
	#package : 'UnifiedFFI',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
FFIReferenceValueHolder class >> newType: aType size: aNumber [

	^ (self newType: aType)
		typeSize: aNumber;
		yourself
]

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

	^ typeSize
]

{ #category : 'initialization' }
FFIReferenceValueHolder >> typeSize: aNumber [ 

	typeSize := aNumber
]

{ #category : 'accessing' }
FFIReferenceValueHolder >> value: anOpaqueObject [

	^ super value: anOpaqueObject getHandle
]
