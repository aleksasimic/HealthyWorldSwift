import Foundation
import Vapor

public struct Comment: Content {
    public var id: String
    var text: String
    var author: String
    var dateString: String
    var likes: Int
    var dislikes: Int
}
