import Foundation
import SwiftUI
import Combine

struct FoodMarketNetworkService: FoodMarketNetworkServiceProtocol {
    
    let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func searchFood(forInformation info: FoodSearchInformation) -> AnyPublisher<[Food], Error> {
        let url = URL(string: Endpoints.Search)!
        
        let body:Json = [
            Keys.Name: info.name as AnyObject,
            Keys.Category: info.category as AnyObject,
            Keys.MinProtein: info.minProtein as AnyObject,
            Keys.MaxProtein: info.maxProtein as AnyObject,
            Keys.MinFat: info.minFat as AnyObject,
            Keys.MaxFat: info.maxFat as AnyObject,
            Keys.MinKcals: info.minKcals as AnyObject,
            Keys.MaxKcals: info.maxKcals as AnyObject
        ]
        
        return httpClient.sendRequest(method: .Post, url: url, body: body)
    }
    func addFood(forAdd food: Food) -> AnyPublisher<Void, Error> {
        let url = URL(string: Endpoints.AddFood)!
        
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
            Keys.Tags: food.tags as AnyObject,
            Keys.Category: food.category as AnyObject,
            Keys.Reviews: food.reviews as AnyObject,
            Keys.Owner: food.owner as AnyObject,
            Keys.Place: food.place as AnyObject,
            Keys.PhoneNumber: food.phoneNumber as AnyObject
        ]
        
        return httpClient.sendNoReplyRequest(method: .Post, url: url, body: body)
    }
    
    func deleteFood(withId id: String) -> AnyPublisher<Void, Error> {
        let urlString = "\(Endpoints.DeleteFood)/\(id)"
        let url = URL(string: urlString)!
        return httpClient.sendNoReplyRequest(method: .Delete, url: url)
    }
    
    func updateFood(newFood food: FoodUpdate) -> AnyPublisher<Void, Error> {
        let url = URL(string: Endpoints.UpdateFood)!
        let currencyObj = [
            Keys.Code: food.currency.code as AnyObject,
            Keys.CurrencyName: food.currency.name as AnyObject,
            Keys.Symbol: food.currency.symbol as AnyObject
        ]
        let body: Json = [
            Keys.Id : food.id as AnyObject,
            Keys.LatinName : food.latinName as AnyObject,
            Keys.Description : food.description as AnyObject,
            Keys.Kcals : food.kcals as AnyObject,
            Keys.Protein : food.protein as AnyObject,
            Keys.Fat: food.fat as AnyObject,
            Keys.Price: food.price as AnyObject,
            Keys.Currency: currencyObj as AnyObject,
            Keys.Place: food.place as AnyObject
        ]
        
        return httpClient.sendNoReplyRequest(method: .Patch, url: url, body: body)
    }
    
    func addToFavourites(food: Food, userId: String) -> AnyPublisher<Void,Error> {
        
        let urlString = "\(Endpoints.AddToFav)/\(userId)"
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
        
        return httpClient.sendNoReplyRequest(method: .Patch, url: url, body: body)
    }
    
    func addReview(foodId: String, review: Review) -> AnyPublisher<[Review], Error> {
        let urlString = "\(Endpoints.AddReview)/\(foodId)"
        let url = URL(string: urlString)!
        
        let body: Json = [
            Keys.Id: review.id as AnyObject,
            Keys.Username: review.username as AnyObject,
            Keys.Date: review.dateString as AnyObject,
            Keys.Review: review.reviewText as AnyObject
        ]
        return httpClient.sendRequest(method: .Patch, url: url, body: body)
    }
}

private extension FoodMarketNetworkService {
    struct Endpoints {
        static let Market         = "http://localhost:8080/market"
        static let Search    = "\(Market)/search"
        static let AddFood   = "\(Market)/add"
        static let DeleteFood = "\(Market)/delete"
        static let UpdateFood = "\(Market)/update"
        static let AddToFav   = "\(Market)/favourites"
        static let AddReview  = "\(Market)/reviews"
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
        
        static let CurrencySearch = "currencyFlat"
        static let MinProtein = "minProtein"
        static let MaxProtein = "maxProtein"
        static let MinFat = "minFat"
        static let MaxFat = "maxFat"
        static let MinKcals = "minKcals"
        static let MaxKcals = "maxKcals"
        
        
        static let Username = "username"
        static let Review = "reviewText"
        static let Date = "dateString"
    }
}
