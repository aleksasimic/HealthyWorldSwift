import Foundation
import Combine

class AddFoodViewModel: Identifiable, ObservableObject {
    @Published var name: String = ""
    @Published var latinName: String = ""
    @Published var description: String = ""
    @Published var price: Int = 0
    @Published var protein: Int = 0
    @Published var fat: Int = 0
    @Published var kcals: Int = 0
    @Published var img: String = ""
    @Published var currency: String = ""
    @Published var category: String = ""
    @Published var place: String = ""
    
    @Published var loading: Bool = false
    @Published var presentToast = false
    @Published var toastText = ""
    
    let service: FoodMarketNetworkServiceProtocol
    
    init(service: FoodMarketNetworkServiceProtocol) {
        self.service = service
    }
    
    func addFood(_ category: String, _ currency: String) {
        let currencyObj = Currency(code: currency, name: "", symbol: "")
        let user = UserDefaults.standard.string(forKey: "username")
        let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber")
        
        let foodObj = Food(name: name, latinName: latinName, description: description, price: price, protein: protein, fat: fat, kcals: kcals, img: img, currency: currencyObj, tags: [], category: category, reviews: [], owner: user!, place: place, phoneNumber: phoneNumber!)
        
        loading = true
              var cancelable: AnyCancellable?
        cancelable = service.addFood(forAdd: foodObj)
                  .sink(receiveCompletion: { completion in
                      self.loading = false
                      switch completion {
                       case .finished:
                        self.toastText = "Food added successfully"
                        self.presentToast = true
                       case .failure:
                          self.toastText = "Add food failure, please try again"
                          self.presentToast = true
                      }
                     }, receiveValue: { returnValue in })
              cancelable?.cancel()
        loading = false
    }
}
