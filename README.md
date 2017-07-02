# Stuff

[![Issues](https://img.shields.io/github/issues-raw/evermeer/Stuff.svg?style=flat)](https://github.com/evermeer/Stuff/issues)
[![Documentation](https://img.shields.io/badge/documented-100%25-green.svg?style=flat)](http://cocoadocs.org/docsets/Stuff/)
[![Stars](https://img.shields.io/github/stars/evermeer/Stuff.svg?style=flat)](https://github.com/evermeer/Stuff/stargazers)
[![Downloads](https://img.shields.io/cocoapods/dt/Stuff.svg?style=flat)](https://cocoapods.org/pods/Stuff)


[![Version](https://img.shields.io/cocoapods/v/Stuff.svg?style=flat)](http://cocoadocs.org/docsets/Stuff)
[![Language](https://img.shields.io/badge/language-swift%203-f48041.svg?style=flat)](https://developer.apple.com/swift)
[![Platform](https://img.shields.io/cocoapods/p/Stuff.svg?style=flat)](http://cocoadocs.org/docsets/Stuff)
[![License](https://img.shields.io/cocoapods/l/Stuff.svg?style=flat)](http://cocoadocs.org/docsets/Stuff)

[![Git](https://img.shields.io/badge/GitHub-evermeer-blue.svg?style=flat)](https://github.com/evermeer)
[![Twitter](https://img.shields.io/badge/twitter-@evermeer-blue.svg?style=flat)](http://twitter.com/evermeer)
[![LinkedIn](https://img.shields.io/badge/linkedin-Edwin%20Vermeer-blue.svg?style=flat)](http://nl.linkedin.com/in/evermeer/en)
[![Website](https://img.shields.io/badge/website-evict.nl-blue.svg?style=flat)](http://evict.nl)
[![eMail](https://img.shields.io/badge/email-edwin@evict.nl-blue.svg?style=flat)](mailto:edwin@evict.nl?SUBJECT=About%20Stuff)

# General information

Stuff is a collection of code 'snippets' that are to small to create a library for and which do not fit in an other library. Run the unit tests to see the code in action.

- [Print](#print) - For creating a nice output log
- [Enum](#enum) - Adding functionality to an enum
- [TODO](#todo) - Adding a TODO helper function
- [Codable](#codable) - Adding Codable helper functions (Swift 4)

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
// You have to extend the enum with the Enum protocol (and RawEnum if you want the raw value when it's an Any)
enum test1: String, Enum, RawEnum {
    case option1
    case option2
    case option3
}

enum test2: Enum {
    case option4(String)
    case option5(Int)
    case option6(Int, String)
}

XCTAssert(test1.allValues.count == 3, "There should be 3 values")
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

let v = getRawValue(test1.option2)
print("raw value = \(v)")

func getRawValue(_ value: Any) -> Any {
    return (value as? RawEnum)?.anyRawValue ?? ""
}

```
The output is:

```swift
value = option1
value = option2
value = option3
v1 = option4, test
v2 = option5, 3
v3 = option6, (4, "more")
Array of enums as dictionary:
["option5": 3, "option4": "test", "option6": (4, "more")]
query = option4=test,option5=3,option6=(4, "more"))
raw value = option2
```

## TODO

You can install this by adding the following line to your Podfile:

```
pod "Stuff/TODO"
```

Whenever you add a function to your project and postpone implementing it, you should add a TODO. 
Whenever you temporarilly change functioning code in order to debug something, you should add a TODO
Before commiting/pushing your code, you should evaluate/solve your TODO's
Usually you just add a TODO comment in your code like this:

```swift
    //TODO: This needs to be fixed
```

With the Stuff/TODO helper, you can get compile time and run time support for helping to find your TODO's. Here is an overview of the variants that you can use:

```swift
    // We need to fix something, but this code can run (compiler warning)
    TODO()

    // Now output extra info when this code is executed.
    TODO("An other todo, now giving some detailed info")

    // We need to fix this. Otherwise just fail. The code will crash here. See the stacktrace,
    TODO_
```

The code above will put the following in your output. Besides that, you will also see depricated warnings when you have the code open in Xcode.

```
⚠️ TODO code is still in use! ⚠️

⚠️ TODO code is still in use! ⚠️
An other todo, now giving some detailed info
fatal error: TODO left in code: file /Users/evermeer/Desktop/dev/GitHub/Stuff/Source/TODO/TODO.swift, line 15
```

## Codable

You can install this by adding the following line to your Podfile:

⚠️WARNING: Swift 4 or later is required ⚠️

```
pod "Stuff/Codable"
```

Swift 4 added the Codable (EnCodable and DeCodable) protocol which you can add to a class or struct. The swift compile will then add coding and decoding functionality to your object. With the JSONEncoder and JSONDecoder classes you can then convert an object from and to json. The Stuff Codable extension will let you do these things in a 1 liner. Here is Apple documentaion about [Codable](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types) The one liners that you can use are:

```swift
let json = yourEncodableObjectInstance.toJsonString()
let data = yourEncodableObjectInstance.toJsonData()
let newObject = try? YourCodableObject(json: json)
let newObject2 = try? YourCodableObject(data: data)
let objectArray = try? [YourCodableObject](json: json)
let objectArray2 = try? [YourCodableObject](data: data)
let newJson = objectArray.toJsonString()
let innerObject = try? TestCodable(json: "{\"user\":{\"id\":1,\"naam\":\"Edwin\"}}", keyPath: "user")
try initialObject.saveToDocuments("myFile.dat")
let readObject = try? TestCodable(fileNameInDocuments: "myFile.dat")
try objectArray.saveToDocuments("myFile2.dat")
let objectArray3 = try? [TestCodable](fileNameInDocuments: "myFile2.dat")
```

And here you can see how you can use these Stuff/Codable functions:

```swift
func test() {
   let initialObject = TestCodable(naam: "Edwin", id: 1)

   guard let json = initialObject.toJsonString() else {
      print("Could not create json from object")
      return
   }
   print("Json string of object = \n\t\(json)")

   guard let newObject = try? TestCodable(json: json) else {
      print("Could not create object from json")
      return
   }
   print("Object created with json = \n\t\(newObject)")
   
   let json2 = "[{\"id\":1,\"naam\":\"Edwin\"},{\"id\":2,\"naam\":\"Vermeer\"}]"
   guard let array = try? [TestCodable](jsonArray: json2) else {
      print("Could not create object array from json")
      return
   }
   print("Object array created with json = \(array)")
   
   let newJson = array.toJsonString()
   print("Json from object array = \n\t\(newJson)")
   
   guard let innerObject = try? TestCodable(json: "{\"user\":{\"id\":1,\"naam\":\"Edwin\"}}", keyPath: "user") else {
      print("Could not create object from json")
      return
   }
   print("inner object from json \(String(describing: innerObject))")
}

struct TestCodable : Codable {
   var naam: String?
   var id: Int?
}
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

