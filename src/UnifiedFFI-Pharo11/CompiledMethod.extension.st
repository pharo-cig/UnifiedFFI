Extension { #name : #CompiledMethod }

{ #category : #'*UnifiedFFI-Pharo11' }
CompiledMethod >> sourcePointer: srcPointer [

	"Drop the #source property if any"
	self removeProperty: #source.
	self setSourcePointer: srcPointer
]

{ #category : #'*UnifiedFFI-Pharo11' }
CompiledMethod >> valueWithReceiver: aReceiver [
	<reflection: 'Message sending and code execution - Arbitrary method/primitive execution'>
	^self receiver: aReceiver withArguments: #() executeMethod: self
]
