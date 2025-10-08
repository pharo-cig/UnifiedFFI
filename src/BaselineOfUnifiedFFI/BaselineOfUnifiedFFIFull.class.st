Class {
	#name : 'BaselineOfUnifiedFFIFull',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfUnifiedFFIFull',
	#package : 'BaselineOfUnifiedFFIFull'
}

{ #category : 'baseline' }
BaselineOfUnifiedFFIFull >> baseline: spec [
	<baseline>
	
	spec for: #common do: [
		
		spec 
			"ThreadedFFI"
			package: 'ThreadedFFI';
			package: 'ThreadedFFI-UFFI' with: [ spec requires: #('ThreadedFFI') ];
			package: 'ThreadedFFI-UFFI-Overrides' with: [ spec requires: #('ThreadedFFI-UFFI') ];
			"UnifiedFFI"
			package: 'UnifiedFFI';
			package: 'UnifiedFFI-Tests' with: [ spec requires: #('UnifiedFFI') ];
			package: 'UnifiedFFI-Legacy' with: [ spec requires: #('UnifiedFFI') ];
			package: 'System-OSEnvironments' with: [ spec requires: #('UnifiedFFI') ].
			
		spec 
			group: 'default' with: #('all');
			group: 'minimal' with: #('UnifiedFFI' 'System-OSEnvironments');
			group: 'core' with: #('minimal' 'UnifiedFFI-Tests');
			group: 'legacy' with: #('UnifiedFFI-Legacy');
			group: 'threadedffi' with: #('ThreadedFFI-UFFI-Overrides');
			group: 'all' with: #('core' 'threadedffi') ]
]
