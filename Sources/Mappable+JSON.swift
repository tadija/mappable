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
    
    public static func mappableArray<T: Mappable>(with jsonData: Data,
                             options: JSONSerialization.ReadingOptions = .allowFragments) throws -> [T] {
        guard let json = try JSONSerialization.jsonObject(with: jsonData, options: options) as? [Any] else {
            throw MappableError.mappingFailed
        }
        let mappableArray: [T] = try json.mappableArray()
        return mappableArray
    }

}
