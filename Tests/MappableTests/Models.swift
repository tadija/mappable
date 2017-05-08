import Mappable

struct User: Mappable {
    let id: Int
    let login: String
    
    init(map: [String : Any]) throws {
        id = try map.value(forKey: "id")
        login = try map.value(forKey: "login")
    }
}

struct Repo: Mappable {
    let id: Int
    let name: String
    let `private`: Bool
    let owner: User
    
    init(map: [String : Any]) throws {
        id = try map.value(forKey: "id")
        name = try map.value(forKey: "name")
        `private` = try map.value(forKey: "private")
        owner = try map.mappable(forKey: "owner")
    }
}

struct Profile: Mappable {
    let user: User
    let repos: [Repo]
    
    init(map: [String : Any]) throws {
        user = try User(map: map)
        repos = try map.mappableArray(forKey: "repos")
    }
}
