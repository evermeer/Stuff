//
//  EnumExtensions.swift
//  Stuff
//
//  Created by Edwin Vermeer on 10/02/2017.
//  Copyright © 2017 EVICT BV. All rights reserved.
//


/**
 Protocol for the enum extension functions
 */
public protocol Enum {
}

/**
 Protocol for the workaround when using an enum with a rawValue of an undefined type
 */
public protocol RawEnum {
    /**
     For implementing a function that will return the rawValue for a non sepecific enum
     */
    var anyRawValue: Any { get }
}


/**
 Enum extension for getting the associated value of an enum
 */
public extension Enum {
    /**
     Get the associated value of the enum
     */
    var associated: (label: String, value: Any?, values: [Any]) {
        get {
            let mirror = Mirror(reflecting: self)
            if mirror.displayStyle == .enum {
                if let associated = mirror.children.first {
                    let values = Mirror(reflecting: associated.value).children
                    var valuesArray = [Any]()
                    for item in values {
                        valuesArray.append(item.value)
                    }
                    return (associated.label!, associated.value, valuesArray)
                }
                print("WARNING: Enum option of \(self) does not have an associated value")
                return ("\(self)", nil, [])
            }
            print("WARNING: You can only extend an enum with the EnumExtension")
            return ("\(self)", nil, [])
        }
    }
}


/**
 Enum extension for getting all enum options in an array
 */
public extension Enum where Self: Hashable {
    /**
     Return all enum values
     */
    static var allValues: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            var first: Self?
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                if raw == 0 {
                    first = current
                } else if current == first {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
}


/**
 Enum extension for getting the rawValue even if the enum is passed in an Enum
 */
public extension RawEnum where Self: RawRepresentable {
    /**
     Return the raw value of the enum
     */
    var anyRawValue: Any {
        get {
            let mirror = Mirror(reflecting: self)
            if mirror.displayStyle != .enum {
                print("WARNING: You can only extend an enum with the Enum protocol")
            }
            return rawValue as Any
            
        }
    }
}

/**
 extension for creating a querystring from an array of Enum values (with associated value)
 */
public extension Array where Element: Enum {
    var queryString: String {
        get {
            return (self.map {"\($0.associated.label)=\($0.associated.value!)"}).joined(separator: ",")
        }
    }
}


/**
 Dictionary extension for creating a dictionary from an array of enum values
 */
public extension Dictionary {
    /**
     Create a dictionairy based on all associated values of an enum array
     
     - parameter associated: array of dictionairy values which have an associated value
     
     */
    init<T: Enum>(_ associated: [T]?) {
        self.init()
        if associated != nil {
            for myEnum in associated! {
                self[(myEnum.associated.label as? Key)!] = myEnum.associated.value as? Value
            }
        }
    }
}
