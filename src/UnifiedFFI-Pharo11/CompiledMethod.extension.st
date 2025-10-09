Extension { #name : #CompiledMethod }

{ #category : #'*UnifiedFFI-Pharo11' }
CompiledMethod >> sourcePointer: srcPointer [

	"Drop the #source property if any"
	self removeProperty: #source.
	self setSourcePointer: srcPointer
]
