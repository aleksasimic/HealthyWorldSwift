import Vapor

public struct FoodSearchInformation: Content {
    var name: String
    var category: String
    var minProtein: Int
    var maxProtein: Int
    var minFat: Int
    var maxFat: Int
    var minKcals: Int
    var maxKcals: Int
}
