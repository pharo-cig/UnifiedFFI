SystemVersion current major = 11 ifTrue: [ 
    MetacelloCommonMCSpecLoader compile: 'resolvePackageSpec: packageSpec gofer: gofer
        | references resolvedReference |
        references := self
            retryingResolvePackageSpecReferences: packageSpec
            gofer: gofer.
        resolvedReference := references last asMetacelloCachingResolvedReference.
        ^ resolvedReference
    '.
]