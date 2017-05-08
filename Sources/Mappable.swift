import Foundation

public protocol Mappable {
    var map: [String : Any] { get }
    init(map: [String : Any]) throws
}

public enum MappableError: Error {
    case mappingFailed
    case valueMissing(forKey: String)
    case valueTypeWrong(forKey: String)
}

public extension Mappable {
    
    public var map: [String : Any] {
        var map = [String : Any]()
        Mirror(reflecting: self).children.forEach { property in
            if let propertyName = property.label {
                if let object = property.value as? Mappable {
                    map[propertyName] = object.map
                } else if let objectArray = property.value as? [Mappable] {
                    map[propertyName] = objectArray.map { $0.map }
                } else {
                    map[propertyName] = property.value
                }
            }
        }
        return map
    }
    
}

public extension Dictionary where Key: ExpressibleByStringLiteral {
    
    public func value<T>(forKey key: String) throws -> T {
        guard let value = self[key as! Key] else {
            throw MappableError.valueMissing(forKey: key)
        }
        guard let typedValue = value as? T else {
            throw MappableError.valueTypeWrong(forKey: key)
        }
        return typedValue
    }
    
    public func mappable<T: Mappable>(forKey key: String) throws -> T {
        guard let value = self[key as! Key] else {
            throw MappableError.valueMissing(forKey: key)
        }
        guard let map = value as? [String : Any] else {
            throw MappableError.valueTypeWrong(forKey: key)
        }
        return try T(map: map)
    }
    
    public func mappableArray<T: Mappable>(forKey key: String) throws -> [T] {
        guard let value = self[key as! Key] else {
            throw MappableError.valueMissing(forKey: key)
        }
        guard let array = value as? Array<[String : Any]> else {
            throw MappableError.valueTypeWrong(forKey: key)
        }
        let mappableArray: [T] = try array.mappableArray()
        return mappableArray
    }
    
}

public extension Array {
    
    public func mappableArray<T: Mappable>() throws -> [T] {
        var array = [T]()
        try forEach {
            if let map = $0 as? [String : Any] {
                let model = try T(map: map)
                array.append(model)
            } else {
                throw MappableError.mappingFailed
            }
        }
        return array
    }
    
}
