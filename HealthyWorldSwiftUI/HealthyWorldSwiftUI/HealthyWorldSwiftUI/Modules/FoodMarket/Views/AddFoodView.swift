import SwiftUI

struct AddFoodView: View {
    
    @ObservedObject private var addFoodViewModel: AddFoodViewModel
    @State private var selectedCategory = 0
    @State private var selectedCurrency = 0
    
    @State var price: Int = 0
    
    
    var container: RootContainer!
    var categories = ["Fruits", "Veggies", "Fish", "Eggs", "Diary"]
    var currencies = ["RSD","Euro", "USD"]
    
    init(container: RootContainer) {
        self.container = container
        self.addFoodViewModel = AddFoodViewModel(service: self.container.foodMarketNetworkService)
    }
    
    var body: some View {
        LoadingView(isShowing: $addFoodViewModel.loading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Name").foregroundColor(.primaryColor)
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                    TextField("", text: self.$addFoodViewModel.name)
                        .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Latin name").foregroundColor(.primaryColor)
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                    TextField("", text: self.$addFoodViewModel.latinName)
                        .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Description").foregroundColor(.primaryColor)
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                    TextField("", text: self.$addFoodViewModel.description)
                        .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker(selection: self.$selectedCategory, label: Text("Category")) {
                        ForEach(0 ..< self.categories.count) {
                            Text(self.categories[$0]).foregroundColor(.primaryColor)
                            
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Text("Image").foregroundColor(.primaryColor)
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                    TextField("", text: self.$addFoodViewModel.img)
                        .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                VStack(alignment: .leading, spacing: 10)  {
                    Text("Protein")
                        .foregroundColor(.primaryColor)
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                    TextField("", value: self.$addFoodViewModel.protein, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Fat")
                        .foregroundColor(.primaryColor)
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                    TextField("", value: self.$addFoodViewModel.fat, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Kcals")
                        .foregroundColor(.primaryColor)
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                    TextField("", value: self.$addFoodViewModel.kcals, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("City").foregroundColor(.primaryColor)
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                    TextField("", text: self.$addFoodViewModel.place).autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                }
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Price").foregroundColor(.primaryColor)
                        .font(.titleSmall)
                        .fontWeight(.semibold)
                    TextField("", value: self.$addFoodViewModel.price, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Picker(selection: self.$selectedCurrency, label: Text("Currency")) {
                        ForEach(0 ..< self.currencies.count) {
                            Text(self.currencies[$0]).foregroundColor(.primaryColor)
                            
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Button(action: {
                        let category = self.categories[self.selectedCategory]
                        let currency = self.currencies[self.selectedCurrency]
                        self.addFoodViewModel.addFood(category, currency)
                    }){
                        Text("Add")
                            .font(.buttonFont)
                            .fontWeight(.bold)
                    }.buttonStyle(GradientBackgroundStyle())
                }
            }
        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            .toast(isShowing: self.$addFoodViewModel.presentToast, text: self.$addFoodViewModel.toastText)
            .navigationBarTitle("Add food", displayMode: .inline)
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView(container: RootContainer())
    }
}
