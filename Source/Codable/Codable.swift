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
     */    public func toJsonString(outputFormatting: JSONEncoder.OutputFormatting = .compact, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate, dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .base64Encode) -> String? {
        let data = self.toJsonData(outputFormatting: outputFormatting, dateEncodingStrategy: dateEncodingStrategy, dataEncodingStrategy: dataEncodingStrategy)
        return data == nil ? nil : String(data: data!, encoding: .utf8)
    }
}

public extension Decodable {
    
    /**
     Create an instance of this type from a json data
     
     - parameter json: The json string
     - parameter keyPath: for if you want something else than the root object
     
     - returns: The json string
     */
    public static func decode(data: Data, keyPath: String? = nil) -> Self? {
        do {
            if let keyPath = keyPath {
                let topLevel = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                guard let nestedJson = (topLevel as AnyObject).value(forKeyPath: keyPath) else { return nil }
                let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
                data = nestedData
            }
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            print("🆘 ERROR 🆘 \(error)")
            return nil
        }
    }
    
    /**
     Create an instance of this type from a json string
     
     - parameter json: The json string
     - parameter keyPath: for if you want something else than the root object
     
     - returns: The json string
     */
    public static func decode(json: String, keyPath: String? = nil) -> Self? {
        guard var data = json.data(using: String.Encoding.utf8) else { return nil }
        return self.decode(data: data, keyPath: keyPath)
    }
    
    /* This seems to be a no-go unless you use enherit from NSObject and use Mirror plus 'setValue forKey'
    init?(json: String, keyPath: String? = nil) {
        guard let obj = Self.init(json) else { return nil }
        self = obj // Won't work...
    }
 */
}


public extension Array where Element: Decodable {
    
    /**
     Initialize an array based on a json string
     
     - parameter json: The json string
     - parameter conversionOptions: Option set for the various conversion options.
     */
    public init?(json: String?) {
        guard let data = json?.data(using: String.Encoding.utf8) else { return nil }
        self.init(data: data)
    }
    
    
    /**
     Initialize an array based on a json string
     
     - parameter json: The json string
     - parameter conversionOptions: Option set for the various conversion options.
     */
    public init?(data: Data?, keyPath: String? = nil) {
        self.init()        
        do {
            guard var data = data else { return nil }
            if let keyPath = keyPath {
                let topLevel = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                guard let nestedJson = (topLevel as AnyObject).value(forKeyPath: keyPath) else { return nil }
                let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
                data = nestedData
            }
            let newArray = try JSONDecoder().decode(self.getType(self), from: data)
            for item in newArray {
                self.append(item)
            }
        } catch {
            print("🆘 ERROR 🆘 \(error)")
            return nil
        }
    }
    
    /**
     Get the type of the object where this array is for
     
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
