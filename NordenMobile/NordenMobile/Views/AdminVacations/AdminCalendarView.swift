//
//  AdminCalendarView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 12/3/25.
//

import SwiftUI

struct AdminCalendarView: View {
    @ObservedObject var viewModel: AdminVacationsViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button(action: viewModel.goToPreviousMonth) {
                    Image(systemName: "chevron.left")
                        .padding()
                        .foregroundColor(Color("secondaryColor"))
                }

                Text("\(monthName(viewModel.currentMonth)) \(String(viewModel.currentYear))")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("primaryColor"))

                Button(action: viewModel.goToNextMonth) {
                    Image(systemName: "chevron.right")
                        .padding()
                        .foregroundColor(Color("secondaryColor"))
                }
            }
            .padding(.horizontal)
            
            //Calendar
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(CalendarUtils.daysInMonth(year: viewModel.currentYear, month: viewModel.currentMonth), id: \.self) { date in
                        DayEventRow(
                            date: date,
                            exceptions: viewModel.exceptionsFor(date: date),
                            vacations: viewModel.vacationsFor(date: date)
                        )
                    }

                }
                .padding(.horizontal)
            }
            
            

        }
    }

    private func monthName(_ month: Int) -> String {
        let formatter = DateFormatter()
        return formatter.monthSymbols[month - 1]
    }
}

