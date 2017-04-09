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
    
    public func object<T: Mappable>(forKey key: String) throws -> T {
        guard let value = self[key as! Key] else {
            throw MappableError.valueMissing(forKey: key)
        }
        guard let map = value as? [String : Any] else {
            throw MappableError.valueTypeWrong(forKey: key)
        }
        return try T(map: map)
    }
    
    public func objectsArray<T: Mappable>(forKey key: String) throws -> [T] {
        guard let value = self[key as! Key] else {
            throw MappableError.valueMissing(forKey: key)
        }
        guard let mapArray = value as? Array<[String : Any]> else {
            throw MappableError.valueTypeWrong(forKey: key)
        }
        var modelArray = [T]()
        try mapArray.forEach {
            let model = try T(map: $0)
            modelArray.append(model)
        }
        return modelArray
    }
    
}
