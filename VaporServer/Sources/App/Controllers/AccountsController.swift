import Foundation
import Vapor
import MongoSwift

final class AccountsController {
    func getMyFood(_ req: Request) throws -> Future<[Food]> {
        req.future().map {
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("food", withType: Food.self)
            let userId = try! req.parameters.next(String.self)
            let query: Document = ["owner": BSON(stringLiteral: userId)]
            do {
                var allFood = [Food]()
                let cursor = try collection.find(query)
                for document in cursor {
                    let foodItem = Food(id: document.id, name: document.name, latinName: document.latinName, description: document.description, price: document.price, protein: document.protein, fat: document.fat, kcals: document.kcals, img: document.img, currency: document.currency, tags: document.tags, category: document.category, reviews: document.reviews, owner: document.owner, place: document.place, phoneNumber: document.phoneNumber)
                    allFood.append(foodItem)
                }
                return allFood
            }
            catch {
                throw error
            }
        }
    }
    
    func getFavouriteFood(_ req: Request) throws ->  Future<[FoodFav]> {
        req.future().map {
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("usersNew", withType: User.self)
            let userId = try! req.parameters.next(String.self)
            let query: Document = ["username": BSON(stringLiteral: userId)]
            do {
                var favFood = [FoodFav]()
                let cursor = try collection.find(query)
                for document in cursor {
                    for item in document.favouriteFood {
                        favFood.append(item)
                    }
                }
                return favFood
            }
            catch {
                throw error
            }
        }
    }
    
    func removeFavouriteFood(_ req: Request) throws -> Future<[FoodFav]> {
        return try req.content.decode(FoodFav.self).map(to: [FoodFav].self) { food in
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("usersNew", withType: User.self)
            let userId = try! req.parameters.next(String.self)
            let query: Document = ["username": BSON(stringLiteral: userId)]
            let newCurrency: BSON = [
                "code": BSON(stringLiteral: food.currency.code),
                "name": BSON(stringLiteral: ""),
                "symbol": BSON(stringLiteral: "")
            ]
            
            let forRemove: BSON = [
                "id": BSON(stringLiteral: food.id),
                "name": BSON(stringLiteral: food.name),
                "latinName": BSON(stringLiteral: food.latinName),
                "description": BSON(stringLiteral: food.description),
                "category": BSON(stringLiteral: food.category),
                "img": BSON(stringLiteral: food.img),
                "place": BSON(stringLiteral: food.place),
                "owner": BSON(stringLiteral: food.owner),
                "price": BSON(food.price),
                "protein": BSON(food.protein),
                "kcals": BSON(food.kcals),
                "currency": newCurrency,
                "fat": BSON(food.fat)
            ]
            
            let updateQuery: Document = ["$pull": [
                "favouriteFood": forRemove
                ]]
            
            do {
                var favFood = [FoodFav]()
                try collection.updateOne(filter: query, update: updateQuery)
                let cursor = try collection.find(query)
                for document in cursor {
                    for item in document.favouriteFood {
                        favFood.append(item)
                    }
                }
                return favFood
                
            } catch {
                throw error
            }
        }
    }
}
