Class {
	#name : #BaselineOfUnifiedFFIFull,
	#superclass : #BaselineOf,
	#category : #BaselineOfUnifiedFFIFull
}

{ #category : #baselines }
BaselineOfUnifiedFFIFull >> afterLoadingPharo11 [

	SystemProgressMorph enable; reset
]

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
		
	spec for: #'pharo12.x' do: [ 
		spec 
			package: 'UnifiedFFI-Pharo12';
			package: 'UnifiedFFI' with: [ spec requires: #('UnifiedFFI-Pharo12') ];
			group: 'uffi' with: #('UnifiedFFI-Pharo12' 'UnifiedFFI') ].
	
	spec for: #'pharo11.x' do: [
		spec preLoadDoIt: #beforeLoadingPharo11.
		spec postLoadDoIt: #afterLoadingPharo11.
		spec 
			package: 'UnifiedFFI-Pharo11';
			"this one needs to be applied after loading"
			package: 'UnifiedFFI-Pharo11-Overrides' with: [ spec requires: #('UnifiedFFI') ];
			package: 'UnifiedFFI' with: [ spec requires: #('UnifiedFFI-Pharo11') ];
			group: 'uffi' with: #('UnifiedFFI-Pharo11' 'UnifiedFFI' 'UnifiedFFI-Pharo11-Overrides') ]
]

{ #category : #baselines }
BaselineOfUnifiedFFIFull >> beforeLoadingPharo11 [

	"I need to disable SystemProgressMorph during the loading of UFFI 
	 because the text generation uses FFI to do some operations and well... 
	 that will not play nicely :)"
	SystemProgressMorph disable
]
