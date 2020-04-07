import SwiftUI

struct RootTabBarView: View {
    @State var selectedView = 0
    
    var container: RootContainer!
    
    init(container: RootContainer) {
        self.container = container
    }
    var body: some View {
            TabView(selection: $selectedView) {
                FoodListView(container: container)
                    .tabItem {
                        Image(systemName: "cart")
                        Text("Market")
                }.tag(0)
                MealPlanView(container: container)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Meal plan")
                }
                .tag(1)
                ForumView(container: container)
                .tabItem {
                    Image(systemName: "text.bubble")
                    Text("Forum")
                }.tag(2)
                AccountView(container: container)
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }.tag(3)
                }.accentColor(.green)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct RootTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabBarView(container: RootContainer())
    }
}
