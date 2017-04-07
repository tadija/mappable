import Foundation

typealias ThrowAnyInClosure = (() throws -> Any) -> Void
typealias ThrowProfileInClosure = (() throws -> Profile) -> Void

class DataSource {
    
    private let base = URL(string: "https://api.github.com")!
    
    enum DataSourceError: Error {
        case requestFailed
    }
    
    func fetchProfile(withUsername username: String, completion: @escaping ThrowProfileInClosure) {
        fetchModel(username: username) { closure in
            do {
                if let data = try closure() as? [String : Any] {
                    let profile = try Profile(dictionary: data)
                    completion {
                        return profile
                    }
                } else {
                    throw DataSourceError.requestFailed
                }
            } catch {
                completion {
                    throw error
                }
            }
        }
    }
    
    private func fetchModel(username: String, completion: @escaping ThrowAnyInClosure) {
        fetchUser(username: username) { (closure) in
            do {
                if var profileData = try closure() as? [String : Any] {
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
                    completion { throw DataSourceError.requestFailed }
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
                completion { throw DataSourceError.requestFailed }
            }
        }.resume()
    }
    
}
