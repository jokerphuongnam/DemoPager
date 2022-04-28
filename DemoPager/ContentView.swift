//
//  ContentView.swift
//  DemoPager
//
//  Created by gannha on 19/04/2022.
//

import SwiftUI
import Drawer

struct User: Identifiable {
    var id: String
    var userName: String
    var userImage: String
}

extension User: Equatable { }

class ContentViewModel: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var users: [User] = []
    
    func getUser() {
        for index in 1...20 {
            users.append(
                User(
                    id: "id\(index)",
                    userName: "User\(index)",
                    userImage: "user\(index)"))
        }
    }
}

struct ContentView: View {
    @ObservedObject private var viewModel = ContentViewModel()
    @State private var isShow = false
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                MultiDirectionalPagination(
                    trailingSpace: 60,
                    index: $viewModel.currentIndex,
                    items: viewModel.users) { user in
                        Text(user.userName)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(20)
                    } edge: {
                        Color.gray
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(12)
                    }
                    .rest(at: .constant([0, size.height - 300, size.height - 200]))
                    .onChangeHeight { height in
                        print("Change", height)
                    }
                    .onRestHeight { height in
                        print("Rest" ,height)
                    }
                    .offset(y: -200)
                    .padding(.top, 40)
            }
        }
        .onAppear(perform: viewModel.getUser)
        .fullScreenCover(isPresented: $isShow, onDismiss: nil, content: SecondView.init)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
