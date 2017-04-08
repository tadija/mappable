# Convertible

**Swift package for simple and lightweight serializing models**

> I made this for personal use, feel free to use it or contribute if you like.

## Include

- [Swift Package Manager](https://swift.org/package-manager/):

```
.Package(url: "https://github.com/tadija/convertible.git", majorVersion: 0)
```

## Use

Example below is based on JSON data received from [GitHub API](https://developer.github.com/v3/).  
**Note:** Models in example are unnecessary complex in order to show capabilities of this package.

Start with conforming your models to `Convertible` protocol.  

```swift
public protocol Convertible {
    var dictionary: [String : Any] { get }
    init(dictionary: [String : Any]) throws
}
```


Property `dictionary` is already implemented in `Convertible` protocol extension, so you'll need to override that only if your property names are different then those returned from server (for the sake of simplicity, [example models](Tests/ConvertibleTests/Models.swift) are using same property names).

You must implement only custom initializer with `[String : Any]` and there you can use these helpers:

- `try dictionary.value(forKey: "SOME_KEY")` - populate any supported value
- `try dictionary.object(forKey: "SOME_KEY")` - create any nested `Convertible` model
- `try dictionary.objectsArray(forKey: "SOME_KEY")` - create array of nested `Convertible` models

Finally, when you're done implementing `Convertible` on your models, you can do these kind of stuff:

```swift
let jsonData = ...

// create custom models directly from JSON data
let customModel = CustomModel(jsonData: jsonData)

// create array of custom models
let arrayOfCustomModels: [CustomModel] = CustomModel.array(with: jsonData)

// get model's JSON representation
let jsonData = customModel.json()
```

> For more examples check out [Sources](Sources) and [Tests](Tests).

## License
This code is released under the MIT license. See [LICENSE](LICENSE) for details.
