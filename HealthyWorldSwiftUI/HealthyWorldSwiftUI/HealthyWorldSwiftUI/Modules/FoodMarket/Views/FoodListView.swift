import SwiftUI

struct FoodListView: View {
    @ObservedObject private var foodMarketViewModel: FoodMarketViewModel
    @State private var selectedCategory = 0
    @State var addNewClicked: Int? = nil
    
    
    var container: RootContainer!
    var categories = ["All", "Fruits", "Veggies", "Fish", "Eggs", "Diary"]
    var currencies = ["All", "RSD","Euro", "USD"]
    
    
    init(container: RootContainer) {
        self.container = container
        self.foodMarketViewModel = FoodMarketViewModel(service: self.container.foodMarketNetworkService)
    }
    var body: some View {
        NavigationView{
            LoadingView(isShowing: $foodMarketViewModel.loading) {
                VStack(alignment: .center, spacing: 10) {
                    TextField("Type name of food", text: self.$foodMarketViewModel.name)
                        .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                    Picker(selection: self.$selectedCategory, label: Text("Category")) {
                        ForEach(0 ..< self.categories.count) {
                            Text(self.categories[$0]).foregroundColor(.primaryColor)
                            
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    
                    VStack {
                        HStack(alignment: .bottom) {
                            Text("Proteins")
                                .font(.titleSmall)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryColor)
                            VStack {
                                Text("Min")
                                    .font(.titleAttribute)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryColor)
                                TextField("Min", value: self.$foodMarketViewModel.minProtein, formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                                    .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            VStack {
                                Text("Max")
                                    .font(.titleAttribute)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryColor)
                                TextField("Max", value: self.$foodMarketViewModel.maxProtein, formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                                    .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        
                        HStack(alignment: .bottom) {
                            Text("Fat")
                                .font(.titleSmall)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryColor)
                            VStack {
                                Text("Min")
                                    .font(.titleAttribute)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryColor)
                                TextField("Min", value: self.$foodMarketViewModel.minFat, formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                                    .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            VStack {
                                Text("Max")
                                    .font(.titleAttribute)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryColor)
                                TextField("Max", value: self.$foodMarketViewModel.maxFat, formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                                    .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        HStack(alignment: .bottom) {
                            Text("Kcals")
                                .font(.titleSmall)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryColor)
                            VStack {
                                Text("Min")
                                    .font(.titleAttribute)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryColor)
                                TextField("Min", value: self.$foodMarketViewModel.minKcals, formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                                    .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            VStack {
                                Text("Max")
                                    .font(.titleAttribute)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryColor)
                                TextField("Max", value: self.$foodMarketViewModel.maxKcals, formatter: NumberFormatter())
                                    .keyboardType(.numberPad)
                                    .autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                    
                        }
                        HStack(alignment: .center, spacing: 0) {
                                                
                                                Button(action: {
                                                    let category = self.categories[self.selectedCategory]
                                                    self.foodMarketViewModel.search(category: category)
                                                }){
                                                    Text("Search")
                                                        .font(.buttonFont)
                                                        .fontWeight(.bold)
                                                }.buttonStyle(GradientBackgroundStyle())
                                                NavigationLink(destination: AddFoodView(container: self.container), tag: 1, selection: self.$addNewClicked) {
                                                    Button(action: {
                                                        self.addNewClicked = 1
                                                    }) {
                                                        Text("Add")
                                                            .font(.buttonFont)
                                                            .fontWeight(.bold)
                                                    }.buttonStyle(GradientBackgroundStyle())
                                                }
                                            }
                    }
                    
                    List(self.foodMarketViewModel.food) { food in
                        NavigationLink(destination: FoodDetailView(food: food, container: self.container)) {
                            FoodListRow(food: food)
                        }.background(LinearGradient(gradient:
                            Gradient(colors: [.secondaryColor, .secondaryColor]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                    }
                    
                    Spacer()
                        .navigationBarTitle("Market", displayMode: .inline)
                }
                .onAppear {
                    let category = self.categories[self.selectedCategory]
                    self.foodMarketViewModel.search(category: category)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }.toast(isShowing: self.$foodMarketViewModel.presentToastError, text: self.$foodMarketViewModel.toastErrorText)
        }
    }
}

struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView(container: RootContainer())
    }
}
