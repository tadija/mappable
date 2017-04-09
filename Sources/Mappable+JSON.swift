import Foundation

public extension Mappable {

    public init(jsonData: Data, options: JSONSerialization.ReadingOptions = .allowFragments) throws {
        if let json = try JSONSerialization.jsonObject(with: jsonData, options: options) as? [String : Any] {
            try self.init(map: json)
        } else {
            throw MappableError.mappingFailed
        }
    }
    
    public func json(options: JSONSerialization.WritingOptions = .prettyPrinted) throws -> Data {
        let data = try JSONSerialization.data(withJSONObject: map, options: options)
        return data
    }
    
    public static func array<T: Mappable>(with jsonData: Data,
                             options: JSONSerialization.ReadingOptions = .allowFragments) throws -> [T] {
        guard let json = try JSONSerialization.jsonObject(with: jsonData, options: options) as? [Any] else {
            throw MappableError.mappingFailed
        }
        var array = [T]()
        try json.forEach {
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
