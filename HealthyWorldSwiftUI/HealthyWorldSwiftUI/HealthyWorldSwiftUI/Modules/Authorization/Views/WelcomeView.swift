import SwiftUI

struct WelcomeView: View {
    @State var selection: Int? = nil
    @State var loginClicked: Int? = nil
    @State var signupClicked: Int? = nil
    
    
    var container: RootContainer!
    
    init(container: RootContainer) {
        self.container = container
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 30) {
                Image("healthy_world_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75.0,height:75)
                Text("Welcome to Healthy world")
                    .foregroundColor(.primaryColor)
                    .font(.titleLarge)
                    .fontWeight(.semibold)
                Text("Start taking care of yourself with us!")
                    .foregroundColor(.primaryColor)
                    .font(.titleSmall)
                    .fontWeight(.light)
                VStack(alignment: .center, spacing: 20) {
                    NavigationLink(destination: LoginView(container: self.container), tag: 1, selection: $loginClicked) {
                        Button(action: {
                            self.loginClicked = 1
                        }) {
                            Text("Log in")
                                .font(.buttonFont)
                                .fontWeight(.bold)
                        }
                        .buttonStyle(GradientBackgroundStyle())
                    }
                    NavigationLink(destination: SignupView(container: self.container), tag: 2, selection: $signupClicked) {
                        Button(action: {
                            self.signupClicked = 2
                        }) {
                            Text("Sign up")
                                .font(.buttonFont)
                                .fontWeight(.bold)
                        }.buttonStyle(GradientBackgroundStyle())
                    }
                }
                Spacer()
                Image("hw_welcome_screen")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 10)
            }.padding(EdgeInsets(top: 50, leading: 10, bottom: 10, trailing: 10))
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(container: RootContainer())
    }
}
