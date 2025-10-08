Extension { #name : 'FFIFunctionParser' }

{ #category : '*UnifiedFFI-Pharo12' }
FFIFunctionParser class >> parserClass [
	"Sets one time for system the parser class to be used. 
	 This is needed to have compatibility with older versions of Pharo"

	^ RBParser
]
