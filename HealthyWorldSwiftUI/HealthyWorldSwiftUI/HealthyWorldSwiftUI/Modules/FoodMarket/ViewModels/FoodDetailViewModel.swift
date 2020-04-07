import Foundation
import Combine

class FoodDetailViewModel: Identifiable, ObservableObject {
    @Published var description: String
    @Published var latinName: String
    @Published var kcals: Int
    @Published var fat: Int
    @Published var protein: Int
    @Published var price: Int
    @Published var place: String 
    
    
    @Published var loading: Bool = false
    @Published var presentToast = false
    @Published var toastText = ""
    @Published var isMyFood = false
    @Published var empty = false
    
    let service: FoodMarketNetworkServiceProtocol
    let identifier: String
    
    init(service: FoodMarketNetworkServiceProtocol, description: String, latinName: String, kcals: Int, fat: Int, protein: Int, price: Int, place: String, owner: String, id: String) {
        self.service = service
        self.description = description
        self.latinName = latinName
        self.kcals = kcals
        self.fat = fat
        self.protein = protein
        self.price = price
        self.place = place
        let user = UserDefaults.standard.string(forKey: "username")
        if user == owner {
            self.isMyFood = true
        }
        self.identifier = id
    }
    
    func deleteFood(_ id: String) {
        loading = true
        var cancelable: AnyCancellable?
        cancelable = service.deleteFood(withId: id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.toastText = "Food successfully deleted"
                    self.presentToast = true
                    self.empty = true
                case .failure:
                    self.toastText = "Something went wrong, unable to delete object"
                    self.presentToast = true
                }
            }, receiveValue: {retVal in })
        cancelable?.cancel()
        loading = false
    }
    
    func editFood(currencyCode: String) {
        let currency = Currency(code: currencyCode, name: "", symbol: "")
        let newFood = FoodUpdate(id: identifier, latinName: latinName, description: description, kcals: kcals, protein: protein, fat: fat, price: price, currency: currency, place: place)
        loading = true
        var cancelable: AnyCancellable?
        cancelable = service.updateFood(newFood: newFood)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.toastText = "Food sucessfully Edited"
                    self.presentToast = true
                case .failure:
                    self.toastText = "Something went wrong, please try again"
                    self.presentToast = true
                }
            }, receiveValue: {retVal in})
        cancelable?.cancel()
        loading = false
    }
    
    func addToFavourites(_ food: Food) {
        let user = UserDefaults.standard.string(forKey: "username")!
        loading = true
        var cancelable: AnyCancellable?
        cancelable = service.addToFavourites(food: food, userId: user)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.toastText = "Food added to favourite foods"
                    self.presentToast = true
                case .failure:
                    self.toastText = "Something went wrong, please try again"
                    self.presentToast = true
                }
                
            }, receiveValue: {retVal in })
        cancelable?.cancel()
        loading = false
    }
}

