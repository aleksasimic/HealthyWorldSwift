import Vapor
import MongoSwift

public func routes(_ router: Router) throws {
    let authController = AuthorizationController()
    router.post("auth/signup", use: authController.signUp)
    router.post("auth/login", use: authController.logIn)
    
    let foodMarketController = FoodMarketController()
    router.post("market/search", use: foodMarketController.searchFood)
    router.post("market/add", use: foodMarketController.addFood)
    router.delete("market/delete",String.parameter, use: foodMarketController.delete)
    router.patch("market/update", use: foodMarketController.updateFood)
    router.patch("market/favourites", String.parameter, use: foodMarketController.addToFavourites)
    router.patch("market/reviews", String.parameter, use: foodMarketController.addReview)
    
    let accountController = AccountsController()
    router.get("account/myFood",String.parameter, use: accountController.getMyFood)
    router.get("account/favouriteFood", String.parameter, use: accountController.getFavouriteFood)
    router.patch("account/removeFavourite", String.parameter, use: accountController.removeFavouriteFood)
    
    let forumController = ForumContorller()
    router.get("forum", use: forumController.getTopics)
    router.post("forum/addTopic", use: forumController.addTopic)
    router.post("forum/addComment",String.parameter, use: forumController.addComment)
    router.patch("forum/like", String.parameter, use: forumController.addLike)
    router.patch("forum/dislike", String.parameter, use: forumController.addDislike)
}
