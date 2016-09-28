import Foundation
import Alamofire

open class HelloClient {
    fileprivate let baseUrl: String

  public init(baseUrl : String) {
    self.baseUrl = baseUrl
  }

  open func sayHello(_ helloResponse: @escaping (String) -> Void) {
    Alamofire.request("\(baseUrl)/sayHello")
    .responseJSON {
      (response) in
      print(response)
      if let jsonResult = response.result.value as? Dictionary<String, AnyObject> {
        helloResponse(jsonResult["reply"] as! String)
      }
    }
  }

  open func findFriendsByAgeAndChild(_ friendsResponse: @escaping (Array<String>) -> Void) {
    Alamofire.request("\(baseUrl)/friends", parameters: [ "age" : "30", "child" : "Mary" ] )
    .responseJSON { (response) in
      print(response)
      if let jsonResult = response.result.value as? Dictionary<String, AnyObject> {
        friendsResponse(jsonResult["friends"] as! Array)
      }
    }
  }
  
  open func unfriendMe(_ successResponse: @escaping (Dictionary<String, String>) -> Void, errorResponse: @escaping (Int) -> Void) {
    Alamofire.request("\(baseUrl)/unfriendMe", method: .put)
      .responseJSON { (response) in
        print(response)
	switch response.result {
	  case .success:
            if let jsonResult = response.result.value as? Dictionary<String, String> {
              successResponse(jsonResult)
            }
          case .failure(let error):
            print(error)
            errorResponse(response.response!.statusCode)
	}
    }
  }
}
