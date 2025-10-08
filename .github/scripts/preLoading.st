
#( 'BaselineOfThreadedFFI' 'BaselineOfUnifiedFFI' ) do: [ :packageName | 
		(Smalltalk classNamed: #RPackageOrganizer) 
			ifNotNil: [ :aClass | aClass default removePackageNamed: packageName ]
			ifNil: [  self packageOrganizer removePackage: packageName ] ]
