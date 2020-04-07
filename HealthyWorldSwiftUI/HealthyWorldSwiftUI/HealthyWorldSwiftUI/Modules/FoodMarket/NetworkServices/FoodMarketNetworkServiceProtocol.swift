import Foundation
import Combine

protocol FoodMarketNetworkServiceProtocol {
    func searchFood(forInformation info: FoodSearchInformation) -> AnyPublisher<[Food], Error>
    func addFood(forAdd food: Food) -> AnyPublisher<Void,Error>
    func deleteFood(withId id: String) -> AnyPublisher<Void, Error>
    func updateFood(newFood food: FoodUpdate) -> AnyPublisher<Void, Error>
    func addToFavourites(food: Food, userId: String) -> AnyPublisher<Void, Error>
    func addReview(foodId: String, review: Review) -> AnyPublisher<[Review], Error>
}
