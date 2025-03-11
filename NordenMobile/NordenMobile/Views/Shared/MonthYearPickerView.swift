//
//  MonthYearPickerView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct MonthYearPickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("Select Month & Year")
                .font(.headline)
                .padding()

            MonthYearDatePicker(selectedDate: $selectedDate) // 🔹 Picker Compacto

            // 🔹 Botón para confirmar selección
            Button("Done") {
                isPresented = false
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.horizontal)
        }
        .padding()
    }
}

// 🔹 `UIViewRepresentable` para usar `UIDatePicker`
struct MonthYearDatePicker: UIViewRepresentable {
    @Binding var selectedDate: Date

    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date // Usa `date`, pero luego ocultamos los días
        datePicker.preferredDatePickerStyle = .wheels // Estilo nativo de iOS
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
        return datePicker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = selectedDate
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: MonthYearDatePicker

        init(_ parent: MonthYearDatePicker) {
            self.parent = parent
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            parent.selectedDate = sender.date
        }
    }
}

