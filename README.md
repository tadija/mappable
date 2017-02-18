# JSONConvertible

**Swift package for simple and lightweight handling of JSON backed models**

> I made this for personal use, feel free to use it or contribute if you like.

## Include

- [Swift Package Manager](https://swift.org/package-manager/):

```
.Package(url: "https://github.com/tadija/json-convertible.git", majorVersion: 0)
```

## Use

#### This is merely a concept how someone could use JSON backed models in a Swift app, but without using too much of boilerplate and repeatable code.  

Example below is based on data received from [GitHub API](https://developer.github.com/v3/).  
**Note:** Models in example are unnecessary complex in order to show capabilities of this package.

Start with conforming your models to `JSONConvertible` protocol.  
`JSONObject` is just a `public typealias JSONObject = [String : Any]`.

```swift
public protocol JSONConvertible {
    var json: JSONObject { get }
    init(json: JSONObject) throws
}
```


Property `json` is already implemented in extension of `JSONConvertible`, so you'll need to override that if your property names are different then field names returned in JSON (for the sake of simplicity example models are using same property names as received in JSON data).

You must implement only custom initializer with `JSONObject` and there you can use these helpers (coming from the extension of `JSONObject`):

- `try json.value(forKey: "SOME_KEY")` - use this to populate any supported value
- `try json.object(forKey: "SOME_KEY")` - use this to create any `JSONConvertible` model
- `try json.objectsArray(forKey: "SOME_KEY")` - use this to create any array of `JSONConvertible` model

Here's a complete example of some fictional model structure:

```swift
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
```

So that's it, you can use this to make nested JSON backed models, all there's left to do is to fill them with some data... 

> For more examples check out [Sources](Sources) and [Tests](Tests).

## License
This code is released under the MIT license. See [LICENSE](LICENSE) for details.
