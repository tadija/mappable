import XCTest
@testable import JSONConvertible

class JSONTests: XCTestCase {
    
    let dataSource = DataSource()
    
    func testJSONConvertible() {
        let fetchModel = expectation(description: "Fetch Model")
        
        dataSource.fetchModel(username: "tadija") { (closure) in
            do {
                let data = try closure()
                let json = data as! JSONObject
                let isValid = try self.performValidation(with: json)
                XCTAssert(isValid)
            } catch {
                debugPrint(error)
                XCTAssert(false)
            }
            fetchModel.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    private func performValidation(with json: JSONObject) throws -> Bool {
        let profile = try Profile(json: json)
        let isModelValid = performModelValidation(with: profile)
        let isModelJSONValid = performJSONValidation(with: profile)
        let isValid = isModelValid && isModelJSONValid
        return isValid
    }
    
    private func performModelValidation(with profile: Profile) -> Bool {
        let thisRepo = profile.repos.filter{ $0.id == 82324664 }.first
        if profile.user.id == 2762374,
            profile.user.login == "tadija",
            profile.name == "Marko Tadić",
            let repo = thisRepo,
            repo.name == "json-convertible",
            repo.owner.login == "tadija"
        {
            return true
        } else {
            return false
        }
    }
    
    private func performJSONValidation(with profile: Profile) -> Bool {
        if let user = profile.json["user"] as? JSONObject,
            let name = profile.json["name"] as? String,
            let repos = profile.json["repos"] as? [JSONObject],
            user["id"] as? Int == 2762374,
            user["login"] as? String == "tadija",
            name == "Marko Tadić",
            let thisRepo = repos.filter({ $0["id"] as? Int == 82324664 }).first,
            thisRepo["name"] as? String == "json-convertible",
            let owner = thisRepo["owner"] as? JSONObject,
            owner["login"] as? String == "tadija"
        {
            return true
        } else {
            return false
        }
    }

    static var allTests : [(String, (JSONTests) -> () throws -> Void)] {
        return [
            ("testJSONConvertible", testJSONConvertible),
        ]
    }
    
}
