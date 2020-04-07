import Foundation
import Vapor

public struct Topic: Content {
    var id: String
    var name: String
    var author: String
    var dateString: String
    var comments: [Comment]
    var description: String
}
