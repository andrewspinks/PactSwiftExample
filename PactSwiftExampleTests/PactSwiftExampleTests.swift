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
    var hello = "not Goodbye"
    var helloProvider = MockService(provider: "Hello Provider", consumer: "Hello Consumer")
    let expectation = expectationWithDescription("Responds with hello")

    helloProvider.uponReceiving("a request for hello")
                  .withRequest(PactHTTPMethod.Get, path: "/sayHello")
                  .willRespondWith(200, headers: ["Content-Type": "application/json"], body: ["reply": "Hello"])

    //Run the tests
    helloProvider.run({ (testComplete) -> Void in
        HelloClient(baseUrl: helloProvider.baseUrl).sayHello { (response) in
          XCTAssertEqual(response, "Hello")
          testComplete()
        }
      }
    ).onComplete { result in
      XCTAssertEqual(result, PactVerificationResult.Passed)
      expectation.fulfill()
    }

    waitForExpectationsWithTimeout(10) { (error) in }
  }

  func test404Error() {
    let expectation = expectationWithDescription("Error occured")

    helloProvider!.given("I have no friends")
      .uponReceiving("a request to unfriend")
      .withRequest(PactHTTPMethod.Put, path: "/unfriendMe")
      .willRespondWith(404, body: "No friends")

    //Run the tests
    helloProvider!.run({ (testComplete) -> Void in
        self.helloClient!.unfriendMe({ (response) in
            XCTAssertFalse(true)
            testComplete()
          }, errorResponse: { (error) in
            XCTAssertEqual(error, 404)
            testComplete()
          }
        )
      }
    ).onComplete { result in
      XCTAssertEqual(result, PactVerificationResult.Passed)
      expectation.fulfill()
    }

    waitForExpectationsWithTimeout(10) { (error) in }
  }
}
