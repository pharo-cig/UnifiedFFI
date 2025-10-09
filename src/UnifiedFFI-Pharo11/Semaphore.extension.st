Extension { #name : #Semaphore }

{ #category : #'*UnifiedFFI-Pharo11' }
Semaphore >> signalAll [

	[ self isEmpty ]
	whileFalse: [ self signal ]
]
