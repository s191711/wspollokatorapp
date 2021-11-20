//
//  ConversationView.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct ConversationView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    let scrollViewPadding: CGFloat = 15
    
    var conversation: Conversation
    
    @State private var text: String = ""
    //    @State private var value: CGFloat = 0
    
    private var title: String {
        let participants = conversation.participants.filter { $0 != viewModel.currentUser! }
        
        if participants.count == 1 {
            let user = participants.first!
            return "\(user.name) \(user.surname)"
        } else {
            return participants.map({ $0.name }).joined(separator: ", ")
        }
    }
    
    private var sortedMessages: [Message] {
        conversation.messages.sorted(by: { $0.timeSent < $1.timeSent })
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { reader in
                ScrollView {
                    Spacer()
                        .frame(height: scrollViewPadding)
                    
                    ForEach(sortedMessages) { message in
                        ChatRow(message: message, isGroupConversation: conversation.participants.count > 2)
                    }
                    
                    Spacer()
                        .frame(height: scrollViewPadding)
                        .id("bottom")
                }
                .onAppear {
                    withAnimation {
                        reader.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
            
            TextField("Wpisz wiadomość", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            //                MultiTextField()
            //                    .frame(height: self.obj.size < 150 ? self.obj.size : 150)
            //                    .padding(.horizontal, 10)
            //                    .background(Color(UIColor.lightGray))
            //                    .cornerRadius(10)
            //                    .padding(.horizontal,  15)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        
        //Xcode 12 automatic keyboard handling
        //                .onAppear {
        //                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
        //
        //                        let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        //                        let height = value.height
        //
        //                        self.value = height
        //                    }
        //
        //                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
        //                        self.value = 0
        //                    }
        //                }
    }
}

struct Conversation_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(conversation: ViewModel.sampleConversations[0])
            .environmentObject(ViewModel.sample)
    }
}
