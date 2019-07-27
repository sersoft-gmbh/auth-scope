# AuthScope

[![GitHub release](https://img.shields.io/github/release/sersoft-gmbh/AuthScope.svg?style=flat)](https://github.com/sersoft-gmbh/AuthScope/releases/latest)
[![CI Status](https://travis-ci.com/sersoft-gmbh/AuthScope.svg?branch=master)](https://travis-ci.com/sersoft-gmbh/AuthScope)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/c997088f35484726bb1bc6167f074cc4)](https://www.codacy.com/app/ffried/AuthScope?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=sersoft-gmbh/XMLWrangler&amp;utm_campaign=Badge_Grade)
[![codecov](https://codecov.io/gh/sersoft-gmbh/AuthScope/branch/master/graph/badge.svg)](https://codecov.io/gh/sersoft-gmbh/AuthScope)

Handle authentication scopes with ease.

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift`:
```swift
.package(url: "https://github.com/sersoft-gmbh/authscope.git", from: "1.0.0"),
```

### Xcode Project

There is an Xcode project in the `Xcode` folder that you can integrate in your iOS, tvOS, watchOS and / or macOS projects.

### Carthage

While not officially supported, Carthage may work as well:
```cartfile
github sersoft-gmbh/AuthScope ~> 1.0.0
```

## Usage

The main object you want to use is `Scope<AccessRange>`. It's generic and wraps all the logic around a given `AccessRange` type. Since `Scope` can't know what access ranges you have, you need to provide them yourself. Typically, this is done by using an `enum` and conforming it to `AccessRangeProtocol`:
```swift
enum MyAccessRange: String, AccessRangeProtocol, CaseIterable {
    case readPosts = "posts:read"
    case writePosts = "posts:write"

    case readUsers = "users:read"
    case writeUsers = "users:write"
}
```

You can then use your `enum` with `Scope`:
```swift
let postsScope = Scope<MyAccessRange>(accessRanges: .readPosts, .writePosts)

postsScope.contains(.writePosts) // -> true
postsScope.contains(.readUsers) // -> false
```

`Scope` conforms to `SetAlgebra` to make checking access ranges easier:
```swift
let completeScope = Scope<MyAccessRange>.all // `.all` is available when `AccessRange` conforms to `CaseIterable`
completeScope.isSuperset(of: postsScope) // -> true
```

`Scope` is also able to generate a "scope string", since this is usually how they're provided to APIs. The "scope string" contains all access ranges (their `rawValue` to be exact) separated by space. It's important to note that `Scope` does not keep the access ranges in a given order. This means, that it's not guaranteed that two calls to `scopeString` will contain the access ranges in the same order. It is guaranteed, however, that the resulting scope contains all access ranges. `Scope` can of course also be created from a scope string. This initializer will throw an error if any of the contained access ranges is not valid.

```swift
let usersScope: Scope<MyAccessRange> = [.readUsers, .writeUsers]
let string = usersScope.scopeString // -> "users:read users:write" OR "users:write users:read"
let recreatedScope = try Scope<MyAccessRange>(scopeString: string)
usersScope == recreatedScope // true
```

`Scope` is also `Codable` and encodes/decodes itself as its scope string.

Last but not least, Scope also provides some useful regular expression patterns, that can be used to perform matches on a string basis. This is not recommended if your scopes are available as Swift types, but can be useful if you have to match scopes e.g. in a database.
There are currently three regular expression patterns that are provided:
- `exactMatchRegExp`: Returns a pattern that matches a scope string that contains **exactly** the same access ranges. Not more and not less.
- `containsAllRegExp`: Returns a pattern that matches a scope string that contains **all** access ranges, but is allowed to contain more.
- `containsAnyRegExp`: Returns a pattern that matches a scope string that contains **any** access ranges. A match is made as soon as one access range is contained.

## Contributing

If you find a bug / like to see a new feature in AuthScope there are a few ways of helping out:

-   If you can fix the bug / implement the feature yourself please do and open a PR.
-   If you know how to code (which you probably do), please add a (failing) test and open a PR. We'll try to get your test green ASAP.
-   If you can do neither, then open an issue. While this might be the easiest way, it will likely take the longest for the bug to be fixed / feature to be implemented.

## License

See [LICENSE](./LICENSE) file.