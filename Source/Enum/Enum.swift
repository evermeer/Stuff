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
    public var associated: (label: String, value: Any?) {
        get {
            let mirror = Mirror(reflecting: self)
            if mirror.displayStyle == .enum {
                if let associated = mirror.children.first {
                    return (associated.label!, associated.value)
                }
                print("WARNING: Enum option of \(self) does not have an associated value")
                return ("\(self)", nil)
            }
            print("WARNING: You can only extend an enum with the EnumExtension")
            return ("\(self)", nil)
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
    public static var allValues: [Self] {
        let mirror = Mirror(reflecting: self)
        if mirror.displayStyle == .enum {
            return Array(self.cases())
        }
        print("WARNING: You can only extend an enum with the EnumExtension")
        return []
    }
    
    static func cases() -> AnySequence<Self> {
        typealias S = Self
        return AnySequence { () -> AnyIterator<S> in
            var raw = 0
            return AnyIterator {
                let current : Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
}


/**
 Enum extension for getting the rawValue even if the enum is passed in an Enum
 */
public extension RawEnum where Self: RawRepresentable {
    /**
     Return the raw value of the enum
     */
    public var anyRawValue: Any {
        get {
            let mirror = Mirror(reflecting: self)
            if mirror.displayStyle != .enum {
                print("WARNING: You can only extend an enum with the EnumExtension")
            }
            return rawValue as Any
            
        }
    }
}

/**
 extension for creating a querystring from an array of Enum values (with associated value)
 */
public extension Array where Element: Enum {
    public var queryString: String {
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
