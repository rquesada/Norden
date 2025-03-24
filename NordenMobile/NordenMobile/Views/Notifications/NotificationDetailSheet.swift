//
//  NotificationDetailSheet.swift
//  NordenMobile
//
//  Created by Roy Quesada on 24/3/25.
//
import SwiftUI

struct NotificationDetailSheet: View {
    let notification: FlattenedNotification

    var body: some View {
        VStack(spacing: 0) {
            // Color line
            Rectangle()
                .fill(Color(hex: notification.color) ?? Color.gray)
                .frame(height: 6)
                .transition(.move(edge: .top))
                .animation(.easeInOut(duration: 1), value: notification.id)

            VStack(spacing: 16) {
                Text("Monthly Vacation Balance")
                    .font(.title2)
                    .foregroundColor(.purple)
                    .bold()
                
                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text(notification.fullName)
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Total available days:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(notification.availableDays)
                        .font(.title)
                        .bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

                Spacer()
            }
            .padding()
            .background(Color.white)
        }
        .cornerRadius(12)
        .presentationDetents([.medium, .large])
    }
}
