import Foundation
import Alamofire

public class HelloClient {
    private let baseUrl: String

  public init(baseUrl : String) {
    self.baseUrl = baseUrl
  }

  public func sayHello(helloResponse: (String) -> Void) {
    Alamofire.request(.GET, "\(baseUrl)/sayHello")
    .responseJSON {
      (response) in
      print(response)
      if let jsonResult = response.result.value as? Dictionary<String, AnyObject> {
        helloResponse(jsonResult["reply"] as! String)
      }
    }
  }

  public func findFriendsByAgeAndChild(friendsResponse: (Array<String>) -> Void) {
    Alamofire.request(.GET, "\(baseUrl)/friends", parameters: [ "age" : "30", "child" : "Mary" ] )
    .responseJSON { (response) in
      print(response)
      if let jsonResult = response.result.value as? Dictionary<String, AnyObject> {
        friendsResponse(jsonResult["friends"] as! Array)
      }
    }
  }
  
  public func unfriendMe(successResponse: (Dictionary<String, String>) -> Void, errorResponse: (Int) -> Void) {
    Alamofire.request(.PUT, "\(baseUrl)/unfriendMe" )
      .responseJSON { (response) in
        print(response)
	switch response.result {
	  case .Success:
            if let jsonResult = response.result.value as? Dictionary<String, String> {
              successResponse(jsonResult)
            }
          case .Failure(let error):
            print(error)
            errorResponse(response.response!.statusCode)
	}
    }
  }
}
