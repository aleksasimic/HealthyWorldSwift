import SwiftUI

struct FoodReviewsViewRow: View {
    var review: Review
    var body: some View {
        VStack(alignment: .center) {
            Text(review.reviewText)
                .fontWeight(.semibold)
                .font(.titleSmall)
            Text("by: \(review.username), on: \(review.dateString)")
                .foregroundColor(.primaryColor)
                
        }.background(LinearGradient(gradient:
            Gradient(colors: [.secondaryColor, .secondaryColor]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(5)
    }
}

struct FoodReviewsViewRow_Previews: PreviewProvider {
    static var previews: some View {
        FoodReviewsViewRow(review: Review(username: "Username", review: "Ovo je moj review", dateString: "13 01 1996"))
    }
}
