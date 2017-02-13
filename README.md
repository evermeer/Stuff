# Stuff

[![Issues](https://img.shields.io/github/issues-raw/evermeer/Stuff.svg?style=flat)](https://github.com/evermeer/Stuff/issues)
[![Documentation](https://img.shields.io/badge/documented-100%25-green.svg?style=flat)](http://cocoadocs.org/docsets/Stuff/)
[![Stars](https://img.shields.io/github/stars/evermeer/Stuff.svg?style=flat)](https://github.com/evermeer/Stuff/stargazers)
[![Downloads](https://img.shields.io/cocoapods/dt/Stuff.svg?style=flat)](https://cocoapods.org/pods/Stuff)


[![Version](https://img.shields.io/cocoapods/v/Stuff.svg?style=flat)](http://cocoadocs.org/docsets/Stuff)
[![Language](https://img.shields.io/badge/language-swift 3-f48041.svg?style=flat)](https://developer.apple.com/swift)
[![Platform](https://img.shields.io/cocoapods/p/Stuff.svg?style=flat)](http://cocoadocs.org/docsets/Stuff)
[![License](https://img.shields.io/cocoapods/l/Stuff.svg?style=flat)](http://cocoadocs.org/docsets/Stuff)

[![Git](https://img.shields.io/badge/GitHub-evermeer-blue.svg?style=flat)](https://github.com/evermeer)
[![Twitter](https://img.shields.io/badge/twitter-@evermeer-blue.svg?style=flat)](http://twitter.com/evermeer)
[![LinkedIn](https://img.shields.io/badge/linkedin-Edwin Vermeer-blue.svg?style=flat)](http://nl.linkedin.com/in/evermeer/en)
[![Website](https://img.shields.io/badge/website-evict.nl-blue.svg?style=flat)](http://evict.nl)
[![eMail](https://img.shields.io/badge/email-edwin@evict.nl-blue.svg?style=flat)](mailto:edwin@evict.nl?SUBJECT=About Stuff)

# General information

Stuff is a collection of code 'snippets' that are to small to create a library for and which do not fit in an other library. Run the unit tests to see the code in action.

- [Print](#print) - For creating a nice output log
- [Enum](#enum) - Adding functionality to an enum

## Print

You can install this by adding the following line to your Podfile:

```
pod "Stuff/Print"
```

The Stuff.print function is meant to be a replacement for the standard .print function. It will give you extra information about when and where the print function was executed. Besides that there is also support for different log levels and you can specify the minimum log level that should be in the output.

Here are some samples:

```swift
    Stuff.print("Just as the standard print but now with detailed information")
    Stuff.print("Now it's a warning", .warn)
    Stuff.print("Or even an error", .error)

    Stuff.minimumLogLevel = .error
    Stuff.print("Now you won't see normal log output")
    Stuff.print("Only errors are shown", .error)

    Stuff.minimumLogLevel = .none
    Stuff.print("Or if it's disabled you won't see any log", .error)    
```

The output of the code above is:

```console
✳️ .debug ⏱ 02/13/2017 09:52:51:852 📱 xctest [18960:?] 📂 PrintStuffTests.swift(15) ⚙️ testExample() ➡️
    Just as the standard print but now with detailed information

⚠️ .warn ⏱ 02/13/2017 09:52:51:855 📱 xctest [18960:?] 📂 PrintStuffTests.swift(16) ⚙️ testExample() ➡️
    Now it's a warning

🚫 .error ⏱ 02/13/2017 09:52:51:855 📱 xctest [18960:?] 📂 PrintStuffTests.swift(17) ⚙️ testExample() ➡️
    Or even an error

🚫 .error ⏱ 02/13/2017 09:52:51:855 📱 xctest [18960:?] 📂 PrintStuffTests.swift(21) ⚙️ testExample() ➡️
    Only errors are shown
```

## Enum

You can install this by adding the following line to your Podfile:

```
pod "Stuff/Enum"
```

- getting all possible enum values in an arry
- getting the associated value of any enum
- converting an array of enums with associated values to a dictionary or an query string.
- get the raw value of an enum even it it was passed in an any


```swift
// You have to extend the enum with the Enum protocol
enum test1: String, Enum {
    case option1
    case option2
    case option3
}

enum test2: Enum {
    case option4(String)
    case option5(Int)
    case option6(Int, String)
}

for value in test1.allValues {
    print("value = \(value)")
}

let v1: test2 = .option4("test")
print("v1 = \(v1.associated.label), \(v1.associated.value!)")
let v2: test2 = .option5(3)
print("v2 = \(v2.associated.label), \(v2.associated.value!)")
let v3: test2 = .option6(4, "more")
print("v3 = \(v3.associated.label), \(v3.associated.value!)")

let array = [v1, v2, v3]
let dict = [String:Any](array)
print("Array of enums as dictionary:\n \(dict)")

print("query = \(array.queryString))")
```

## License

Stuff is available under the MIT 3 license. See the LICENSE file for more info.

## My other libraries:
Also see my other public source iOS libraries:

- [EVReflection](https://github.com/evermeer/EVReflection) - Reflection based (Dictionary, CKRecord, JSON and XML) object mapping with extensions for Alamofire and Moya with RxSwift or ReactiveSwift 
- [EVCloudKitDao](https://github.com/evermeer/EVCloudKitDao) - Simplified access to Apple's CloudKit
- [EVFaceTracker](https://github.com/evermeer/EVFaceTracker) - Calculate the distance and angle of your device with regards to your face in order to simulate a 3D effect
- [EVURLCache](https://github.com/evermeer/EVURLCache) - a NSURLCache subclass for handling all web requests that use NSURLReques
- [AlamofireOauth2](https://github.com/evermeer/AlamofireOauth2) - A swift implementation of OAuth2 using Alamofire
- [EVWordPressAPI](https://github.com/evermeer/EVWordPressAPI) - Swift Implementation of the WordPress (Jetpack) API using AlamofireOauth2, EVReflection and Alamofire (work in progress)
- [PassportScanner](https://github.com/evermeer/PassportScanner) - Scan the MRZ code of a passport and extract the firstname, lastname, passport number, nationality, date of birth, expiration date and personal numer.
- [AttributedTextView](https://github.com/evermeer/AttributedTextView) - Easiest way to create an attributed UITextView with support for multiple links (url, hashtags, mentions).
- [UITestHelper](https://github.com/evermeer/UITestHelper) - UI test helper functions.

