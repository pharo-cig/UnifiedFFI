Extension { #name : #CompiledMethod }

{ #category : #'*UnifiedFFI-Pharo12' }
CompiledMethod >> sourcePointer: srcPointer [

	"Drop the #source property if any"
	self removeProperty: #source.
	self setSourcePointer: srcPointer
]
