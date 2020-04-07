import Foundation

public struct Food: Decodable, Identifiable {
    public var id: String
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
    
    init(name: String, latinName: String, description: String, price: Int, protein: Int, fat: Int, kcals: Int, img: String, currency: Currency, tags: [String], category: String, reviews: [Review], owner: String, place: String, phoneNumber: String) {
        self.name = name
        self.latinName = latinName
        self.description = description
        self.price = price
        self.protein = protein
        self.fat = fat
        self.kcals = kcals
        self.img = img
        self.currency = currency
        self.tags = tags
        self.category = category
        self.reviews = reviews
        self.owner = owner
        self.place = place
        self.phoneNumber = phoneNumber
        self.id = UUID().uuidString
    }
}
