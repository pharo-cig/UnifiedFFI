#( 'BaselineOfThreadedFFI' 'BaselineOfUnifiedFFI' ) 
	do: [ :packageName | self packageOrganizer removePackage: packageName ]
