Class {
	#name : #BaselineOfUnifiedFFIFull,
	#superclass : #BaselineOf,
	#category : #BaselineOfUnifiedFFIFull
}

{ #category : #baselines }
BaselineOfUnifiedFFIFull >> baseline: spec [
	<baseline>
	
	spec for: #common do: [

		spec 
			"threaded ffi"
			package: 'ThreadedFFI';
			package: 'ThreadedFFI-UFFI' with: [ spec requires: #('ThreadedFFI') ];
			package: 'ThreadedFFI-UFFI-Overrides' with: [ spec requires: #('ThreadedFFI-UFFI') ];
			"tests"
			package: 'ThreadedFFI-Tests' with: [ spec requires: #('ThreadedFFI') ];
			package: 'ThreadedFFI-UFFI-Tests' with: [ spec requires: #('ThreadedFFI-UFFI' 'ThreadedFFI-UFFI-Overrides') ];			
			"unified ffi"
			package: 'UnifiedFFI';
			package: 'UnifiedFFI-Tests' with: [ spec requires: #('UnifiedFFI') ].
			
		spec 
			group: 'default' with: #('all');
			group: 'uffi' with: #('UnifiedFFI');
			group: 'uffi-tests' with: #('uffi' 'UnifiedFFI-Tests');
			group: 'tffi' with: #('ThreadedFFI' 'ThreadedFFI-UFFI' 'ThreadedFFI-UFFI-Overrides');
			group: 'tffi-tests' with: #('tffi' 'ThreadedFFI-Tests' 'ThreadedFFI-UFFI-Tests');
			group: 'all' with: #('tffi-tests' 'uffi-tests') ].
		
	spec for: #(#'pharo12.x' #'pharo11.x') do: [ 
		spec 
			package: 'UnifiedFFI-Pharo12';
			package: 'UnifiedFFI' with: [ spec requires: #('UnifiedFFI-Pharo12') ];
			group: 'uffi' with: #('UnifiedFFI-Pharo12' 'UnifiedFFI') ]
]
