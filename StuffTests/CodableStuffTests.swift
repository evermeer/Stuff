//
//  CodableStuffTests.swift
//  StuffTests
//
//  Created by Vermeer, Edwin on 28/06/2017.
//  Copyright © 2017 evict. All rights reserved.
//


import XCTest
@testable import Stuff

class CodingStuffTests: XCTestCase {
    
    func test() {
        let initialObject = TestCodable(naam: "Edwin", id: 1)
        
        guard let json = initialObject.toJsonString() else {
            print("Could not create json from object")
            return
        }
        print("Json string of object = \n\t\(json)")
        
        guard let newObject = TestCodable.decodeTest(json: json) else {
            print("Could not create object from json")
            return
        }
        print("Object created with json = \n\t\(newObject)")
        
        let json2 = "[{\"id\":1,\"naam\":\"Edwin\"},{\"id\":2,\"naam\":\"Vermeer\"}]"
        guard let array = [TestCodable](json: json2) else {
            print("Could not create object array from json")
            return
        }
        print("Object array created with json = \(array)")
        
        let newJson = array.toJsonString()
        print("Json from object array = \n\t\(newJson)")
    }
}

struct TestCodable : Codable {
    var naam: String?
    var id: Int?
}
