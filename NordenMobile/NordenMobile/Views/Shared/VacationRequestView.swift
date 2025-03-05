//
//  VacationRequestView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct VacationRequestView: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Request Vacation")
                .font(.title)
                .bold()
            
            // 🔹 Date Picker Start Date
            VStack(alignment: .leading) {
                Text("Start Date")
                    .font(.subheadline)
                    .bold()
                DatePicker("Select start date", selection: $startDate, displayedComponents: [.date])
                    .datePickerStyle(.compact)
            }
            
            // 🔹 Date Picker End Date
            VStack(alignment: .leading) {
                Text("End Date")
                    .font(.subheadline)
                    .bold()
                DatePicker("Select end date", selection: $endDate, displayedComponents: [.date])
                    .datePickerStyle(.compact)
            }
            
            // 🔹 Error Message
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
            }
            
            // 🔹 Submit Button
            Button(action: {
                submitRequest()
            }) {
                Text("Submit Request")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .bold()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding()
    }
    
    // Simulación de validación
    private func submitRequest() {
        if endDate < startDate {
            errorMessage = "End date cannot be before start date."
        } else {
            errorMessage = nil
            // Aquí se haría la llamada a la API para enviar la solicitud
        }
    }
}
