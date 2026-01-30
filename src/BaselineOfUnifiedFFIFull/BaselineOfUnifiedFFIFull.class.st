Class {
	#name : 'BaselineOfUnifiedFFIFull',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfUnifiedFFIFull',
	#package : 'BaselineOfUnifiedFFIFull'
}

{ #category : 'accessing' }
BaselineOfUnifiedFFIFull class >> project [
	
	^ super project
		loadType: #atomic;
		yourself
]

{ #category : 'doits' }
BaselineOfUnifiedFFIFull >> afterLoadingPharo11 [
	
	(self class environment classNamed: #Author)
		useAuthor: 'TheInstaller'
		during: [ self overrideStrictMode ].
	SystemProgressMorph enable; reset.
]

{ #category : 'doits' }
BaselineOfUnifiedFFIFull >> afterLoadingPharo12 [
	
	self overrideStrictMode
]

{ #category : 'baselines' }
BaselineOfUnifiedFFIFull >> baseline: spec [
	<baseline>

	spec for: #common do: [

		spec 
			"kernel"
			package: 'FFI-Kernel';
			"threaded ffi"
			package: 'ThreadedFFI';
			package: 'ThreadedFFI-UFFI' with: [ spec requires: #('ThreadedFFI') ];
			package: 'ThreadedFFI-UFFI-Overrides' with: [ spec requires: #('ThreadedFFI-UFFI') ];
			"tests"
			package: 'ThreadedFFI-Tests' with: [ spec requires: #('ThreadedFFI') ];
			package: 'ThreadedFFI-UFFI-Tests' with: [ spec requires: #('ThreadedFFI-UFFI' 'ThreadedFFI-UFFI-Overrides') ];			
			"unified ffi"
			package: 'UnifiedFFI' with: [ spec requires: #('FFI-Kernel') ];
			package: 'UnifiedFFI-Tests' with: [ spec requires: #('UnifiedFFI') ].
			
		spec 
			group: 'default' with: #('all');
			group: 'kernel' with: #('FFI-Kernel'); 
			group: 'UFFI' with: #('UnifiedFFI');
			group: 'UFFI-Tests' with: #('uFFI' 'UnifiedFFI-Tests');
			group: 'TFFI' with: #('ThreadedFFI' 'ThreadedFFI-UFFI' 'ThreadedFFI-UFFI-Overrides');
			group: 'TFFI-Tests' with: #('TFFI' 'ThreadedFFI-Tests' 'ThreadedFFI-UFFI-Tests');
			group: 'all' with: #('kernel' 'TFFI-Tests' 'UFFI-Tests') ].
		
	spec for: #'pharo12.x' do: [ 
		spec postLoadDoIt: #afterLoadingPharo12.
		spec 
			package: 'UnifiedFFI-Pharo12';
			package: 'UnifiedFFI' with: [ spec requires: #('UnifiedFFI-Pharo12') ];
			group: 'UFFI' with: #('UnifiedFFI-Pharo12' 'UnifiedFFI') ].
	
	spec for: #'pharo11.x' do: [
		spec preLoadDoIt: #beforeLoadingPharo11.
		spec postLoadDoIt: #afterLoadingPharo11.
		spec 
			package: 'UnifiedFFI-Pharo11';
			package: 'UnifiedFFI' with: [ spec requires: #('UnifiedFFI-Pharo11') ];
			group: 'UFFI' with: #('UnifiedFFI-Pharo11' 'UnifiedFFI') ]
]

{ #category : 'doits' }
BaselineOfUnifiedFFIFull >> beforeLoadingPharo11 [

	"I need to disable SystemProgressMorph during the loading of UFFI 
	 because the text generation uses FFI to do some operations and well... 
	 that will not play nicely :)"
	SystemProgressMorph disable
]

{ #category : 'doits' }
BaselineOfUnifiedFFIFull >> overrideStrictMode [
	
	"Override strict mode because we did not have it in this version"
	FFILibrary class compile: 'options
	^ #()'.

]
