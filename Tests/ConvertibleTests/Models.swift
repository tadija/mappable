//import Convertible

struct User: Convertible {
    let id: Int
    let login: String
    
    init(dictionary: [String : Any]) throws {
        id = try dictionary.value(forKey: "id")
        login = try dictionary.value(forKey: "login")
    }
}

struct Repo: Convertible {
    let id: Int
    let name: String
    let `private`: Bool
    let owner: User
    
    init(dictionary: [String : Any]) throws {
        id = try dictionary.value(forKey: "id")
        name = try dictionary.value(forKey: "name")
        `private` = try dictionary.value(forKey: "private")
        owner = try dictionary.object(forKey: "owner")
    }
}

struct Profile: Convertible {
    let user: User
    let name: String
    let repos: [Repo]
    
    init(dictionary: [String : Any]) throws {
        user = try User(dictionary: dictionary)
        name = try dictionary.value(forKey: "name")
        repos = try dictionary.objectsArray(forKey: "repos")
    }
}
