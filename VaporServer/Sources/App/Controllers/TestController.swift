import Vapor
import MongoSwift

final class TestController {
    func post(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.content.decode(TestModel.self).map(to: HTTPStatus.self) { user in
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("testUsers", withType: TestModel.self)
            _ = try! collection.insertOne(user)
            return HTTPStatus.ok
        }
    }
    
    func get(_ req: Request) throws -> Future<[Food]> {
        req.future().map {
            print("primioSam")
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("food", withType: Food.self)
            let cursor = try! collection.find()
            var food = [Food]()
            for document in cursor {
                let foodItem = Food(id: document.id, name: document.name, latinName: document.latinName, description: document.description, price: document.price, protein: document.protein, fat: document.fat, kcals: document.kcals, img: document.img, currency: document.currency, tags: document.tags, category: document.category, reviews: document.reviews, owner: document.owner, place: document.place, phoneNumber: document.phoneNumber)
                food.append(foodItem)
            }
            return food
        }
    }
    
    func update(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.content.decode(TestModel.self).map(to: HTTPStatus.self) { user in
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("testUsers", withType: TestModel.self)
            let query: Document = ["id": BSON(user.id)]
            let updatedUser: Document = ["$set": ["username": BSON(stringLiteral: user.testUsername!), "password": BSON(stringLiteral:user.testPassword!)]]
            _ = try! collection.updateOne(filter: query, update: updatedUser)
            return HTTPStatus.ok
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        req.future().map {
            let userId = try req.parameters.next(Int.self)
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("testUsers", withType: TestModel.self)
            let query: Document = ["id": BSON(userId)]
            _ = try! collection.deleteOne(query)
            return HTTPStatus.ok
        }
    }
}
