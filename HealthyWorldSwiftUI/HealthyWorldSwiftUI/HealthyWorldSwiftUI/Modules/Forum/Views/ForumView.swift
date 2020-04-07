import SwiftUI

struct ForumView: View {
    @ObservedObject var forumViewModel: ForumViewModel
    var container: RootContainer!
    
    init(container: RootContainer) {
        self.container = container
        self.forumViewModel = ForumViewModel(service: self.container.forumNetworkService)
    }
    
    var body: some View {
        NavigationView {
        LoadingView(isShowing: $forumViewModel.loading) {
            VStack {
                List(self.forumViewModel.topics) { topic in
                    NavigationLink(destination: TopicDetailView(container: self.container, topic: topic)) {
                        TopicRowView(topic: topic)
                    }.background(LinearGradient(gradient:
                        Gradient(colors: [.secondaryColor, .secondaryColor]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                    
                }
                Spacer()
                VStack{
                    TextField("Enter topic name", text: self.$forumViewModel.topicName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    TextField("Enter topic description", text: self.$forumViewModel.topicDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    Button(action: {
                        self.forumViewModel.addTopic()
                    }) {
                        Text("Add new topic")
                            .font(.buttonFont).fontWeight(.bold)
                        
                    }.buttonStyle(GradientBackgroundStyle())
                }
            }.onAppear{
                self.forumViewModel.getTopics()
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }.navigationBarTitle("Forum", displayMode: .inline)
            .toast(isShowing: self.$forumViewModel.showToast, text: self.$forumViewModel.toastText)
        }
    }
}

struct ForumView_Previews: PreviewProvider {
    static var previews: some View {
        ForumView(container: RootContainer())
    }
}
