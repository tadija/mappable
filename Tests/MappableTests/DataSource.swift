import Foundation

typealias ThrowDataInClosure = (() throws -> Data) -> Void
typealias ThrowUserInClosure = (() throws -> User) -> Void
typealias ThrowReposInClosure = (() throws -> [Repo]) -> Void
typealias ThrowProfileInClosure = (() throws -> Profile) -> Void

class DataSource {
    
    private let base = URL(string: "https://api.github.com")!
    
    enum DataSourceError: Error {
        case requestFailed
    }
    
    func fetchProfile(username: String, completion: @escaping ThrowProfileInClosure) {
        fetchUser(username: username) { (closure) in
            do {
                let user = try closure()
                
                self.fetchRepos(username: username, completion: { (closure) in
                    do {
                        let repos = try closure()
                        
                        var profileMap = user.map
                        profileMap["repos"] = repos.map{ $0.map }
                        
                        let profile = try Profile(map: profileMap)
                        completion {
                            return profile
                        }
                        
                    } catch {
                        completion { throw error }
                    }
                })
                
            } catch {
                completion { throw error }
            }
        }
    }
    
    private func fetchUser(username: String, completion: @escaping ThrowUserInClosure) {
        let url = base.appendingPathComponent("users/\(username)")
        fetchData(fromURL: url) { (closure) in
            do {
                let data = try closure()
                let user = try User(jsonData: data)
                completion { return user }
            } catch {
                completion { throw error }
            }
        }
    }
    
    private func fetchRepos(username: String, completion: @escaping ThrowReposInClosure) {
        let url = base.appendingPathComponent("users/\(username)/repos")
        fetchData(fromURL: url) { (closure) in
            do {
                let data = try closure()
                let repos: [Repo] = try Repo.mappableArray(with: data)
                completion { return repos }
            } catch {
                completion { throw error }
            }
        }
    }
    
    private func fetchData(fromURL url: URL, completion: @escaping ThrowDataInClosure) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                completion { return data }
            } else {
                completion { throw DataSourceError.requestFailed }
            }
        }.resume()
    }
    
}
