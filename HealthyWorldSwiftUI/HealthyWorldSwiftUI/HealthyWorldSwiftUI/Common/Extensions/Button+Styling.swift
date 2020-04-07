import Foundation
import SwiftUI

struct GradientBackgroundStyle: ButtonStyle {
    var disabled = false
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(disabled ? LinearGradient(gradient:
                Gradient(colors: [Color.gray, Color.gray]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient:
                Gradient(colors: [.gradientStart, .primaryColor]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, 20)
    }
}

struct GradientBackgroundStyleDelete: ButtonStyle {
    var disabled = false
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(disabled ? LinearGradient(gradient:
                Gradient(colors: [Color.gray, Color.gray]), startPoint: .leading, endPoint: .trailing) : LinearGradient(gradient:
                Gradient(colors: [.red, .red]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, 20)
    }
}
