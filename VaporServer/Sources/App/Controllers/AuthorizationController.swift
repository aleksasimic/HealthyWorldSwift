import Vapor
import MongoSwift

final class AuthorizationController {
    func signUp(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.content.decode(User.self).map(to: HTTPStatus.self) { user in
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("usersNew", withType: User.self)
            do {
                try collection.insertOne(user)
            } catch {
                return HTTPStatus.internalServerError
            }
            return HTTPStatus.ok
        }
    }
    
    func logIn(_ req: Request) throws -> Future<HTTPResponse> {
        return try req.content.decode(UserDTO.self).map(to: HTTPResponse.self) { userDTO in
            let client = try! req.make(MongoClient.self)
            let collection = client.db("healthyworld").collection("usersNew", withType: User.self)
            let cursor = try! collection.find()
            for document in cursor {
                if document.username == userDTO.username {
                    let body: [String: Any] = [
                        "username": userDTO.username as Any,
                        "phoneNumber": document.phoneNumber as Any
                    ]
                   let data = try! JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
                    return HTTPResponse(status: HTTPStatus.ok, body: data)
                }
            }
            return HTTPResponse(status: HTTPStatus.notFound)
        }
    }
}
