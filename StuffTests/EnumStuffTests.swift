//
//  StuffTests.swift
//  StuffTests
//
//  Created by Edwin Vermeer on 10/02/2017.
//  Copyright © 2017 evict. All rights reserved.
//

import XCTest
@testable import Stuff

class EnumStuffTests: XCTestCase {
    
    // You have to extend the enum with the Enum protocol
    enum test1: String, Enum, RawEnum {
        case option1
        case option2
        case option3
    }
    
    // You have to extend the enum with the Enum protocol
    enum test2: Enum {
        case option4(String)
        case option5(Int)
        case option6(Int, String)
    }
    
    func testExample() {
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
    }
    
    func getRawValue(_ value: Any) -> Any {
        return (value as? RawEnum)?.anyRawValue ?? ""
    }
    
}
