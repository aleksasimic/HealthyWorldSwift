import Vapor

struct User: Content {
    let username: String
    let password: String
    let email: String
    let phoneNumber: String
    let favouriteFood: [FoodFav]
    let id: String
}
