import XCTest
@testable import JSON

class JSONTests: XCTestCase {
    
    let dataSource = DataSource()
    
    func testJSONConvertible() {
        let fetchModel = expectation(description: "Fetch Model")
        
        dataSource.fetchModel(username: "tadija") { (closure) in
            do {
                let data = try closure()
                let json = data as! JSONObject
                let user = try User(json: json)
                let thisRepo = user.repos.filter{ $0.id == 82324664 }.first
                
                if user.id == 2762374, user.username == "tadija", let repo = thisRepo, repo.name == "json" {
                    XCTAssert(true)
                } else {
                    XCTAssert(false)
                }
            } catch {
                debugPrint(error)
                XCTAssert(false)
            }
            
            fetchModel.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }


    static var allTests : [(String, (JSONTests) -> () throws -> Void)] {
        return [
            ("testJSONConvertible", testJSONConvertible),
        ]
    }
    
}
