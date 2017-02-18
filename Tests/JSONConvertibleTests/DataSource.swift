import Foundation
import JSONConvertible

typealias ThrowAnyInClosure = (() throws -> Any) -> Void

class DataSource {
    
    private let base = URL(string: "https://api.github.com")!
    
    enum DataSourceError: Error {
        case anyError
    }
    
    func fetchModel(username: String, completion: @escaping ThrowAnyInClosure) {
        fetchUser(username: username) { (closure) in
            do {
                if var profileData = try closure() as? JSONObject {
                    self.fetchRepos(username: username, completion: { (closure) in
                        do {
                            let reposData = try closure()
                            profileData["repos"] = reposData
                            completion { return profileData }
                        } catch {
                            completion { throw error }
                        }
                    })
                } else {
                    completion { throw DataSourceError.anyError }
                }
            } catch {
                completion { throw error }
            }
        }
    }
    
    private func fetchUser(username: String, completion: @escaping ThrowAnyInClosure) {
        let url = base.appendingPathComponent("users/\(username)")
        fetchJSON(fromURL: url, completion: completion)
    }
    
    private func fetchRepos(username: String, completion: @escaping ThrowAnyInClosure) {
        let url = base.appendingPathComponent("users/\(username)/repos")
        fetchJSON(fromURL: url, completion: completion)
    }
    
    private func fetchJSON(fromURL url: URL, completion: @escaping ThrowAnyInClosure) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    completion { return json }
                } catch {
                    completion { throw error }
                }
            } else {
                completion { throw DataSourceError.anyError }
            }
        }.resume()
    }
    
}
