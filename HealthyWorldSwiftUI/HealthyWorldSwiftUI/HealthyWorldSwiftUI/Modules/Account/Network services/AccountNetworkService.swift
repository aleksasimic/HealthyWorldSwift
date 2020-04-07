import Foundation
import Combine

struct AccountNetworkService: AccountNetworkServiceProtocol {
  
    func getMyFood(forUser user: String) -> AnyPublisher<[Food], Error> {
        let urlString = "\(Endpoints.MyFood)/\(user)"
        let url = URL(string: urlString)!
        
        return httpClient.sendRequest(method: .Get, url: url)
    }
    
    func getFavouriteFood(forUser user: String) -> AnyPublisher<[FoodFav], Error> {
        let urlString = "\(Endpoints.FavFood)/\(user)"
        let url = URL(string: urlString)!
        
        return httpClient.sendRequest(method: .Get, url: url)
    }
    
    func removeFromFavourites(user: String, food: FoodFav) -> AnyPublisher<[FoodFav], Error> {
        let urlString = "\(Endpoints.RemoveFav)/\(user)"
        let url = URL(string: urlString)!
        
        let currencyObj = [
            Keys.Code: food.currency.code as AnyObject,
            Keys.CurrencyName: food.currency.name as AnyObject,
            Keys.Symbol: food.currency.symbol as AnyObject
        ]
        
        let body: Json = [
            Keys.Id: food.id as AnyObject,
            Keys.Name : food.name as AnyObject,
            Keys.LatinName : food.latinName as AnyObject,
            Keys.Description : food.description as AnyObject,
            Keys.Price : food.price as AnyObject,
            Keys.Protein : food.protein as AnyObject,
            Keys.Fat: food.fat as AnyObject,
            Keys.Kcals: food.kcals as AnyObject,
            Keys.Img: food.img as AnyObject,
            Keys.Currency: currencyObj as AnyObject,
            Keys.Category: food.category as AnyObject,
            Keys.Owner: food.owner as AnyObject,
            Keys.Place: food.place as AnyObject
        ]
        
        return httpClient.sendRequest(method: .Patch, url: url, body: body)
    }
    
  
    let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
}

private extension AccountNetworkService {
    struct Endpoints {
        static let Account   = "http://localhost:8080/account"
        static let MyFood    = "\(Account)/myFood"
        static let FavFood   = "\(Account)/favouriteFood"
        static let RemoveFav = "\(Account)/removeFavourite"
    }
    
    struct Keys {
          static let Id = "id"
          static let Name = "name"
          static let LatinName = "latinName"
          static let Description = "description"
          static let Price = "price"
          static let Protein = "protein"
          static let Fat = "fat"
          static let Kcals = "kcals"
          static let Img = "img"
          static let Currency = "currency"
          static let Tags = "tags"
          static let Category = "category"
          static let Reviews = "reviews"
          static let Owner = "owner"
          static let Place = "place"
          static let Code = "code"
          static let CurrencyName = "name"
          static let Symbol = "symbol"
          static let PhoneNumber = "phoneNumber"
      }
}
