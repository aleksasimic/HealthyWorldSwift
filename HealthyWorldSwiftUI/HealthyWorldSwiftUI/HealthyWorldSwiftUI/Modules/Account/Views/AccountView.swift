import SwiftUI

struct AccountView: View {
    @ObservedObject var accountViewModel: AccountViewModel
    var container: RootContainer!
    
    init(container: RootContainer) {
        self.container = container
        self.accountViewModel = AccountViewModel(service: self.container.accountNetworkService)
    }
    
    var body: some View {
        LoadingView(isShowing: $accountViewModel.loading) {
            NavigationView {
                VStack {
                    ImageViewContainer(imageURL: AccountViewModel.url)
                    Text("Hi, Aleksa")
                        .font(.titleLarge)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryColor)
                        .padding(.bottom, 10)
                    
                    VStack {
                        Text("My food")
                            .font(.titleSmall)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryColor)
                        if(self.accountViewModel.myFood.count == 0 ) {
                            Text("You haven't created any food yet")
                                .font(.titleSmall)
                                .fontWeight(.semibold)
                        } else {
                            List(self.accountViewModel.myFood) { food in
                                NavigationLink(destination: FoodDetailView(food: food, container: self.container)) {
                                    FoodListRow(food: food)
                                }.background(LinearGradient(gradient:
                                    Gradient(colors: [.secondaryColor, .secondaryColor]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(15)
                                
                            }
                        }
                        
                    }
                    VStack {
                        Text("Favourite food")
                            .font(.titleSmall)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryColor)
                        if self.accountViewModel.favFood.count == 0 {
                            Text("You havent added any food to favourites yet")
                                .font(.titleSmall)
                                .fontWeight(.semibold)
                        } else {
                            VStack {
                                List(self.accountViewModel.favFood) { food in
                                    
                                    HStack {
                                        ImageViewContainer(imageURL: food.img)
                                        VStack {
                                            Text(food.name)
                                                .font(.titleSmall)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primaryColor)
                                            VStack (alignment: .leading) {
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
                                                Button(action: {
                                                    self.accountViewModel.removeFromFavourites(favFood: food)
                                                }) {
                                                    Text("Remove")
                                                        .font(.buttonFont).fontWeight(.bold)
                                                    
                                                }.buttonStyle(GradientBackgroundStyleDelete())
                                            }
                                        }
                                    }.background(LinearGradient(gradient:
                                        Gradient(colors: [.secondaryColor, .secondaryColor]), startPoint: .leading, endPoint: .trailing))
                                        .cornerRadius(15)
                                }
                            }
                        }
                        
                    }
                    
                    
                }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .navigationBarTitle("Account settings", displayMode: .inline)
                    .toast(isShowing: self.$accountViewModel.presentToastError, text: self.$accountViewModel.toastErrorText)
                    .onAppear {
                        self.accountViewModel.fetchData()
                }
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(container: RootContainer())
    }
}
