//
//  Codable.swift
//  Stuff
//
//  Created by Edwin Vermeer on 28/06/2017.
//  Copyright © 2017 EVICT BV. All rights reserved.
//

enum CodingError : Error {
    case RuntimeError(String)
}

struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

public var customCodingStragegy: JSONDecoder.KeyDecodingStrategy = .custom { keys in
    let lastComponent = keys.last!.stringValue
    let snakeCased = lastComponent.split(separator: "_").map { $0.prefix(1).uppercased() + $0.dropFirst() }.reduce("") { $0 + $1}
    let lowerFirst = snakeCased.prefix(1).lowercased() + snakeCased.dropFirst()
    return AnyKey(stringValue: lowerFirst)
}

public extension Encodable {
    /**
     Convert this object to json data
     
     - parameter outputFormatting: The formatting of the output JSON data (compact or pritty printed)
     - parameter dateEncodinStrategy: how do you want to format the date
     - parameter dataEncodingStrategy: what kind of encoding. base64 is the default
     
     - returns: The json data
     */
    public func toJsonData(outputFormatting: JSONEncoder.OutputFormatting = [], dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate, dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .base64) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatting
        encoder.dateEncodingStrategy = dateEncodingStrategy
        encoder.dataEncodingStrategy = dataEncodingStrategy
        return try? encoder.encode(self)
    }
    
    /**
     Convert this object to a json string
     
     - parameter outputFormatting: The formatting of the output JSON data (compact or pritty printed)
     - parameter dateEncodinStrategy: how do you want to format the date
     - parameter dataEncodingStrategy: what kind of encoding. base64 is the default
     
     - returns: The json string
     */
    public func toJsonString(outputFormatting: JSONEncoder.OutputFormatting = [], dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate, dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .base64) -> String? {
        let data = self.toJsonData(outputFormatting: outputFormatting, dateEncodingStrategy: dateEncodingStrategy, dataEncodingStrategy: dataEncodingStrategy)
        return data == nil ? nil : String(data: data!, encoding: .utf8)
    }
    
    
    /**
     Save this object to a file in the temp directory
     
     - parameter fileName: The filename
     
     - returns: Nothing
     */
    public func saveTo(_ fileURL: URL) throws {
        guard let data = self.toJsonData() else { throw CodingError.RuntimeError("cannot create data from object")}
        try data.write(to: fileURL, options: .atomic)
    }
    
    
    /**
     Save this object to a file in the temp directory
     
     - parameter fileName: The filename
     
     - returns: Nothing
     */
    public func saveToTemp(_ fileName: String) throws {
        let fileURL = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName)
        try self.saveTo(fileURL)
    }
    
    
    
    #if os(tvOS)
    // Save to documents folder is not supported on tvOS
    #else
    /**
     Save this object to a file in the documents directory
     
     - parameter fileName: The filename
     
     - returns: true if successfull
     */
    public func saveToDocuments(_ fileName: String) throws {
        let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName)
        try self.saveTo(fileURL)
    }
    #endif
}

public extension Decodable {
    /**
     Create an instance of this type from a json string
     
     - parameter json: The json string
     - parameter keyPath: for if you want something else than the root object
     */
    init(json: String, keyPath: String? = nil,
         keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase,
         dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
         dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
         nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw) throws {
        guard let data = json.data(using: .utf8) else { throw CodingError.RuntimeError("cannot create data from string") }
        try self.init(data: data, keyPath: keyPath, keyDecodingStrategy: keyDecodingStrategy, dateDecodingStrategy: dateDecodingStrategy, dataDecodingStrategy: dataDecodingStrategy, nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy)
    }
    
    /**
     Create an instance of this type from a json string
     
     - parameter data: The json data
     - parameter keyPath: for if you want something else than the root object
     */
    init(data: Data, keyPath: String? = nil,
         keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase,
         dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
         dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
         nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw) throws {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.dataDecodingStrategy = dataDecodingStrategy
        decoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy

        if let keyPath = keyPath {
            let topLevel = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            guard let nestedJson = (topLevel as AnyObject).value(forKeyPath: keyPath) else { throw CodingError.RuntimeError("Cannot decode data to object")  }
            let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
            self = try decoder.decode(Self.self, from: nestedData)
            return
        }
        self = try decoder.decode(Self.self, from: data)
    }
    
    /**
     Initialize this object from an archived file from an URL
     
     - parameter fileNameInTemp: The filename
     */
    public init(fileURL: URL) throws {
        let data = try Data(contentsOf: fileURL)
        try self.init(data: data)
    }
    
    /**
     Initialize this object from an archived file from the temp directory
     
     - parameter fileNameInTemp: The filename
     */
    public init(fileNameInTemp: String) throws {
        let fileURL = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileNameInTemp)
        try self.init(fileURL: fileURL)
    }
    
    /**
     Initialize this object from an archived file from the documents directory
     
     - parameter fileNameInDocuments: The filename
     */
    public init(fileNameInDocuments: String) throws {
        let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileNameInDocuments)
        try self.init(fileURL: fileURL)
    }
}

 
