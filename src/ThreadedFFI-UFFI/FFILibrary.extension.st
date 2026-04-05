Extension { #name : 'FFILibrary' }

{ #category : '*ThreadedFFI-UFFI' }
FFILibrary >> callbackRunningStrategy [

	^ self runner callbackRunningStrategy
]

{ #category : '*ThreadedFFI-UFFI' }
FFILibrary >> runner [

	^ TFSameThreadRunner uniqueInstance
]
