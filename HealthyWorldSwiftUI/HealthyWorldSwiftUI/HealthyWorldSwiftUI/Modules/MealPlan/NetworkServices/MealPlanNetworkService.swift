import Foundation

struct MealPlanNetworkService: MealPlanNetworkServiceProtocol {
      let httpClient: HttpClient
      
      init(httpClient: HttpClient) {
          self.httpClient = httpClient
      }
}
