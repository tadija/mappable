import JSONConvertible

struct User: JSONConvertible {
    let id: Int
    let login: String
    
    init(json: JSONObject) throws {
        id = try json.value(forKey: "id")
        login = try json.value(forKey: "login")
    }
}

struct Repo: JSONConvertible {
    let id: Int
    let name: String
    let `private`: Bool
    let owner: User
    
    init(json: JSONObject) throws {
        id = try json.value(forKey: "id")
        name = try json.value(forKey: "name")
        `private` = try json.value(forKey: "private")
        owner = try json.object(forKey: "owner")
    }
}

struct Profile: JSONConvertible {
    let user: User
    let name: String
    let repos: [Repo]
    
    init(json: JSONObject) throws {
        user = try User(json: json)
        name = try json.value(forKey: "name")
        repos = try json.objectsArray(forKey: "repos")
    }
}
