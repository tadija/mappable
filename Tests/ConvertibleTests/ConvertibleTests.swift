import XCTest
@testable import Convertible

class ConvertibleTests: XCTestCase {
    
    let dataSource = DataSource()
    
    func testConvertible() {
        let fetchModel = expectation(description: "Fetch Model")
        
        dataSource.fetchModel(username: "tadija") { (closure) in
            do {
                let data = try closure()
                let dictionary = data as! [String : Any]
                let isValid = try self.performValidation(with: dictionary)
                XCTAssert(isValid)
            } catch {
                debugPrint(error)
                XCTAssert(false)
            }
            fetchModel.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    private func performValidation(with dictionary: [String : Any]) throws -> Bool {
        let profile = try Profile(dictionary: dictionary)
        let isModelValid = performModelValidation(with: profile)
        let isModelDictionaryValid = performDictionaryValidation(with: profile)
        let isValid = isModelValid && isModelDictionaryValid
        return isValid
    }
    
    private func performModelValidation(with profile: Profile) -> Bool {
        let thisRepo = profile.repos.filter{ $0.id == 82324664 }.first
        if profile.user.id == 2762374,
            profile.user.login == "tadija",
            profile.name == "Marko Tadić",
            let repo = thisRepo,
            repo.name == "json-convertible",
            repo.`private` == false,
            repo.owner.login == "tadija"
        {
            return true
        } else {
            return false
        }
    }
    
    private func performDictionaryValidation(with profile: Profile) -> Bool {
        if let user = profile.dictionary["user"] as? [String : Any],
            let name = profile.dictionary["name"] as? String,
            let repos = profile.dictionary["repos"] as? Array<[String : Any]>,
            user["id"] as? Int == 2762374,
            user["login"] as? String == "tadija",
            name == "Marko Tadić",
            let thisRepo = repos.filter({ $0["id"] as? Int == 82324664 }).first,
            thisRepo["name"] as? String == "json-convertible",
            thisRepo["private"] as? Bool == false,
            let owner = thisRepo["owner"] as? [String : Any],
            owner["login"] as? String == "tadija"
        {
            return true
        } else {
            return false
        }
    }

    static var allTests : [(String, (ConvertibleTests) -> () throws -> Void)] {
        return [
            ("testConvertible", testConvertible),
        ]
    }
    
}
