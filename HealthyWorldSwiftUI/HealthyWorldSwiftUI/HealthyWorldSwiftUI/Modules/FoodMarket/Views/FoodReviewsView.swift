import SwiftUI

struct FoodReviewsView: View {
    @ObservedObject private var foodReviewsViewModel: FoodReviewsViewModel
    var container: RootContainer!
    
    init(container: RootContainer, reviews: [Review], foodId: String) {
        self.container = container
        self.foodReviewsViewModel = FoodReviewsViewModel(service: self.container.foodMarketNetworkService, reviews: reviews, foodId: foodId)
    }
    
    var body: some View {
        LoadingView(isShowing: $foodReviewsViewModel.loading) {
            VStack(alignment: .center, spacing: 10) {
                if (self.foodReviewsViewModel.reviews.count == 0) {
                    Text("There are no reviews for this food yet")
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryColor)
                } else {
                    VStack(alignment: .center){
                        List(self.foodReviewsViewModel.reviews) { review in
                            FoodReviewsViewRow(review: review)
                        }
                    }
                }
                VStack {
                    TextField("Your review here", text: self.$foodReviewsViewModel.review)
                        .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        self.foodReviewsViewModel.addReview()
                    }){
                        Text("Add review")
                            .font(.buttonFont)
                            .fontWeight(.bold)
                    }.buttonStyle(GradientBackgroundStyle())
                }
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .navigationBarTitle("Food reviews", displayMode: .inline)
                .toast(isShowing: self.$foodReviewsViewModel.presentToast, text: self.$foodReviewsViewModel.toastText)
        }
    }
}

struct FoodReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        FoodReviewsView(container: RootContainer(), reviews: [Review](), foodId: "id")
    }
}
