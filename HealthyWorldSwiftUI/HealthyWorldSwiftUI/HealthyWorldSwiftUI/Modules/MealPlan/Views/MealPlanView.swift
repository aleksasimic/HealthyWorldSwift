import SwiftUI

struct MealPlanView: View {
    
    var container: RootContainer!
    
    init(container: RootContainer) {
        self.container = container
    }
    
    var body: some View {
        VStack {
            Text("ads")
        }
    }
}

struct MealPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanView(container: RootContainer())
    }
}
