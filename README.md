# Mappable

**Swift package for simple and lightweight models mapping**

> I made this for personal use, feel free to use it or contribute if you like.

## Include

- [Swift Package Manager](https://swift.org/package-manager/):

```
.Package(url: "https://github.com/tadija/mappable.git", majorVersion: 0)
```

- [Carthage](https://github.com/Carthage/Carthage):

```
github "tadija/mappable"
```

## Use

Example below is based on JSON data received from [GitHub API](https://developer.github.com/v3/).  
**Note:** Models in example are unnecessary complex in order to show capabilities of this package.

Start with conforming your models to `Mappable` protocol.  

```swift
public protocol Mappable {
    var map: [String : Any] { get }
    init(map: [String : Any]) throws
}
```


Property `map` is already implemented in `Mappable` protocol extension, so you'll need to override that only if your property names are different then those returned from server (for the sake of simplicity, [example models](Tests/MappableTests/Models.swift) are using same property names).

You must implement only custom initializer with `map: [String : Any]` and there you can use these helpers:

- `try map.value(forKey: "SOME_KEY")` - populate any supported value
- `try map.object(forKey: "SOME_KEY")` - create any nested `Mappable` model
- `try map.objectsArray(forKey: "SOME_KEY")` - create array of nested `Mappable` models

### JSON

Finally, when you're done implementing `Mappable` on your models, you can do these kind of stuff:

```swift
struct Model: Mappable {
	...
}

let jsonData = ...

// create models directly from JSON data
let model = Model(jsonData: jsonData)

// create array of custom models
let arrayOfModels: [Model] = Model.array(with: jsonData)

// get model's JSON data representation
let jsonData = model.json()
```

> For more examples check out [Sources](Sources) and [Tests](Tests).

## License
This code is released under the MIT license. See [LICENSE](LICENSE) for details.
