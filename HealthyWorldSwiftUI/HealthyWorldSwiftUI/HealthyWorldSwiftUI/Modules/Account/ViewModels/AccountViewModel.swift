import Foundation
import Combine

class AccountViewModel: ObservableObject, Identifiable {
    @Published var myFood: [Food] = []
    @Published var favFood: [FoodFav] = []
    
    @Published var loading = false
    @Published var presentToastError = false
    @Published var toastErrorText = ""
    
    let service: AccountNetworkServiceProtocol
    
    init(service: AccountNetworkServiceProtocol) {
        self.service = service
    }
    
    func getFavFood() {
        let user = UserDefaults.standard.string(forKey: "username")!
        var cancelable: AnyCancellable?
        cancelable = service.getFavouriteFood(forUser: user)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self.toastErrorText = "Something went wrong, data did not load correctly"
                    self.presentToastError = true
                }
            }, receiveValue: {
                food in
                self.favFood = food
            })
        cancelable?.cancel()
    }
    
    func getMyFood() {
        let user = UserDefaults.standard.string(forKey: "username")!
        var cancelable: AnyCancellable?
        cancelable = service.getMyFood(forUser: user)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self.toastErrorText = "Something went wrong, data did not load correctly"
                    self.presentToastError = true
                }
            }, receiveValue: {
                food in
                self.myFood = food
            })
        cancelable?.cancel()
    }
    
    func removeFromFavourites(favFood: FoodFav) {
        let user = UserDefaults.standard.string(forKey: "username")!
        var cancelable: AnyCancellable?
        cancelable = service.removeFromFavourites(user: user, food: favFood)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                      self.toastErrorText = "Food removed from favourite"
                      self.presentToastError = true
                case .failure:
                    self.toastErrorText = "Something went wrong, please try again"
                    self.presentToastError = true
                }
            }, receiveValue: {
                updatedFavs in
                self.favFood = updatedFavs
            })
        cancelable?.cancel()
    }
    
    func fetchData() {
        loading = true
        getMyFood()
        getFavFood()
        loading = false
    }
}


extension AccountViewModel {
    public static let url: String = "https://southernplasticsurgery.com.au/wp-content/uploads/2013/10/user-placeholder.png"
}
