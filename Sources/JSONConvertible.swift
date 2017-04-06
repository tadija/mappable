import Foundation

public protocol JSONConvertible {
    var json: JSONObject { get }
    init(json: JSONObject) throws
}

enum JSONConvertibleError: Error {
    case jsonSerializationFailed
}

extension JSONConvertible {
    
    public init(data: Data, options: JSONSerialization.ReadingOptions = .allowFragments) throws {
        if let json = try JSONSerialization.jsonObject(with: data, options: options) as? JSONObject {
            try self.init(json: json)
        } else {
            throw JSONConvertibleError.jsonSerializationFailed
        }
    }
    
    public var json: JSONObject {
        var json = JSONObject()
        
        Mirror(reflecting: self).children.forEach { property in
            if let propertyName = property.label {
                if let object = property.value as? JSONConvertible {
                    json[propertyName] = object.json
                } else if let objectArray = property.value as? [JSONConvertible] {
                    json[propertyName] = objectArray.map { $0.json }
                } else {
                    json[propertyName] = property.value
                }
            }
        }
        
        return json
    }
    
}
