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
    helloProvider.run({
      (complete) -> Void in
      HelloClient(baseUrl: helloProvider.baseUrl).sayHello {
        (response) in
        XCTAssertEqual(response, "Hello")
        complete()
      }
    }, result: {
      (verification) -> Void in
      // Important! This ensures all expected HTTP requests were actually made.
      XCTAssertEqual(verification, PactVerificationResult.Passed)
      expectation.fulfill()
    })

    waitForExpectationsWithTimeout(10) { (error) in }
  }

  func testFailsOnVerificationFailure() {
    var verificationResult = PactVerificationResult.Passed
    var helloProvider = MockService(provider: "Hello Provider", consumer: "Hello Consumer")
    let expectation = expectationWithDescription("Fails verification")

    helloProvider.uponReceiving("a request for hello")
                  .withRequest(PactHTTPMethod.Get, path: "/sayHello")
                  .willRespondWith(200, headers: ["Content-Type": "application/json"], body: [ "reply": "Hello"])

    //Run the tests
    helloProvider.run ( { (complete) -> Void in
      complete()
    }, result: { (verification) -> Void in
      verificationResult = verification
      XCTAssertEqual(verification, PactVerificationResult.Failed)
      expectation.fulfill()
    })

    waitForExpectationsWithTimeout(10) { (error) in }
  }

  func testRequestWithQueryParams() {
    var helloProvider = MockService(provider: "Hello Provider", consumer: "Hello Consumer")
    let expectation = expectationWithDescription("Responds with friends")

    helloProvider.uponReceiving("a request friends")
                  .withRequest(PactHTTPMethod.Get, path: "/friends", query: [ "age" : "30", "child" : "Mary" ])
                  .willRespondWith(200, headers: ["Content-Type": "application/json"], body: [ "friends": ["Sue"] ])

    //Run the tests
    helloProvider.run({
      (complete) -> Void in
      self.helloClient!.findFriendsByAgeAndChild {
        (response) in
        XCTAssertEqual(response[0], "Sue")
        complete()
      }
    }, result: {
      (verification) -> Void in
      XCTAssertEqual(verification, PactVerificationResult.Passed)
      expectation.fulfill()
    })

    waitForExpectationsWithTimeout(10) { (error) in }
  }

  func testPutRequest() {
    let expectation = expectationWithDescription("Unfriends fred")

    helloProvider!.given("I am friends with Fred")
                  .uponReceiving("a request to unfriend")
                  .withRequest(PactHTTPMethod.Put, path: "/unfriendMe")
                  .willRespondWith(200, headers: ["Content-Type": "application/json"], body: [ "reply": "Bye" ])

    //Run the tests
    helloProvider!.run({
      (complete) -> Void in
      self.helloClient!.unfriendMe( {
        (response) in
        XCTAssertEqual(response["reply"]!, "Bye")
        complete()
      }, errorResponse: {
        (error) in
        XCTAssertFalse(true)
        complete()
      })
    }, result: {
      (verification) -> Void in
      // Important! This ensures all expected HTTP requests were actually made.
      XCTAssertEqual(verification, PactVerificationResult.Passed)
      expectation.fulfill()
    })

    waitForExpectationsWithTimeout(10) { (error) in }
  }

  func test404Error() {
    let expectation = expectationWithDescription("Error occured")

    helloProvider!.given("I have no friends")
      .uponReceiving("a request to unfriend")
      .withRequest(PactHTTPMethod.Put, path: "/unfriendMe")
      .willRespondWith(404, body: "No friends")

    //Run the tests
    helloProvider!.run({
      (complete) -> Void in
      self.helloClient!.unfriendMe({
        (response) in
        XCTAssertFalse(true)
        complete()
      }, errorResponse: {
        (error) in
        XCTAssertEqual(error, 404)
        complete()
      })
    }, result: {
      (verification) -> Void in
      // Important! This ensures all expected HTTP requests were actually made.
      XCTAssertEqual(verification, PactVerificationResult.Passed)
      expectation.fulfill()
    })

    waitForExpectationsWithTimeout(10) { (error) in }
  }
}
