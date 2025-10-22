Stdio stdout << (FFIUnix64LibraryFinder newfindLibrary: 'libmongoc-1.0.so'); lf; flush.
Stdio stdout << (FFIUnix64LibraryFinder newfindLibrary: 'libbson-1.0.so'); lf; flush.

SystemVersion current major = 11 ifTrue: [ 
    (Smalltalk at: #MetacelloCommonMCSpecLoader) compile: 'resolvePackageSpec: packageSpec gofer: gofer
        | references resolvedReference |
        references := self
            retryingResolvePackageSpecReferences: packageSpec
            gofer: gofer.
        resolvedReference := references last asMetacelloCachingResolvedReference.
        ^ resolvedReference
    '.
]
