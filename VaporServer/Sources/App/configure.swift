import FluentSQLite
import Vapor
import MongoSwift

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    try services.register(FluentSQLiteProvider())

    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    var middlewares = MiddlewareConfig()

    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)

    let sqlite = try SQLiteDatabase(storage: .memory)

    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)
    
    let client = try MongoClient("mongodb://aleksa:aleksa13@ds213665.mlab.com:13665/healthyworld",options: ClientOptions(retryWrites: false))
    let db = client.db("healthyworld")
    do {
      _ = try db.createCollection("testUsers")
    } catch {
      _ = db.collection("testUsers")
    }
    services.register(client)
}

extension MongoClient: Service {}
