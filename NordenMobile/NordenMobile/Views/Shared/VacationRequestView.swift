//
//  VacationRequestView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

//
//  VacationRequestView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct VacationRequestView: View {
    @StateObject private var viewModel: VacationRequestViewModel
    @Binding var isPresented: Bool
    @State private var showSuccessModal = false

    init(teamId: String, collaboradorId: String, isPresented: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: VacationRequestViewModel(teamId: teamId,
                                                                        collaboratorId: collaboradorId))
        self._isPresented = isPresented
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
                        viewModel.checkForVacationConflicts()
                    }),
                    displayedComponents: .date
                )
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal)

                DatePicker("End Date", selection: Binding(
                    get: { viewModel.endDate.toDate() ?? Date() },
                    set: { newDate in
                        viewModel.endDate = newDate.toString()
                        viewModel.checkForVacationConflicts()
                    }),
                    displayedComponents: .date
                )
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal)
            }

            // 🔹 Campo para razón de vacaciones
            TextField("Reason (Optional)", text: $viewModel.reason)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

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
                viewModel.submitVacationRequest()
            }) {
                Text(viewModel.isSubmitting ? "Submitting..." : "Submit Request")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isSubmitting ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .bold()
            }
            .disabled(viewModel.isSubmitting)
            .padding(.horizontal)

            // 🔹 Mostrar errores si hay
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()
        }
        .padding()
        .onChange(of: viewModel.requestSuccess) { success in
            if success {
                //isPresented = false
                showSuccessModal = true
            }
        }
        .alert("Success", isPresented: $showSuccessModal){
            Button("OK"){
                isPresented = false
            }
        } message: {
            Text("Vacation requested submitted successfully!")
        }
    }
}
