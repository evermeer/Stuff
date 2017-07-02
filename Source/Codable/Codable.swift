//
//  Codable.swift
//  Stuff
//
//  Created by Edwin Vermeer on 28/06/2017.
//  Copyright © 2017 EVICT BV. All rights reserved.
//


public extension Encodable {
    /**
     Convert this object to json data
     
     - parameter outputFormatting: The formatting of the output JSON data (compact or pritty printed)
     - parameter dateEncodinStrategy: how do you want to format the date
     - parameter dataEncodingStrategy: what kind of encoding. base64 is the default
     
     - returns: The json data
     */
    public func toJsonData(outputFormatting: JSONEncoder.OutputFormatting = .compact, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate, dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .base64Encode) -> Data? {
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
    public func toJsonString(outputFormatting: JSONEncoder.OutputFormatting = .compact, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate, dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .base64Encode) -> String? {
        let data = self.toJsonData(outputFormatting: outputFormatting, dateEncodingStrategy: dateEncodingStrategy, dataEncodingStrategy: dataEncodingStrategy)
        return data == nil ? nil : String(data: data!, encoding: .utf8)
    }
}

public extension Decodable {
    /**
     Create an instance of this type from a json string
     
     - parameter json: The json string
     - parameter keyPath: for if you want something else than the root object
     */
    init(json: String, keyPath: String? = nil) throws {
        guard let data = json.data(using: .utf8) else { throw CodingError.RuntimeError("cannot create data from string") }
        try self.init(data: data, keyPath: keyPath)
    }
    
    /**
     Create an instance of this type from a json string
     
     - parameter data: The json data
     - parameter keyPath: for if you want something else than the root object
     */
    init(data: Data, keyPath: String? = nil) throws {
        if let keyPath = keyPath {
            let topLevel = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            guard let nestedJson = (topLevel as AnyObject).value(forKeyPath: keyPath) else { throw CodingError.RuntimeError("Cannot decode data to object")  }
            let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
            let value = try JSONDecoder().decode(Self.self, from: nestedData)
            self = value
            return
        }
        let value = try JSONDecoder().decode(Self.self, from: data)
        self = value
    }
}
enum CodingError : Error {
    case RuntimeError(String)
}

public extension Array where Element: Decodable {
    
    /**
     Initialize an array based on a json string
     
     - parameter json: The json string
     - parameter conversionOptions: Option set for the various conversion options.
     */
    public init(jsonArray: String?) throws {
        guard let data = jsonArray?.data(using: String.Encoding.utf8) else { throw CodingError.RuntimeError("Cannot decode json string to data.") }
        try self.init(dataArray: data)
    }
    
    
    /**
     Initialize an array based on a json string
     
     - parameter json: The json string
     - parameter conversionOptions: Option set for the various conversion options.
     */
    public init(dataArray: Data?, keyPath: String? = nil) throws {
        self.init()        
        guard var data = dataArray else { throw CodingError.RuntimeError("Cannot decode json to data") }
        if let keyPath = keyPath {
            let topLevel = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            guard let nestedJson = (topLevel as AnyObject).value(forKeyPath: keyPath) else { throw CodingError.RuntimeError("Cannot get nested data for keyPath") }
            let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
            data = nestedData
        }
        let newArray = try JSONDecoder().decode(self.getType(self), from: data)
        for item in newArray {
            self.append(item)
        }
    }
    
    /**
     Get the type of the object where this array is for (Workaround trick because Self.self does not work)
     
     - returns: The object type
     */
    public func getType<T: Decodable>(_: T) -> T.Type {
        return T.self
    }
}

public extension Array where Element: Encodable {
    /**
     Convert this array to a json string
     
     - parameter outputFormatting: The formatting of the output JSON data (compact or pritty printed)
     - parameter dateEncodinStrategy: how do you want to format the date
     - parameter dataEncodingStrategy: what kind of encoding. base64 is the default
     
     - returns: The json string
     */
    public func toJsonString(outputFormatting: JSONEncoder.OutputFormatting = .compact, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate, dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .base64Encode) -> String {
        let p = outputFormatting == .compact ? "" : "/n"
        return "[\(p)" + self.map({($0).toJsonString(outputFormatting: outputFormatting, dateEncodingStrategy: dateEncodingStrategy, dataEncodingStrategy: dataEncodingStrategy) ?? ""}).joined(separator: ",\(p)") + "\(p)]"
    }
}
