import Foundation
import Combine

protocol AccountNetworkServiceProtocol {
    func getMyFood(forUser user: String) -> AnyPublisher<[Food], Error>
    
    func getFavouriteFood(forUser user: String) -> AnyPublisher<[FoodFav], Error>
    
    func removeFromFavourites(user: String, food: FoodFav) -> AnyPublisher<[FoodFav], Error>
}
