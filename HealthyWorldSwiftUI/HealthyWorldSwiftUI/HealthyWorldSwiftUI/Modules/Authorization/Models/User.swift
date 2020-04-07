import Foundation

public struct User: Decodable {
    let username: String
    let password: String
    let email: String
    let phoneNumber: String
    let favouriteFood: [FoodFav]
    let id: String
    
    init(username: String, password: String, email: String, phoneNumber: String, favouriteFood: [FoodFav]) {
        self.username = username
        self.password = password
        self.email = email
        self.phoneNumber = phoneNumber
        self.favouriteFood = favouriteFood
        self.id = UUID().uuidString
    }
}

public struct UserUsername: Decodable {
    let username: String
    let phoneNumber: String 
}
