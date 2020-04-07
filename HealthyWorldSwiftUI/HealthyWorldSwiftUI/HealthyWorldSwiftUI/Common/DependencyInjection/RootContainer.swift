import Foundation

final class RootContainer {
    let client: HttpClient
    let authorizationNetworkService: AuthorizationNetworkService
    let foodMarketNetworkService: FoodMarketNetworkService
    let mealPlanNetworkService: MealPlanNetworkService
    let forumNetworkService: ForumNetworkService
    let accountNetworkService: AccountNetworkService
    
    public init() {
        self.client = HttpClient()
        self.authorizationNetworkService = AuthorizationNetworkService(httpClient: self.client)
        self.foodMarketNetworkService = FoodMarketNetworkService(httpClient: self.client)
        self.mealPlanNetworkService = MealPlanNetworkService(httpClient: self.client)
        self.forumNetworkService = ForumNetworkService(httpClient: self.client)
        self.accountNetworkService = AccountNetworkService(httpClient: self.client)
    }
}
