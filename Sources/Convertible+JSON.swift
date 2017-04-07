import Foundation

public extension Convertible {

    public init(jsonData: Data, options: JSONSerialization.ReadingOptions = .allowFragments) throws {
        if let json = try JSONSerialization.jsonObject(with: jsonData, options: options) as? [String : Any] {
            try self.init(dictionary: json)
        } else {
            throw ConvertibleError.conversionFailed
        }
    }
    
    public func json(options: JSONSerialization.WritingOptions = .prettyPrinted) throws -> Data {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: options)
        return data
    }
    
    public static func array<T: Convertible>(with jsonData: Data,
                             options: JSONSerialization.ReadingOptions = .allowFragments) throws -> [T] {
        guard let json = try JSONSerialization.jsonObject(with: jsonData, options: options) as? [Any] else {
            throw ConvertibleError.conversionFailed
        }
        var array = [T]()
        try json.forEach {
            if let dictionary = $0 as? [String : Any] {
                let model = try T(dictionary: dictionary)
                array.append(model)
            } else {
                throw ConvertibleError.conversionFailed
            }
        }
        return array
    }

}
