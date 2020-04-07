import Foundation
import Combine

class FoodReviewsViewModel: Identifiable, ObservableObject {
    
    @Published var review = ""
    @Published var reviews: [Review]
    
    @Published var loading: Bool = false
    @Published var presentToast = false
    @Published var toastText = ""
    
    let service: FoodMarketNetworkServiceProtocol
    let foodId: String
    
    init(service: FoodMarketNetworkServiceProtocol, reviews: [Review], foodId: String) {
        self.service = service
        self.reviews = reviews
        self.foodId = foodId
    }
    
    func addReview() {
        let user = UserDefaults.standard.string(forKey: "username")!
        
        let dateFormatter = DateFormatter.customDateFormatter
        
        let dateString = dateFormatter.string(from: Date())
        
        let review = Review(username: user, review: self.review, dateString: dateString)
        loading = true
        var cancelable: AnyCancellable?
        
        cancelable = service.addReview(foodId: self.foodId, review: review)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.toastText = "Review added successfully"
                    self.presentToast = true
                    self.review = ""
                case .failure:
                    self.toastText = "Something went wrong, please try again"
                    self.presentToast = true
                }
                
            }, receiveValue: { newReviews in
                self.reviews = newReviews
            })
        cancelable?.cancel()
        loading = false
    }
}
