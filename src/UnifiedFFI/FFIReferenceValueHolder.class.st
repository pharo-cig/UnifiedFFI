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
FFIReferenceValueHolder >> value: anOpaqueObject [

	^ super value: anOpaqueObject getHandle
]
