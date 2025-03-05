//
//  MyVacationsView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//


import SwiftUI

struct MyVacationsView: View {
    @State private var showVacationRequest = false // Controla la pantalla de solicitud
    @State private var selectedDate = Date() // Fecha seleccionada en el calendario
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                // 🔹 Header
                VStack {
                    Text("Vacations")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Account: Mind Group")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("John Doe")
                        .font(.headline)
                }
                
                Button(action: {
                    showVacationRequest.toggle()
                }) {
                    Text("Request Vacation")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .bold()
                }
                .padding(.horizontal)
                
                // 🔹 Lista de Requests de Vacaciones
                //VacationRequestsView()
                
                // 🔹 Calendario
                CalendarView()
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $showVacationRequest) {
                VacationRequestView()
            }
        }
    }
}

#Preview {
    MyVacationsView()
}
