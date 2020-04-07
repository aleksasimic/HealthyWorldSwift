import Vapor

struct TestModel: Content {
    var id: Int
    var testUsername: String?
    var testPassword: String?
}
