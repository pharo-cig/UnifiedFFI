# UnifiedFFI

[![Test](https://github.com/pharo-cig/UnifiedFFI/actions/workflows/test.yml/badge.svg)](https://github.com/pharo-cig/UnifiedFFI/actions/workflows/test.yml)

This version of UnifiedFFI (and ThreadedFFI) is aligned with latest Pharo version (whatever it is when you read this).  
Is available to provide compatibility with users of older Pharo versions. 

## Install instructions

```smalltalk
Metacello new
	repository: 'github://pharo-cig/UnifiedFFI:v1.2';
	baseline: 'UnifiedFFIFull';
	onConflict: [ :n | n useIncoming ];
	onUpgrade: [ :n | n useIncoming ];
	ignoreImage;
	load.
```

**NOTE:** `v1.2` is a stable tag, use the last release 😄
