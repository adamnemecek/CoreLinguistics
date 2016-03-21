# LangKit

[![Build Status](https://travis-ci.org/xinranmsn/LangKit.svg?branch=master)](https://travis-ci.org/xinranmsn/LangKit)

Computational Linguistics in Swift

**In construction**

Author: Richard Wei

License: The University of Illinois/NCSA Open Source License (NCSA)

## Build

### OS X 10.11

You can use Xcode 7.2 **or** the Swift 3 development snapshot. Xcode is recommended if you need a Playground.

#### Xcode 7.2

It should work without any additional configurations.

#### Swift 3 development snapshot

Make sure you have added Swift 3's `bin` to `PATH`.

```
$ swift build
```

You may want to run the above command again if LangKitTests fail to build. It's a Swift Package Manager issue.

### Ubuntu 14.04

Make sure you have Swift 3 development snapshot's `bin` added to `PATH`.

```
$ swift build
```

Tests fail to build just as they should. There will be a workaround when `swift-corelibs-xctest` gets a good shape.