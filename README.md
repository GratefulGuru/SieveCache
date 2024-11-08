[![Swift](https://github.com/GratefulGuru/SieveCache/actions/workflows/swift.yml/badge.svg)](https://github.com/GratefulGuru/SieveCache/actions/workflows/swift.yml)
[![codecov](https://codecov.io/gh/GratefulGuru/SieveCache/graph/badge.svg?token=TDQ6YQUGAP)](https://codecov.io/gh/GratefulGuru/SieveCache)
[![Swift 5.9](https://img.shields.io/badge/Swift-5.9-red.svg?style=flat)](https://developer.apple.com/swift)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20Mac%20|%20tvOS-blue.svg)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)


- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
- [Performance](#performance)
- [Credits](#credits)


# Introduction

**SieveCache** is an open source replacement for [`NSCache`](https://developer.apple.com/library/mac/documentation/cocoa/reference/NSCache_Class/Reference/Reference.html) that behaves in a predictable, debuggable way. **SieveCache** is an implementation in Swift of the SIEVE cache explained [here](https://cachemon.github.io/SIEVE-website).


# Installation

SieveCache is distributed as a Swift Package that you can import into your Xcode project or other Swift based code base.

**Note:** SieveCache requires Swift 5.9 (so Xcode 15+) to build, and runs on iOS 13+ and macOS 12+. _It should work<sup>TM</sup>_ on other platforms but has not been tested. Do let me know if you can verify success on other platforms.

To install using Swift Package Manager, add this to the `dependencies:` section in your Package.swift file:

```swift
.package(url: "https://github.com/GratefulGuru/SieveCache.git", from: "1.0.0"),
```


# Usage

You can create an instance of **SieveCache** as follows:

```swift
let cache = SieveCache<String, Int>()
```

This would create a cache of default size (1000 objects), containing `Int` values keyed by `String`. To add an object to the cache, use:

```swift
cache.setObject(99, forKey: "foo")
```

To fetch a cached object, use:

```swift
let object = cache.object(forKey: "foo") // Returns nil if key not found
```

You can limit the cache size by count. This can be done at initialization time:

```swift
let cache = SieveCache<URL, Date>(countLimit: 100)
```

Or after the cache has been created:

```swift
cache.countLimit = 100 // Limit the cache to 100 elements
```

Objects will be removed from the cache automatically when the count limit is exceeded. You can also remove objects explicitly by using:

```swift
let object = cache.removeObject(forKey: "foo")
```

Or, if you don't need the object, by setting it to `nil`:

```swift
cache.setObject(nil, forKey: "foo")
```

And you can remove all objects at once with:

```swift
cache.removeAllObjects()
```

On iOS and tvOS, the cache will be emptied automatically in the event of a memory warning.


# Performance

Reading, writing and removing entries from the cache are performed in constant time. When the cache is full, insertion time degrades slightly due to the need to remove elements each time a new value is inserted. This should still be constant-time.


# Credits

The SieveCache framework is primarily the work of [Christian Wolf Johannsen](https://github.com/GratefulGuru).

([Full list of contributors](https://github.com/GratefulGuru/SieveCache/graphs/contributors))
