import Foundation
import SwiftUI
import Combine

struct AuthorizationNetworkService: AuthorizationNetworkServiceProtocol {
    
    let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    func login(username: String, password: String) -> AnyPublisher<UserUsername, Error>  {
        
        let url = URL(string: Endpoints.Login)!
        
        let body: Json = [
            Keys.Username: username as AnyObject,
            Keys.Password: password as AnyObject
        ]
        
        return httpClient.sendRequest(method: .Post, url: url, body: body)
    }
    
    func signup(withUser user: User) -> AnyPublisher<Void, Error> {
        
        let url = URL(string: Endpoints.Signup)!
        
        let body: Json = [
            Keys.Username: user.username as AnyObject,
            Keys.Password: user.password as AnyObject,
            Keys.PhoneNumber: user.phoneNumber as AnyObject,
            Keys.Email: user.email as AnyObject,
            Keys.FavouriteFood: user.favouriteFood as AnyObject,
            Keys.Id: user.id as AnyObject
        ]
        
        return httpClient.sendNoReplyRequest(method: .Post, url: url, body: body)
    }
}

private extension AuthorizationNetworkService {
    struct Endpoints {
        static let Authorization         = "http://localhost:8080/auth"
        static let Login    = "\(Authorization)/login"
        static let Signup   = "\(Authorization)/signup"
    }
    
    struct Keys {
        static let Username = "username"
        static let Password = "password"
        static let Email = "email"
        static let PhoneNumber = "phoneNumber"
        static let FavouriteFood = "favouriteFood"
        static let Id = "id"
    }
}

