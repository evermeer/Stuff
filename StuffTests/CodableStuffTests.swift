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
            assertionFailure()
            return
        }
        print("Json string of object = \n\t\(json)")
        
        guard let newObject = try? TestCodable(json: json) else {
            print("Could not create object from json")
            assertionFailure()
            return
        }
        print("Object created with json = \n\t\(String(describing: newObject))")
        
        let json2 = "[{\"id\":1,\"naam\":\"Edwin\"},{\"id\":2,\"naam\":\"Vermeer\"}]"
        guard let array = try? [TestCodable](json: json2) else {
            print("Could not create object array from json")
            assertionFailure()
            return
        }
        print("Object array created with json = \(String(describing: array))")
        
        let newJson = array.toJsonString() ?? ""
        print("Json from object array = \n\t\(newJson)")
        
        guard let innerObject = try? TestCodable(json: "{\"user\":{\"id\":1,\"naam\":\"Edwin\"}}", keyPath: "user") else {
            print("Could not create object from json")
            assertionFailure()
            return
        }
        print("inner object from json \(String(describing: innerObject))")
        
        do {
            try initialObject.saveToDocuments("myFile.dat")
        } catch {
            print("Could not write to documents data")
            assertionFailure()
            return
        }
        guard let readObject = try? TestCodable(fileNameInDocuments: "myFile.dat") else {
            print("Could not read from documents data")
            assertionFailure()
            return
        }
        print("read  object from documents \(String(describing: readObject))")
        
        do {
            try array.saveToDocuments("myFile2.dat")
        } catch {
            print("Could not write to documents data")
            assertionFailure()
            return
        }
        guard let readObjectArray = try? [TestCodable](fileNameInDocuments: "myFile2.dat") else {
            print("Could not read from documents data")
            assertionFailure()
            return
        }
        print("read object array from documents \(String(describing: readObjectArray))")
    }
}

struct TestCodable : Codable {
    var naam: String?
    var id: Int?
}
