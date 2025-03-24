//
//  NotificationsView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 12/3/25.
//

import SwiftUI

struct NotificationsView: View {
    let notifications: [FlattenedNotification]
    let errorMessage: String?
    
    @State private var selectedNotification: FlattenedNotification?
    
    var body: some View {
        VStack{
            if let errorMessage = errorMessage{
                VStack{
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                        .padding()
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }
                .padding()
            } else if notifications.isEmpty {
                VStack{
                    Image(systemName: "bell.slash")
                        .foregroundColor(.gray)
                        .font(.largeTitle)
                        .padding()
                    Text("No notifications available.")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding()
            }else{
                List(notifications) { notification in
                    Button(action:{
                        selectedNotification = notification
                    }){
                        NotificationsItemView(notification: notification)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
            }
        }
        .padding(.horizontal)
        .sheet(item: $selectedNotification){ notification in
            NotificationDetailSheet(notification: notification)
        }
    }
}

struct NotificationsItemView: View {
    let notification: FlattenedNotification
    
    var body: some View{
        HStack{
            //Line
            Rectangle()
                .fill(Color(hex: notification.color) ?? Color.gray)
                   .frame(width: 2)
            //Text
            VStack(alignment: .leading, spacing: 4){
                Text(notification.fullName)
                    .font(.headline)
                Text(notification.title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("lightGrayBackground"))
        .cornerRadius(8)
        
    }
}

#Preview{
    let dummyData: [FlattenedNotification] = [
        FlattenedNotification(
            id: "1",
            title: "Vacation Request",
            color: "#ff0000",
            fullName: "Roy Quesada",
            startDate: "2025-08-01",
            endDate: "2025-08-05",
            availableDays: "10",
            expirationDate: "2025-12-31",
            numberDays: "5"
        )
    ]
    
    NotificationsView(notifications: dummyData, errorMessage: nil)
}
