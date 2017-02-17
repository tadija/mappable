import Foundation

public protocol JSONConvertible {
    var json: JSONObject { get }
    init(json: JSONObject) throws
}

extension JSONConvertible {
    
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
