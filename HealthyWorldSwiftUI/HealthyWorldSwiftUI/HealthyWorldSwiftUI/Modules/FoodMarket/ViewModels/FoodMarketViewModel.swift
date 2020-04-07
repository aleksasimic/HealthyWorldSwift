import Foundation
import Combine

class FoodMarketViewModel: ObservableObject, Identifiable {
    @Published var name: String = ""
    @Published var category: String = ""
    @Published var currency: String = ""
    @Published var minProtein: Int = 0
    @Published var maxProtein: Int = 0
    @Published var minKcals: Int = 0
    @Published var maxKcals: Int = 0
    @Published var minFat: Int = 0
    @Published var maxFat: Int = 0
    
    @Published var loading = false
    @Published var presentToastError = false
    @Published var toastErrorText = ""
    @Published var food: [Food] = []
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    let service: FoodMarketNetworkServiceProtocol
    
    init(service: FoodMarketNetworkServiceProtocol) {
        self.service = service
    }
    
    func search(category: String) {
        loading = true
        let foodInfoObj = FoodSearchInformation(name: name, category: category, minProtein: minProtein, maxProtein: maxProtein, minFat: minFat, maxFat: maxFat, minKcals: minKcals, maxKcals: maxKcals)
        var cancelable: AnyCancellable?
        cancelable = service.searchFood(forInformation: foodInfoObj)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self.toastErrorText = "Something went wrong, please try again"
                    self.presentToastError = true
                }
            }, receiveValue: { food in
                self.food = food
            })
        cancelable?.cancel()
        loading = false
    }
}
