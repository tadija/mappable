import Foundation

public protocol Convertible {
    var dictionary: [String : Any] { get }
    init(dictionary: [String : Any]) throws
}

public enum ConvertibleError: Error {
    case conversionFailed
    case valueMissing(forKey: String)
    case valueTypeWrong(forKey: String)
}

public extension Convertible {
    
    public var dictionary: [String : Any] {
        var dict = [String : Any]()
        
        Mirror(reflecting: self).children.forEach { property in
            if let propertyName = property.label {
                if let object = property.value as? Convertible {
                    dict[propertyName] = object.dictionary
                } else if let objectArray = property.value as? [Convertible] {
                    dict[propertyName] = objectArray.map { $0.dictionary }
                } else {
                    dict[propertyName] = property.value
                }
            }
        }
        
        return dict
    }
    
}

public extension Dictionary where Key: ExpressibleByStringLiteral {
    
    public func value<T>(forKey key: String) throws -> T {
        guard let value = self[key as! Key] else {
            throw ConvertibleError.valueMissing(forKey: key)
        }
        guard let typedValue = value as? T else {
            throw ConvertibleError.valueTypeWrong(forKey: key)
        }
        return typedValue
    }
    
    public func object<T: Convertible>(forKey key: String) throws -> T {
        guard let value = self[key as! Key] else {
            throw ConvertibleError.valueMissing(forKey: key)
        }
        guard let dictionary = value as? [String : Any] else {
            throw ConvertibleError.valueTypeWrong(forKey: key)
        }
        return try T(dictionary: dictionary)
    }
    
    public func objectsArray<T: Convertible>(forKey key: String) throws -> [T] {
        guard let value = self[key as! Key] else {
            throw ConvertibleError.valueMissing(forKey: key)
        }
        guard let dictionaryArray = value as? Array<[String : Any]> else {
            throw ConvertibleError.valueTypeWrong(forKey: key)
        }
        var modelArray = [T]()
        try dictionaryArray.forEach {
            let model = try T(dictionary: $0)
            modelArray.append(model)
        }
        return modelArray
    }
    
}
