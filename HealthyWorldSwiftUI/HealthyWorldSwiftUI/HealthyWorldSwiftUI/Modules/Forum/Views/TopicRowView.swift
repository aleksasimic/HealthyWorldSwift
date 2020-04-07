import SwiftUI

struct TopicRowView: View {
    var topic: Topic
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(topic.name)
                .font(.titleLarge)
                .fontWeight(.bold)
                .foregroundColor(.primaryColor)
            VStack(alignment: .leading) {
            HStack {
                Text("Added by:")
                    .font(.titleSmall)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryColor)

                Text(topic.author)
                    .font(.titleSmall)
                    .fontWeight(.semibold)
            }
            HStack {
                Text("Posted on:")
                    .font(.titleSmall)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryColor)
                Text(topic.dateString)
                                   .font(.titleSmall)
                                   .fontWeight(.semibold)
            }
            }.padding()
        }.background(LinearGradient(gradient:
            Gradient(colors: [.secondaryColor, .secondaryColor]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(15)
        .padding()
    }
}

struct TopicRowView_Previews: PreviewProvider {
    static var previews: some View {
        TopicRowView(topic: Topic(name: "Moj topic", author: "Aleksa Simic", dateString: "13 01 1996", comments: [], description: "Opis"))
    }
}
