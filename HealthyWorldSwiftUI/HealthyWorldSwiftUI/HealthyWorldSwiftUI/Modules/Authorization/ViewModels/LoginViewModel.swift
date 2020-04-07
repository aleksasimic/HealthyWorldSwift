import Foundation
import Combine

class LoginViewModel: ObservableObject, Identifiable {
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var isValid = false
    @Published var loading = false
    @Published var loginSuccess = false
    @Published var presentToastError = false
    @Published var toastErrorText = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    let service: AuthorizationNetworkServiceProtocol
    
    var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .map { input in
                return input.count >= 3
        }
        .eraseToAnyPublisher()
    }
  
    var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { password in
                return password.count >= 3
        }
        .eraseToAnyPublisher()
    }
    
    var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
            .receive(on: RunLoop.main)
            .map { userNameIsValid, passwordIsValid in
                return userNameIsValid && passwordIsValid
        }
        .eraseToAnyPublisher()
    }
    
    init(service: AuthorizationNetworkServiceProtocol) {
        self.service = service
        
        isFormValidPublisher
        .receive(on: RunLoop.main)
        .assign(to: \.isValid, on: self)
        .store(in: &cancellableSet)
    }
    
    func login() {
        loading = true
        var cancelable: AnyCancellable?
        cancelable = service.login(username: self.username, password: self.password)
            .sink(receiveCompletion: { completion in
                self.loading = false
                switch completion {
                 case .finished:
                    self.loginSuccess = true
                 case .failure:
                    self.toastErrorText = "User not found, please try again"
                    self.presentToastError = true
                }
               }, receiveValue: {
                UserDefaults.standard.set($0.username, forKey: "username")
                UserDefaults.standard.set($0.phoneNumber, forKey: "phoneNumber")
            })
        cancelable?.cancel()
    }
}
