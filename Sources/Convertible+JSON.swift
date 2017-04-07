import Foundation

public extension Convertible {

    public init(jsonData: Data, options: JSONSerialization.ReadingOptions = .allowFragments) throws {
        if let json = try JSONSerialization.jsonObject(with: jsonData, options: options) as? [String : Any] {
            try self.init(dictionary: json)
        } else {
            throw ConvertibleError.conversionFailed
        }
    }
    
    public func json(with: Data, options: JSONSerialization.WritingOptions = .prettyPrinted) throws -> Data {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: options)
        return data
    }

}
