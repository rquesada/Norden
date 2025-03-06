//
//  VacationRequestView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct VacationRequestView: View {
    @StateObject private var viewModel: VacationRequestViewModel

    init(teamId: String) {
        _viewModel = StateObject(wrappedValue: VacationRequestViewModel(teamId: teamId))
    }

    var body: some View {
        VStack(spacing: 16) {
            
            Text("Request Vacation")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color("primaryColor"))

            // 🔹 Selección de fechas
            VStack {
                DatePicker("Start Date", selection: Binding(
                    get: { viewModel.startDate.toDate() ?? Date() },
                    set: { newDate in
                        viewModel.startDate = newDate.toString()
                        viewModel.checkForVacationConflicts() // 🔹 Llamar al endpoint cuando cambia la fecha
                    }),
                    displayedComponents: .date
                )
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal)

                DatePicker("End Date", selection: Binding(
                    get: { viewModel.endDate.toDate() ?? Date() },
                    set: { newDate in
                        viewModel.endDate = newDate.toString()
                        viewModel.checkForVacationConflicts() // 🔹 Llamar al endpoint cuando cambia la fecha
                    }),
                    displayedComponents: .date
                )
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal)
            }
            
            // 🔹 Mostrar mensajes de advertencia si existen
            if !viewModel.pendingMessages.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.pendingMessages, id: \.self) { message in
                        Text("⚠️ \(message)")
                            .font(.footnote)
                            .foregroundColor(.orange)
                            .padding()
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }

            // 🔹 Mostrar mensajes de conflicto si existen
            if !viewModel.conflictMessages.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.conflictMessages, id: \.self) { message in
                        Text("⚠️ \(message)")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.red.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }

            // 🔹 Botón de enviar solicitud
            Button(action: {
                print("Submitting vacation request...")
            }) {
                Text("Submit Request")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .bold()
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    VacationRequestView(teamId: "3ab681a9-e3b3-43dd-83c0-4194076ee38d")
}
