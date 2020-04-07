import Foundation
import SwiftUI
import Combine

protocol AuthorizationNetworkServiceProtocol {
    func login(username: String, password: String) -> AnyPublisher<UserUsername, Error>
    func signup(withUser user: User) -> AnyPublisher<Void, Error>
}
