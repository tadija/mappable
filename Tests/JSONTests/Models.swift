import JSON

struct User: JSONConvertible {
    
    let id: Int
    let username: String
    let fullName: String
    let repos: [Repo]
    
    var json: JSONObject {
        return [
            "id" : id,
            "login" : username,
            "name" : fullName,
            "repos" : repos.map { $0.json }
        ]
    }
    
    init(json: JSONObject) throws {
        id = try json.value(forKey: "id")
        username = try json.value(forKey: "login")
        fullName = try json.value(forKey: "name")
        repos = try json.objectsArray(forKey: "repos")
    }
    
}

struct Repo: JSONConvertible {
    
    let id: Int
    let name: String
    let `private`: Bool
    
    init(json: JSONObject) throws {
        id = try json.value(forKey: "id")
        name = try json.value(forKey: "name")
        `private` = try json.value(forKey: "private")
    }
    
}
