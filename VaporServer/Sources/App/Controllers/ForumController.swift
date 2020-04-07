import Vapor
import MongoSwift


final class ForumContorller {
    func getTopics(_ req: Request) throws -> Future<[Topic]> {
        req.future().map {
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("topics", withType: Topic.self)
            let cursor = try! collection.find()
            var topics = [Topic]()
            for document in cursor {
                let topicItem = Topic(id: document.id, name: document.name, author: document.author, dateString: document.dateString, comments: document.comments, description: document.description)
                topics.append(topicItem)
            }
            return topics
        }
    }
    
    func addTopic(_ req: Request) throws -> Future<[Topic]> {
        return try req.content.decode(Topic.self).map(to: [Topic].self) { topic in
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("topics", withType: Topic.self)
            do {
                try collection.insertOne(topic)
                var updatedTopics = [Topic]()
                let cursor = try collection.find()
                for document in cursor {
                    let topicItem = Topic(id: document.id, name: document.name, author: document.author, dateString: document.dateString, comments: document.comments, description: document.description)
                    updatedTopics.append(topicItem)
                }
                return updatedTopics
            } catch {
                throw error
            }
        }
    }
    
    func addComment(_ req: Request) throws -> Future<[Comment]> {
        return try req.content.decode(Comment.self).map(to: [Comment].self) { comment in
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("topics", withType: Topic.self)
            let topicId = try req.parameters.next(String.self)
            let query: Document = ["id": BSON(stringLiteral: topicId)]
            let newComment: BSON = [
                "id": BSON(stringLiteral: comment.id),
                "author": BSON(stringLiteral: comment.author),
                "text": BSON(stringLiteral: comment.text),
                "dateString": BSON(stringLiteral: comment.dateString),
                "likes": BSON(comment.likes),
                "dislikes": BSON(comment.dislikes)
            ]
            let updateQuery: Document = [ "$push": [
                "comments": newComment
                ]]
            do {
                try collection.updateOne(filter: query, update: updateQuery)
                var updatedComments = [Comment]()
                let cursor = try collection.find()
                for document in cursor {
                    for comment in document.comments {
                        updatedComments.append(comment)
                    }
                }
                return updatedComments
            } catch {
                throw error
            }
        }
    }
    
    func addLike(_ req: Request) throws -> Future<[Comment]> {
        return try req.content.decode(Comment.self).map(to: [Comment].self) { comment in
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("topics", withType: Topic.self)
            let topicId = try! req.parameters.next(String.self)
            let query: Document = ["id": BSON(stringLiteral: topicId), "comments.id": BSON(stringLiteral:comment.id)]
            let updateQuery: Document = ["$inc":[
                "comments.$.likes": BSON(1)
                ]]
            do {
                try collection.updateOne(filter: query, update: updateQuery)
                var newComments = [Comment]()
                let cursor = try collection.find(query)
                for document in cursor {
                    for comment in document.comments {
                        newComments.append(comment)
                    }
                }
                return newComments
                
            } catch {
                throw error
            }
        }
    }
    
    func addDislike(_ req: Request) throws -> Future<[Comment]> {
         return try req.content.decode(Comment.self).map(to: [Comment].self) { comment in
                   let client = try! req.make(MongoClient.self)
                   let collection = client.db("healthyworld").collection("topics", withType: Topic.self)
                   let topicId = try! req.parameters.next(String.self)
                   let query: Document = ["id": BSON(stringLiteral: topicId), "comments.id": BSON(stringLiteral:comment.id)]
                   let updateQuery: Document = ["$inc":[
                       "comments.$.dislikes": BSON(1)
                       ]]
                   do {
                       try collection.updateOne(filter: query, update: updateQuery)
                       var newComments = [Comment]()
                       let cursor = try collection.find(query)
                       for document in cursor {
                           for comment in document.comments {
                               newComments.append(comment)
                           }
                       }
                       return newComments
                       
                   } catch {
                       throw error
            }
        }
    }
}
