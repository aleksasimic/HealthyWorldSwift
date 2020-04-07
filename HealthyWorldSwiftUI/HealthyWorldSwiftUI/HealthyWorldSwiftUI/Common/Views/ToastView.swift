import Foundation
import SwiftUI

struct Toast<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    let presenting: () -> Presenting
    @Binding var text: String

    var body: some View {
         if self.isShowing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.isShowing = false }
        }
        return GeometryReader { geometry in

            ZStack(alignment: .center) {

                self.presenting()
                    .blur(radius: self.isShowing ? 1 : 0)

                VStack {
                    Text(self.text)
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondaryColor)
                .foregroundColor(Color.primaryColor)
                .cornerRadius(20)
                .transition(.slide)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}

extension View {

    func toast(isShowing: Binding<Bool>, text: Binding<String>) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text)
    }

}
