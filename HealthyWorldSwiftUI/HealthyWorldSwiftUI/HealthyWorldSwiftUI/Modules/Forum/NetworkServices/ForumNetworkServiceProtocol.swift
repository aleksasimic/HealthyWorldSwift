import Foundation
import SwiftUI
import Combine

protocol ForumNetworkServiceProtocol {
    func getTopics() -> AnyPublisher<[Topic], Error>
    func addTopic(topic: Topic) -> AnyPublisher<[Topic], Error>
    func addComment(comment: Comment, topicId: String) -> AnyPublisher<[Comment], Error>
    func addLike(comment: Comment, topicId: String) -> AnyPublisher<[Comment], Error>
    func addDislike(comment: Comment, topicId: String) -> AnyPublisher<[Comment], Error>
}
