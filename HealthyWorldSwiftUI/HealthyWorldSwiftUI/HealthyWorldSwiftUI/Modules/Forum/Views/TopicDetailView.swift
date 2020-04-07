import Foundation
import SwiftUI
import Combine

struct TopicDetailView: View {
    @ObservedObject var topicDetailViewModel: TopicDetailViewModel
    
    var topic: Topic
    var container: RootContainer!
    
    init(container: RootContainer, topic: Topic) {
        self.container = container
        self.topic = topic
        self.topicDetailViewModel = TopicDetailViewModel(service: self.container.forumNetworkService, comments: self.topic.comments)
    }
    var body: some View {
        LoadingView(isShowing: self.$topicDetailViewModel.loading){
            NavigationView {
                VStack {
                    VStack {
                        Text(self.topic.name)
                            .font(.titleLarge)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryColor)
                        HStack {
                            Text("Added by:")
                                .font(.titleSmall)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryColor)
                            
                            Text(self.topic.author)
                                .font(.titleSmall)
                                .fontWeight(.semibold)
                        }
                        HStack {
                            Text("Posted on:")
                                .font(.titleSmall)
                                .fontWeight(.semibold)
                                .foregroundColor(.primaryColor)
                            Text(self.topic.dateString)
                                .font(.titleSmall)
                                .fontWeight(.semibold)
                        }
                    }.background(LinearGradient(gradient:
                        Gradient(colors: [.secondaryColor, .secondaryColor]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                        .padding()
                    List(self.topicDetailViewModel.comments) { comment in
                        VStack {
                            Text(comment.text)
                                .font(.titleSmall)
                                .fontWeight(.semibold)
                            HStack {
                                Text("Added by: ")
                                    .foregroundColor(.primaryColor)
                                    .fontWeight(.semibold)
                                Text(comment.author)
                                Text("On:")
                                    .foregroundColor(.primaryColor)
                                    .fontWeight(.semibold)
                                Text(comment.dateString)
                            }
                            HStack {
                                VStack {
                                    HStack {
                                        Text("Likes")
                                            .foregroundColor(.primaryColor)
                                            .fontWeight(.semibold)
                                        Text("\(comment.likes)")
                                    }
                                    
                                    Button(action: {
                                        self.topicDetailViewModel.addLike(comment, self.topic.id)
                                    }) {
                                        Text("Like")
                                            .font(.buttonFont)
                                            .fontWeight(.bold)
                                    }.buttonStyle(GradientBackgroundStyle())
                                }
                                VStack {
                                    HStack {
                                        Text("Dislikes")
                                            .foregroundColor(.primaryColor)
                                            .fontWeight(.semibold)
                                        Text("\(comment.dislikes)")
                                    }
                                    Button(action: {
                                        self.topicDetailViewModel.addDisLike(comment, self.topic.id)
                                    }) {
                                        Text("Dislike")
                                            .font(.buttonFont)
                                            .fontWeight(.bold)
                                        
                                    }.buttonStyle(GradientBackgroundStyleDelete())
                                }
                                
                            }.padding()
                        } .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.primaryColor, lineWidth: 3)
                        )
                    }
                    Spacer()
                    VStack {
                        TextField("Enter your comment", text: self.$topicDetailViewModel.commentText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                        Button(action: {
                            self.topicDetailViewModel.addComment(self.topic.id)
                        }) {
                            Text("Add your comment")
                                .font(.buttonFont).fontWeight(.bold)
                            
                        }.buttonStyle(GradientBackgroundStyle())
                    }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                }.navigationBarTitle("Topic details", displayMode: .inline)
            }
        }
    }
}

struct TopicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TopicDetailView(container: RootContainer(), topic: Topic(name: "Name", author: "Author", dateString: "Date", comments: [], description: "Description"))
    }
}
