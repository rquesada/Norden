//
//  VacationListView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct VacationListView: View {
    let vacations: [Vacation]
    let selectedDate: Date

    var body: some View {
        VStack(alignment: .leading) {
            if filteredVacations.isEmpty {
                Text("No approved vacations this month")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(filteredVacations) { vacation in
                    VacationListItem(vacation: vacation, selectedDate: selectedDate)
                        .padding(.horizontal)
                }
            }
        }
        .padding(.top, 8)
    }

    // 🔹 Filtrar vacaciones para el mes seleccionado
    private var filteredVacations: [Vacation] {
        let calendar = Calendar.current
        let selectedMonth = calendar.component(.month, from: selectedDate)
        let selectedYear = calendar.component(.year, from: selectedDate)

        return vacations.filter { vacation in
            vacation.years.contains(selectedYear) && vacation.months.contains(selectedMonth)
        }
    }
}
// 🔹 Cada item de la lista de vacaciones
struct VacationListItem: View {
    let vacation: Vacation
    let selectedDate: Date

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(vacation.fullName)
                    .font(.headline)
                    .foregroundColor(.black)

                Text("\(formattedDate(vacation.startDate)) - \(formattedDate(vacation.endDate))")
                    .font(.subheadline)
                    .foregroundColor(Color("textColor1"))
            }
            Spacer()
        }
        .padding()
        .background(Color("lightblueBackground"))
        .cornerRadius(8)
    }

    // 🔹 Formatear fechas
    private func formattedDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
        return dateString
    }
}
