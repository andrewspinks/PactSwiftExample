import UIKit
import XCTest
import PactSwiftExample
import PactConsumerSwift

class PactSwiftExampleTests: XCTestCase {

  var helloProvider: MockService?
  var helloClient: HelloClient?

  override func setUp() {
    super.setUp()
    helloProvider = MockService(provider: "Hello Provider", consumer: "Hello Consumer")
    helloClient = HelloClient(baseUrl: helloProvider!.baseUrl)
  }

  override func tearDown() {
    super.tearDown()
  }

  func testItSaysHello() {
    helloProvider!.uponReceiving("a request for hello")
                  .withRequest(method:.GET, path: "/sayHello")
                  .willRespondWith(status: 200,
                                   headers: ["Content-Type": "application/json"],
                                   body: ["reply": "Hello"])

    //Run the tests
    helloProvider!.run { (testComplete) -> Void in
      self.helloClient!.sayHello { (response) in
        XCTAssertEqual(response, "Hello")
        testComplete()
      }
    }
  }
  
  func testItReturnsFriendsByAgeAndChild() {
    // Setup mock request and expected response
    helloProvider!.uponReceiving("a request for friends")
                  .withRequest(method: .GET,
                               path: "/friends",
                               query: ["age": "30", "child": "Mary J"])
                  .willRespondWith(status: 200,
                                   headers: ["Content-Type": "application/json"],
                                   body: ["friends": ["Clyde", "Edith", "John"]])
    
    // Run the test
    helloProvider!.run { (testComplete) -> Void in
      self.helloClient!.findFriendsByAgeAndChild(age: "30", child: "Mary J") { (response) in
        XCTAssertEqual(response, ["Clyde", "Edith", "John"])
        testComplete()
      }
    }
  }

  func test404Error() {
    helloProvider!.given("I have no friends")
                  .uponReceiving("a request to unfriend")
                  .withRequest(method:.PUT, path: "/unfriendMe")
                  .willRespondWith(status: 404, body: "No friends")

    //Run the tests
    helloProvider!.run{ (testComplete) -> Void in
      self.helloClient!.unfriendMe({ (response) in
          XCTAssertFalse(true)
          testComplete()
        }, errorResponse: { (error) in
          XCTAssertEqual(error, 404)
          testComplete()
        }
      )
    }
  }
}
