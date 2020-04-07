import Vapor
import MongoSwift

final class FoodMarketController {
    func searchFood(_ req: Request) throws -> Future<[Food]> {
        return try req.content.decode(FoodSearchInformation.self).map(to: [Food].self) { foodSearchInformation in
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("food", withType: Food.self)
            
            let regex: BSON = [
                "$regex": BSON(stringLiteral: ".*\(foodSearchInformation.name).*")
            ]
            var query: Document = [
                "name": regex]
            if foodSearchInformation.category != "All" {
                query["category"] = BSON(stringLiteral: foodSearchInformation.category)
            }
            
            let minKcals = foodSearchInformation.minKcals
            let maxKcals = foodSearchInformation.maxKcals
            let minFat = foodSearchInformation.minFat
            let maxFat = foodSearchInformation.maxFat
            let minProtein = foodSearchInformation.minProtein
            let maxProtein = foodSearchInformation.maxProtein
            
            if (maxKcals-minKcals != 0) {
                let kcalBson: BSON = [
                "$gt": BSON(minKcals),
                "$lt": BSON(maxKcals)
                ]
                query["kcals"] = kcalBson
            }
            
            if (maxProtein-minProtein != 0) {
                let proteinBson: BSON = [
                    "$gt": BSON(minProtein),
                    "$lt": BSON(maxProtein)
                ]
                query["protein"] = proteinBson
            }
            
            if (maxFat-minFat != 0) {
                let fatBson: BSON = [
                    "$gt": BSON(minFat),
                    "$lt": BSON(maxFat)
                ]
                query["kcals"] = fatBson
            }
            
            
            let cursor = try! collection.find(query)
            var food = [Food]()
            for document in cursor {
                let foodItem = Food(id: document.id, name: document.name, latinName: document.latinName, description: document.description, price: document.price, protein: document.protein, fat: document.fat, kcals: document.kcals, img: document.img, currency: document.currency, tags: document.tags, category: document.category, reviews: document.reviews, owner: document.owner, place: document.place, phoneNumber: document.phoneNumber)
                food.append(foodItem)
            }
            return food
        }
    }
    
    func addFood(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.content.decode(Food.self).map(to: HTTPStatus.self) { foodItem in
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("food", withType: Food.self)
            do {
                try collection.insertOne(foodItem)
            } catch {
                return HTTPStatus.internalServerError
            }
            return HTTPStatus.ok
        }
    }
    
    func updateFood(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.content.decode(FoodUpdate.self).map(to: HTTPStatus.self) { food in
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("food", withType: Food.self)
            let query: Document = ["id": BSON(stringLiteral: food.id)]
            let newCurrency: BSON = [
                "code": BSON(stringLiteral: food.currency.code),
                "name": BSON(stringLiteral: ""),
                "symbol": BSON(stringLiteral: "")
            ]
            let updatedUser: Document = ["$set": [
                "latinName": BSON(stringLiteral: food.latinName),
                "description": BSON(stringLiteral:food.description),
                "kcals": BSON(food.kcals),
                "protein": BSON(food.protein),
                "fat": BSON(food.fat),
                "place": BSON(stringLiteral: food.place),
                "price": BSON(food.price),
                "currency": newCurrency
                ]]
            do {
                try collection.updateOne(filter: query, update: updatedUser)
            } catch {
                return HTTPStatus.internalServerError
            }
            return HTTPStatus.ok
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        req.future().map {
            let userId = try req.parameters.next(String.self)
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("food", withType: Food.self)
            let query: Document = ["id": BSON(stringLiteral: userId)]
            do {
                try collection.deleteOne(query)
            } catch {
                return HTTPStatus.internalServerError
            }
            return HTTPStatus.ok
        }
    }
    func addReview(_ req: Request) throws -> Future<[Review]> {
        return try req.content.decode(Review.self).map(to: [Review].self) { review in
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("food", withType: Food.self)
            let foodId = try! req.parameters.next(String.self)
            let query: Document = ["id": BSON(stringLiteral: foodId)]
            
            let newReview: BSON = [
                "id": BSON(stringLiteral: review.id),
                "reviewText": BSON(stringLiteral: review.reviewText),
                "username": BSON(stringLiteral: review.username),
                "dateString": BSON(stringLiteral: review.dateString)
            ]
            
           let updateQuery: Document = ["$push": [
            "reviews": newReview
            ]]
            do {
                try collection.updateOne(filter: query, update: updateQuery)
                let cursor = try collection.find(query)
                var reviews = [Review]()
                for document in cursor {
                    for item in document.reviews {
                        reviews.append(item)
                    }
                }
                return reviews
            } catch {
                throw error
            }
        }
    }
    
    func addToFavourites(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.content.decode(FoodFav.self).map(to: HTTPStatus.self) { food in
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("usersNew", withType: User.self)
            let userId = try! req.parameters.next(String.self)
            let query: Document = ["username": BSON(stringLiteral: userId)]
             let newCurrency: BSON = [
                "code": BSON(stringLiteral: food.currency.code),
                "name": BSON(stringLiteral: ""),
                "symbol": BSON(stringLiteral: "")
            ]
            
            let newFood: BSON = [
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
            
            let updateQuery: Document = ["$push": [
                "favouriteFood": newFood
                ]]
            
            do {
                try collection.updateOne(filter: query, update: updateQuery)
            } catch {
                return HTTPStatus.internalServerError
            }
            return HTTPStatus.ok
        }
    }
}
