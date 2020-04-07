import Foundation

public struct Review: Decodable, Identifiable {
    var username: String
    var reviewText: String
    var dateString: String
    public var id: String
    
    init(username: String, review: String, dateString: String) {
        self.username = username
        self.reviewText = review
        self.dateString = dateString
        self.id = UUID().uuidString
    }
}
