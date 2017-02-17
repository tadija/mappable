import Foundation

public typealias JSONObject = [String : Any]

public enum JSONError: Error {
    case valueMissing(forKey: String)
    case valueTypeWrong(forKey: String)
}

extension Dictionary where Key: ExpressibleByStringLiteral {
    
    public func value<T>(forKey key: String) throws -> T {
        guard let value = self[key as! Key] else {
            throw JSONError.valueMissing(forKey: key)
        }
        guard let typedValue = value as? T else {
            throw JSONError.valueTypeWrong(forKey: key)
        }
        return typedValue
    }
    
    public func object<T: JSONConvertible>(forKey key: String) throws -> T {
        guard let value = self[key as! Key] else {
            throw JSONError.valueMissing(forKey: key)
        }
        guard let dictionary = value as? JSONObject else {
            throw JSONError.valueTypeWrong(forKey: key)
        }
        return try T(json: dictionary)
    }
    
    public func objectsArray<T: JSONConvertible>(forKey key: String) throws -> [T] {
        guard let value = self[key as! Key] else {
            throw JSONError.valueMissing(forKey: key)
        }
        guard let dictionaryArray = value as? [JSONObject] else {
            throw JSONError.valueTypeWrong(forKey: key)
        }
        var modelArray = [T]()
        try dictionaryArray.forEach {
            let model = try T(json: $0)
            modelArray.append(model)
        }
        return modelArray
    }
    
}
