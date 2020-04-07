import Vapor

public struct FoodUpdate: Content {
    var id: String
    var latinName: String
    var description: String
    var kcals: Int
    var protein: Int
    var fat: Int
    var price: Int
    var currency: Currency
    var place: String
}
