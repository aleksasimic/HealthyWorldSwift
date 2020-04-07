import Vapor

struct UserDTO: Content {
    let username: String
    let password: String
}
