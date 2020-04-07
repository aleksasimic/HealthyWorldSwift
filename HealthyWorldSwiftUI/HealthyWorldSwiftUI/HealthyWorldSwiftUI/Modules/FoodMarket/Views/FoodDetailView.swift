import SwiftUI

struct FoodDetailView: View {
    @ObservedObject var foodDetailViewModel: FoodDetailViewModel
    @State private var selectedCurrency = 0
    @State var reviewsClicked: Int? = nil
    
    var food: Food
    var container: RootContainer!
    var currencies = ["RSD","Euro", "USD"]
    
    init(food: Food, container: RootContainer) {
        self.food = food
        self.container = container
        self.foodDetailViewModel = FoodDetailViewModel(service: self.container.foodMarketNetworkService, description: food.description, latinName: food.latinName, kcals: food.kcals, fat: food.fat, protein: food.protein, price: food.price, place: food.place, owner: food.owner, id: food.id)
        
    }
    var body: some View {
        LoadingView(isShowing: self.$foodDetailViewModel.loading) {
            VStack {
                VStack {
                    if (self.foodDetailViewModel.empty) {
                        Text("Nothing to show")
                            .font(.titleSmall)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryColor)
                    } else if (self.foodDetailViewModel.isMyFood) {
                        Text(self.food.name)
                            .font(.titleLarge)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryColor)
                        ImageViewContainer(imageURL: self.food.img)
                        HStack {
                            Text("Latin name")
                                .font(.titleSmall)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryColor)
                            TextField(self.food.latinName, text: self.$foodDetailViewModel.latinName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        VStack(alignment: .leading) {
                            Text("Description")
                                .font(.titleSmall)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryColor)
                            
                            TextField(self.food.description, text: self.$foodDetailViewModel.description)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        HStack {
                            VStack {
                                Text("Kcals")
                                    .font(.titleSmall)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryColor)
                                
                                TextField("\(self.food.kcals)", value: self.$foodDetailViewModel.kcals, formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                            }
                            VStack {
                                Text("Protein")
                                    .font(.titleSmall)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryColor)
                                
                                TextField("\(self.food.protein)", value: self.$foodDetailViewModel.protein, formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                            }
                            VStack {
                                Text("Fat")
                                    .font(.titleSmall)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryColor)
                                
                                TextField("\(self.food.fat)", value: self.$foodDetailViewModel.fat, formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Place")
                                    .font(.titleSmall)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryColor)
                                TextField(self.food.place, text: self.$foodDetailViewModel.place)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            HStack {
                                Text("Price")
                                    .font(.titleSmall)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryColor)
                                
                                TextField("\(self.food.price)", value: self.$foodDetailViewModel.price, formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            Picker(selection: self.$selectedCurrency, label: Text("Currency")) {
                                ForEach(0 ..< self.currencies.count) {
                                    Text(self.currencies[$0]).foregroundColor(.primaryColor)
                                    
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                            HStack {
                                Button(action: {
                                    let code = self.currencies[self.selectedCurrency]
                                    self.foodDetailViewModel.editFood(currencyCode: code)
                                }) {
                                    Text("Edit")
                                        .font(.buttonFont).fontWeight(.bold)
                                    
                                }.buttonStyle(GradientBackgroundStyle())
                                Button(action: {
                                    self.foodDetailViewModel.deleteFood(self.food.id)
                                }) {
                                    Text("Delete")
                                        .font(.buttonFont).fontWeight(.bold)
                                    
                                }.buttonStyle(GradientBackgroundStyleDelete())
                            }
                        }
                        Spacer()
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
                            VStack(alignment: .center, spacing: 10) {
                                Text(self.food.name)
                                    .font(.titleLarge)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryColor)
                                Text(self.food.latinName)
                                    .font(.titleSmall)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryColor)
                                ImageViewContainer(imageURL: self.food.img)
                                Text(self.food.description)
                                    .font(.titleSmall)
                                    .fontWeight(.semibold)
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Spacer()
                                    }
                                    HStack {
                                        Text("Kcals:")
                                            .font(.titleSmall)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primaryColor)
                                        
                                        Text("\(self.food.kcals)")
                                            .font(.titleSmall)
                                            .fontWeight(.semibold)
                                        
                                    }
                                    HStack {
                                        Text("Protein:")
                                            .font(.titleSmall)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primaryColor)
                                        
                                        Text("\(self.food.protein)")
                                            .font(.titleSmall)
                                            .fontWeight(.semibold)
                                        
                                    }
                                    HStack {
                                        Text("Fat:")
                                            .font(.titleSmall)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primaryColor)
                                        
                                        Text("\(self.food.fat)")
                                            .font(.titleSmall)
                                            .fontWeight(.semibold)
                                        
                                        
                                    }
                                    HStack {
                                        Text("Place:")
                                            .font(.titleSmall)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primaryColor)
                                        Text(self.food.place)
                                            .font(.titleSmall)
                                            .fontWeight(.semibold)
                                    }
                                    
                                    HStack {
                                        Text("Price:")
                                            .font(.titleSmall)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primaryColor)
                                        Text("\(self.food.price) \(self.currencies[self.selectedCurrency])")
                                            .font(.titleSmall)
                                            .fontWeight(.semibold)
                                    }
                                    HStack {
                                        Text("Contact owner:")
                                            .font(.titleSmall)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primaryColor)
                                        Text(self.food.phoneNumber)
                                            .fontWeight(.semibold)
                                    }
                                }
                            }.padding(.leading,15)
                                .padding(.trailing, 30)
                                .background(LinearGradient(gradient:
                                    Gradient(colors: [.secondaryColor, .secondaryColor]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(15)
                            VStack(alignment: .leading) {
                                HStack {
                                    
                                    NavigationLink(destination: FoodReviewsView(container: self.container, reviews: self.food.reviews, foodId: self.food.id), tag: 1, selection: self.$reviewsClicked) {
                                        Button(action: {
                                            self.reviewsClicked = 1
                                        }) {
                                            Text("Reviews")
                                                .font(.buttonFont)
                                                .fontWeight(.bold)
                                        }
                                        .buttonStyle(GradientBackgroundStyle())
                                    }
                                    Button(action: {
                                        self.foodDetailViewModel.addToFavourites(self.food)
                                    }) {
                                        Text("Add to favourites")
                                            .font(.buttonFont).fontWeight(.bold)
                                        
                                    }.buttonStyle(GradientBackgroundStyle())
                                    
                                }
                            }
                        }
                        Spacer()
                    }
                    
                }.onAppear{
                    for i in 0...self.currencies.count-1 {
                        if self.food.currency.code == self.currencies[i] {
                            self.selectedCurrency = i
                        }
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }.navigationBarTitle("Food details", displayMode: .inline)
                .toast(isShowing: self.$foodDetailViewModel.presentToast, text: self.$foodDetailViewModel.toastText)
        }
    }
}

struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailView(food: Food(name: "Test name", latinName: "Latin name", description: "Description", price: 120, protein: 10, fat: 15, kcals: 20, img: "url", currency: Currency(code: "EUR", name: "EUR", symbol: "symbol"), tags: [], category: "Fruits", reviews: [], owner: "owner name", place: "Nis", phoneNumber: "phone"), container: RootContainer())
    }
}
