//
//  NotificationsDetailView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 14/3/25.
//

import SwiftUI

struct NotificationDetailView: View {
    let notification: NotificationItem

    var body: some View {
        VStack(alignment: .leading) {
            Text(notification.title)
                .font(.largeTitle)
                .bold()
            
            Text(notification.subTitle)
                .font(.title2)
                .foregroundColor(.gray)

            List(notification.details) { detail in
                VStack(alignment: .leading) {
                    Text(detail.fullName)
                        .font(.headline)
                    Text("Expiration: \(detail.expirationDate)")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
    }
}
