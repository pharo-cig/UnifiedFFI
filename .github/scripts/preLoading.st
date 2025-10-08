| organizer |

organizer := (Smalltalk classNamed: #RPackageOrganizer) 
	ifNotNil: [ :aClass | aClass default ]
	ifNil: [  self packageOrganizer ].

#( 'BaselineOfThreadedFFI' 'BaselineOfUnifiedFFI' ) 
	do: [ :packageName | organizer removePackage: packageName ]
