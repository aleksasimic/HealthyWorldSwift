import Foundation
import Combine
import Navajo_Swift

class SignupViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    @Published var email = ""
    @Published var phoneNumber = ""
    
    @Published var usernameMessage = ""
    @Published var passwordMessage = ""
    @Published var emailMessage = ""
    @Published var phoneNumberMessage = ""
    @Published var isValid = false
    
    @Published var loading = false
    @Published var signUpSuccess = false
    @Published var presentToastError = false
    @Published var toastErrorText = ""
    
    let service: AuthorizationNetworkServiceProtocol
    
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .map { input in
                return input.count >= 3
        }
        .eraseToAnyPublisher()
    }
    
    private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .map { input in
                  let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                  let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
                  return emailPredicate.evaluate(with: input)
        }
        .eraseToAnyPublisher()
    }
    
    private var isPhoneNumberValidPublisher: AnyPublisher<Bool, Never> {
        $phoneNumber
            .map { input in
                return input.count >= 6
        }
        .eraseToAnyPublisher()
    }
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { password in
                return password == ""
        }
        .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $passwordAgain)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { password, passwordAgain in
                return password == passwordAgain
        }
        .eraseToAnyPublisher()
    }
    
    private var passwordStrengthPublisher: AnyPublisher<PasswordStrength, Never> {
        $password
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return Navajo.strength(ofPassword: input)
        }
        .eraseToAnyPublisher()
    }
    
    private var isPasswordStrongEnoughPublisher: AnyPublisher<Bool, Never> {
        passwordStrengthPublisher
            .map { strength in
                switch strength {
                case .reasonable, .strong, .veryStrong:
                    return true
                default:
                    return false
                }
        }
        .eraseToAnyPublisher()
    }
    
    enum PasswordCheck {
        case valid
        case empty
        case noMatch
        case notStrongEnough
    }
    private var isPasswordValidPublisher: AnyPublisher<PasswordCheck, Never> {
        Publishers.CombineLatest3(isPasswordEmptyPublisher, arePasswordsEqualPublisher, isPasswordStrongEnoughPublisher)
            .map { passwordIsEmpty, passwordsAreEqual, passwordIsStrongEnough in
                if (passwordIsEmpty) {
                    return .empty
                }
                else if (!passwordsAreEqual) {
                    return .noMatch
                }
                else if (!passwordIsStrongEnough) {
                    return .notStrongEnough
                }
                else {
                    return .valid
                }
        }
        .eraseToAnyPublisher()
  }
  
  private var isFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest4(isUsernameValidPublisher, isPasswordValidPublisher, isEmailValidPublisher, isPhoneNumberValidPublisher)
      .map { userNameIsValid, passwordIsValid, phoneNumberValid, emailValid in
        return userNameIsValid && (passwordIsValid == .valid) && phoneNumberValid && emailValid
      }
    .eraseToAnyPublisher()
  }
  
    init(service: AuthorizationNetworkServiceProtocol) {
        
        self.service = service
        
        isUsernameValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Username must have at least 3 characters"
            }
            .assign(to: \.usernameMessage, on: self)
            .store(in: &cancellableSet)
    
        isEmailValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Email must be valid"
            }
            .assign(to: \.emailMessage, on: self)
            .store(in: &cancellableSet)
    
        isPhoneNumberValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Phone number must be valid"
            }
            .assign(to: \.phoneNumberMessage, on: self)
            .store(in: &cancellableSet)
    
        isPasswordValidPublisher
          .receive(on: RunLoop.main)
          .map { passwordCheck in
            switch passwordCheck {
            case .empty:
              return "Password must not be empty"
            case .noMatch:
              return "Passwords don't match"
            case .notStrongEnough:
              return "Password not strong enough"
            default:
              return ""
            }
          }
        .assign(to: \.passwordMessage, on: self)
        .store(in: &cancellableSet)

        isFormValidPublisher
          .receive(on: RunLoop.main)
          .assign(to: \.isValid, on: self)
          .store(in: &cancellableSet)
    }
    
    func signUp() {
        loading = true
        var cancelable: AnyCancellable?
        let user = User(username: username, password: password, email: email, phoneNumber: phoneNumber, favouriteFood: [])
        cancelable = service.signup(withUser: user)
            .sink(receiveCompletion: { completion in
                self.loading = false
                switch completion {
                case .finished:
                      self.signUpSuccess = true
                case .failure:
                    self.toastErrorText = "Signup unsuccessful, please try again"
                    self.presentToastError = true
                  }
                 }, receiveValue: { returnValue in })
        cancelable?.cancel()
    }

}
// when I call the server for search
//.debounce(for: 0.3, scheduler: RunLoop.main)
//.removeDuplicates()
