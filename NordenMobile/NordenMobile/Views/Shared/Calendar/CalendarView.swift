//
//  CalendarView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var showMonthPicker = false

    var body: some View {
        VStack {
            // 🔹 Header con Mes y Año
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .padding()
                }

                // 🔹 Tocar para abrir selector de Mes y Año
                Text(monthAndYear(currentMonth))
                    .font(.title2)
                    .bold()
                    .onTapGesture {
                        showMonthPicker.toggle()
                    }

                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .padding()
                }
            }

            // 🔹 Calendario (Aquí se muestran los días del mes correctamente)
            CalendarGridView(selectedDate: $selectedDate, currentMonth: $currentMonth)

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showMonthPicker) {
            MonthYearPickerView(selectedDate: $currentMonth, isPresented: $showMonthPicker)
        }
    }

    // 🔹 Formatear Mes y Año
    private func monthAndYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    // 🔹 Cambiar de Mes
    private func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
    }

    private func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
    }
}


