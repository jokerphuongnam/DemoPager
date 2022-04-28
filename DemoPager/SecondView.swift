//
//  SecondView.swift
//  DemoPager
//
//  Created by gannha on 20/04/2022.
//

import SwiftUI

struct SecondView: View {
    @State private var currentIndex: Int = 0
    @State private var users: [UserPage] = []
    var body: some View {
        VStack() {
            CarouselView(index: $currentIndex, items: users) { page in
                switch page {
                case .item(let user):
                    Text(user.userName)
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                case .edge:
                    Color.gray
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                }
            }
            .padding(.vertical,40)
            
            // Indicator dots
            HStack(spacing: 10){
                
                ForEach(users.indices,id: \.self){index in
                    
                    Circle()
                        .fill(Color.black.opacity(currentIndex == index ? 1 : 0.1))
                        .frame(width: 10, height: 10)
                        .scaleEffect(currentIndex == index ? 1.4 : 1)
                        .animation(.spring(), value: currentIndex == index)
                }
            }
            .padding(.bottom,40)
        }
        .onAppear {
            for index in 1...5{
                users.append(.item(
                    User(id: "id \(index)", userName: "User\(index)", userImage: "user\(index)")))
            }
            users.addEdge()
        }
    }
}

enum UserPage: Identifiable {
    case edge
    case item(User)
    
    var id: String {
        switch self {
        case .edge:
            return UUID().uuidString
        case .item(let user):
            return user.id
        }
    }
}

extension Array where Element == UserPage {
    mutating func addEdge()  {
        var pages = self
        if !pages.isEmpty {
            for index in 0..<pages.count - 1 {
                if pages[index].id == "edge" {
                    pages.remove(at: index)
                }
            }
            pages.append(.edge)
            pages.insert(.edge, at: 0)
        }
        self = pages
    }
}

#if DEBUG
struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}
#endif
