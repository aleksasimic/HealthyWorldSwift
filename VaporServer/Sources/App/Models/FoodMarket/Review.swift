import Vapor

public struct Review: Content {
    var username: String
    var reviewText: String
    var dateString: String
    var id: String
}
