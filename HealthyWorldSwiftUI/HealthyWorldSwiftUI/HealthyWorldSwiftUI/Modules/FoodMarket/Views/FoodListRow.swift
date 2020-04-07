import SwiftUI

struct FoodListRow: View {
    var food: Food
    var body: some View {
        HStack {
            ImageViewContainer(imageURL: food.img)
            VStack {
                Text(food.name)
                    .font(.titleSmall)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryColor)
                VStack(alignment: .leading) {
                HStack {
                    Text("Category:")
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryColor)
                    Text(food.category)
                        .fontWeight(.semibold)
                }
                HStack {
                    Text("Kcals:")
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryColor)
                    Text("\(food.kcals)")
                        .fontWeight(.semibold)
                }
                HStack {
                    Text("Price:")
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryColor)
                    Text("\(food.price) \(food.currency.code)")
                        .fontWeight(.semibold)
                }
            }
            }
        }
    }
}

struct FoodListRow_Previews: PreviewProvider {
    static var previews: some View {
        FoodListRow(food: Food(name: "Test name", latinName: "Latin name", description: "Description", price: 120, protein: 10, fat: 15, kcals: 20, img: "url", currency: Currency(code: "EUR", name: "E", symbol: "symbol"), tags: [], category: "Fruits", reviews: [], owner: "owner name", place: "Nis", phoneNumber: "Number"))
    }
}
