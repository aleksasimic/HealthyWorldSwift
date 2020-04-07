import SwiftUI
import Combine

struct LoginView: View {
    @ObservedObject private var loginViewModel: LoginViewModel
    
    var container: RootContainer!
    
    init(container: RootContainer) {
        self.container = container
        self.loginViewModel = LoginViewModel(service: self.container.authorizationNetworkService)
    }
    
    var body: some View {
        LoadingView(isShowing: $loginViewModel.loading) {
            VStack(alignment: .center, spacing: 30) {
                
                Text("Welcome back!")
                    .foregroundColor(.primaryColor)
                    .font(.titleSmall)
                    .fontWeight(.bold)
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Username")
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryColor)
                    TextField("", text: self.$loginViewModel.username)
                        .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Password")
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryColor)
                    SecureField("", text: self.$loginViewModel.password)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    NavigationLink(destination: RootTabBarView(container: self.container), isActive: self.$loginViewModel.loginSuccess) {
                        Button(action: {
                            self.loginViewModel.login()
                        }) {
                            Text("Log in")
                                .font(.buttonFont)
                                .fontWeight(.bold)
                        }.buttonStyle(GradientBackgroundStyle(disabled: !self.loginViewModel.isValid))
                    }.disabled(!self.loginViewModel.isValid)
                    HStack() {
                        
                        Text("Forgot password?")
                            .font(.titleSmall)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryColor)
                        Spacer()
                        Text("Need help?")
                            .font(.titleSmall)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryColor)
                    }
                    Spacer()
                }
                .navigationBarTitle("Log in", displayMode: .inline)
            } .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 20))
                .toast(isShowing: self.$loginViewModel.presentToastError, text: self.$loginViewModel.toastErrorText)
        }
    }
}
