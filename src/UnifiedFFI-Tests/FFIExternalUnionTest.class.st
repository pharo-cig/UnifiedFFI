"
Tests for external unions
"
Class {
	#name : 'FFIExternalUnionTest',
	#superclass : 'TestCase',
	#category : 'UnifiedFFI-Tests-Tests',
	#package : 'UnifiedFFI-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
FFIExternalUnionTest >> testUnionAccess [
	| union |
	union := FFITestUnion new.
	self deny: union getHandle class equals: ExternalAddress.
	self deny: union isNull.

	union int64: 16r060504030201.
	self assert: union byte equals: 16r01.
	self assert: union short equals: 16r0201.
	self assert: union long equals: 16r060504030201.
	self assert: union int64 equals: 16r060504030201.
	self assert: union float ~= 0.
	self assert: union double ~= 0
]
