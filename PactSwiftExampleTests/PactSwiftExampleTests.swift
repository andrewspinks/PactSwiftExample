import UIKit
import XCTest
import PactSwiftExample
import PactConsumerSwift

class PactSwiftExampleTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
      var hello = "not Goodbye"
      var helloProvider = MockService(provider: "Hello Provider", consumer: "Hello Consumer")
      let expectation = expectationWithDescription("Responds with hello")
      
      helloProvider.uponReceiving("a request for hello")
        .withRequest(PactHTTPMethod.Get, path: "/sayHello")
        .willRespondWith(200, headers: ["Content-Type": "application/json"], body: [ "reply": "Hello"])
      
      //Run the tests
      helloProvider.run ( { (complete) -> Void in
        HelloClient(baseUrl: helloProvider.baseUrl).sayHello { (response) in
          hello = response
          complete()
        }
        }, result: { (verification) -> Void in
          // Important! This ensures all expected HTTP requests were actually made.
          XCTAssertEqual(verification, PactVerificationResult.Passed)
          expectation.fulfill()
      })
      
      waitForExpectationsWithTimeout(10) { (error) in }
    }

}
