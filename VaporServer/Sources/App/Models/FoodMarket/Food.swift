import Vapor

public struct Food: Content {
    var id: String
    var name: String
    var latinName: String
    var description: String
    var price: Int
    var protein: Int
    var fat: Int
    var kcals: Int
    var img: String
    var currency: Currency
    var tags: [String]
    var category: String
    var reviews: [Review]
    var owner: String
    var place: String
    var phoneNumber: String
}
