"In Pharo11 I need to discard changes because Metacello was not working 
 correctly at the time and it was not respecting the 'ignoreImage' flag.
 WARNING: This will work if registerInIceberg=true in .smalltalk.ston"
SystemVersion current major = 11 ifTrue: [ 
    [ 
        IceRepository registry 
            detect: [ :each | each name = 'UnifiedFFI' ]
            ifFound: [ :aRepository | aRepository discardChanges ] ]
    on: Warning 
    do: [ :w | 
        w asString printString.
        w resume ] 
]