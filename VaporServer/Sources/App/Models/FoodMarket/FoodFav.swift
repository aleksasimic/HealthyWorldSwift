import Foundation
import Vapor

public struct FoodFav: Content {
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
    var category: String
    var owner: String
    var place: String
}
