[<p align="center"><img alt="Boilerplate" src="http://cdn.movieweb.com/img.news/NEnBKLdGEGLarq_1_1.jpg"></p>](#boilerplate)

# Boilerplate

![🐧 linux: ready](https://img.shields.io/badge/%F0%9F%90%A7%20linux-ready-red.svg)
[![Build Status](https://travis-ci.org/crossroadlabs/Boilerplate.svg?branch=master)](https://travis-ci.org/crossroadlabs/Boilerplate)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Platform OS X | iOS | tvOS | watchOS | Linux](https://img.shields.io/badge/platform-OS X | iOS | tvOS | watchOS | Linux-orange.svg)
![Swift version](https://img.shields.io/badge/Swift-3.2-blue.svg)
[![GitHub license](https://img.shields.io/badge/license-Apache 2.0-lightgrey.svg)](https://raw.githubusercontent.com/crossroadlabs/Regex/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/crossroadlabs/Boilerplate.svg)](https://github.com/crossroadlabs/Boilerplate/releases)

## Swift boilerplate code library with tons of useful stuff, including Linux compatibility layers and functional compositions

## Goals

[<img align="left" src="https://raw.githubusercontent.com/crossroadlabs/Express/master/logo-full.png" hspace="20" height=128>](https://github.com/crossroadlabs/Express) Boilerplate library was mainly introduced to fulfill the needs of [Swift Express](https://github.com/crossroadlabs/Express) - web application server side framework for Swift. Now it's a part of Crossroad Labs Foundation.

Still we hope it will be useful for everybody else.

[May less boilerplate code be with you ;)](#examples)

## Getting started

### Installation

#### [Package Manager](https://swift.org/package-manager/)

Add the following dependency to your [Package.swift](https://github.com/apple/swift-package-manager/blob/master/Documentation/Package.swift.md):

```swift
.Package(url: "https://github.com/crossroadlabs/Boilerplate.git", majorVersion: 0)
```

Run ```swift build``` and build your app. Package manager is supported on OS X, but it's still recommended to be used on Linux only.

#### [Carthage](https://github.com/Carthage/Carthage)
Add the following to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

```
github "crossroadlabs/Boilerplate"
```

Run `carthage update` and follow the steps as described in Carthage's [README](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

#### [CocoaPods](http://cocoapods.org/)
Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```rb
pod 'Boilerplate'
```

Make sure that you are integrating your dependencies using frameworks: add `use_frameworks!` to your Podfile. Then run `pod install`.

### Examples

#### Swift 3.0:

Swift 3.0 has a pretty much different API in standard library from Swift 2.2. You can import Boilerplate and the code below (Swift 3.0 style) will just work with your Swift 2.2 compiler:

```swift
var array = ["a", "b", "c"]
        
array.append(contentsOf: ["e"]) //this is not correct in Swift 2.2 without Boilerplate
```

#### Useful utility classes (like Timeout):

Just a quick example, showing how easy it is to manage different time APIs with Timeout:

```swift
let to = Timeout.Infinity
XCTAssertEqual(to.timeSinceNow(), NSDate.distantFuture())
XCTAssertEqual(to.timeInterval, Double.infinity)

//convert to NSTimeInterval
to.timeInterval

//convert to NSDate
to.timeSinceNow()

//convert to dispatch_time_t
to.dispatchTime
```

#### Curry/Uncurry

The idea behind is to transform `(A, B, C...)->Z` to `(A)->(B)->(C)->...->Z`, which is called __currying__ und __uncurrying__ respectively.

```swift
func ftwo(b:Bool, i:Int) -> String {
    return String(b) + "_" + String(i)
}

let ctwo = curry(ftwo)
print(ctwo(true)(1)) //call curried function
let utwo = uncurry(ctwo)
print(utwo(false, 0)) //uncurried back works as expected
```

#### Apply

Allows to partieally or fully apply a function with tuple:

```
func fthree(b:Bool, i:Int, d:Double) -> String {
    return String(b) + "_" + String(i) + "_" + String(d)
}

let fbi = (__, __, 1.0) |> fthree //operator way, __ stands for an argument
//you don't want to apply right now.
let fi = (true, __, 1.0) |> fthree //operator way
let fd = apply(args: (true, 1, _), to: fthree) //function way

print(fbi(false, 0)) //prints "false_0_1.0"
print(fi(0)) //prints "true_0_1.0"
print(fd(0.0)) //prints "true_1_0.0"
print((false, 0, 0.0) |> fthree) //full apply, prints "false_0_0.0"
```

#### Weak Apply

Works like apply, though weakly. I.e. the argument passed is not retained. For now works with single argument only. Is a lot useful within `UIViewController` to avoid retension of `self`:

```
//func inside UIViewController

//just imagine it does something very important
func mymagicfunc(s:String) {
	print(self, s)
}

//your very advanced int formatting dependent on self
func myintformat(i:Int) -> String {
	return self._formatWith(self._format, i)
}

//you can safely do that and self is not retained
//any calls to self._myprocstored will just do nothing if self isn't there anymore
self._myprocstored = self ~> ViewController.mymagicfunc

//format now has a signature of `(Int)->String?`; ? is not a mistake
let format = self ~> ViewController.myintformat

```

format is a special function here. Which will return a value is `self` exists and `nil` if doesn't. The return value is changed to `Optional`.

#### Tuple flattening

OK, you have a tuple of like `((A, B), C)`, but you need (A, B, C)? This is called tuple flattening and can be done with:

```swift
let t = ((true, 1), 1.0)
flatten(t) //here you get: (true, 1, 1.0)
```

#### Function tuplification

Unfortunately it's no longer possible in Swift to apply tuple to a function with several argumens. You can do it with boilerplate `apply` (`|>` operator form) or tuplify a function:

```swift
func fthree(b:Bool, i:Int, d:Double) -> String {
    return String(b) + "_" + String(i) + "_" + String(d)
}

let tuple = (false, 1, 0.0)
print(tuplify(fthree)(tuple)) //prints "false_1_0.0"
```

### Further

Examples above are just a quick intro to what Boilerplate can bring you. Take a look inside and see yourself. It handles __NS Bridging__ and exact type comparison in case you want to avoid __Automatic Bridging__, some __Funtional__ extensions, __CF Bridging__, __Error Handling__ including low level __C APIs Error Handling__, __Collections Routines__ i.e. __Collections Zipping__, __Crossplatform Threads__ and much more.

Contributions are welcome. Let's get rid of boilerplate code in Swift together.

### Keep your code clean ;)

## Changelog

* v0.2.3
	* Renamed zip to zipWith(other:) not to collide with built in zip
* v0.2.2
	* Minor Swift 3.0 Array fixes
* v0.2.1
	* Range shims for Swift 3.0
* v0.2.0
	* Swift 3.0 preview 1 support
	* Null pointers workarounds (Swift 3.0/2.x related)
* v0.1.x:
	* Obj-C Bridging utils
	* Fatal errors
	* C error handling
	* AnyError
	* ZippedSequence
	* NonStrictEquatable
	* Timeout (and conversion to different formats)
	* tiny ThreadLocal and Thread
	* Tasks
	* Invalidation tokens
	* Swift 3.0 shimming
	* Linux/Mac incompatibilities fixes

## Contributing

To get started, <a href="https://www.clahub.com/agreements/crossroadlabs/Boilerplate">sign the Contributor License Agreement</a>.

## [![Crossroad Labs](http://i.imgur.com/iRlxgOL.png?1) by Crossroad Labs](http://www.crossroadlabs.xyz/)