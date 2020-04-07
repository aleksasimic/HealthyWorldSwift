import SwiftUI

struct SignupView: View {
    @ObservedObject private var signupViewModel: SignupViewModel
    
    var container: RootContainer!
    
    init(container: RootContainer) {
        self.container = container
        self.signupViewModel = SignupViewModel(service: self.container.authorizationNetworkService)
    }
    
    var body: some View {
        LoadingView(isShowing: $signupViewModel.loading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Username")
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryColor)
                    TextField("", text: self.$signupViewModel.username)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(self.signupViewModel.usernameMessage)
                        .font(.warningSmall)
                        .foregroundColor(.red)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Password")
                            .font(.titleSmall)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryColor)
                        SecureField("", text: self.$signupViewModel.password)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Repeat Password")
                            .font(.titleSmall)
                            .fontWeight(.semibold)     .foregroundColor(.primaryColor)
                        SecureField("", text: self.$signupViewModel.passwordAgain)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text(self.signupViewModel.passwordMessage)
                            .font(.warningSmall)
                            .foregroundColor(.red)
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email")
                            .font(.titleSmall)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryColor)
                        TextField("", text: self.$signupViewModel.email)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text(self.signupViewModel.emailMessage)
                            .font(.warningSmall)
                            .foregroundColor(.red)
                        Text("Phone number")
                            .fontWeight(.semibold) .font(.titleSmall)
                            .foregroundColor(.primaryColor)
                        TextField("", text: self.$signupViewModel.phoneNumber)
                            .keyboardType(.numberPad)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text(self.signupViewModel.phoneNumberMessage)
                            .font(.warningSmall)
                            .foregroundColor(.red)
                    }
                    NavigationLink(destination: LoginView(container: self.container), isActive: self.$signupViewModel.signUpSuccess) {
                        Button(action: {
                            self.signupViewModel.signUp()
                        }) {
                            Text("Sign up")
                                .font(.buttonFont)
                                .fontWeight(.bold)
                        }.buttonStyle(GradientBackgroundStyle(disabled: !self.signupViewModel.isValid))
                    }.disabled(!self.signupViewModel.isValid)
                    Spacer()
                }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            }.navigationBarTitle("Sign up", displayMode: .inline)
        }
    }
}
