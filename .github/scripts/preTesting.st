SystemVersion current major = 11 ifTrue: [ 
    (Smalltalk at: #LibTTYTest) removeSelector: #test3 
]