import SwiftUI

struct MyVacationsView: View {
    @StateObject private var viewModel = VacationsViewModel()
    @State private var showVacationRequests = false
    @State private var showRequestList: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                // 🔹 Header
                if let profile = viewModel.collaboratorProfile,
                   let accountName = viewModel.accountName
                {
                    VStack {
                        Text("Vacations")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color("primaryColor"))
                        
                        // 🔹 Account
                        HStack {
                            Text("Account: ")
                                .font(.headline)
                            Text(accountName)
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        
                        // 🔹 Name
                        HStack {
                            Text("Name: ")
                                .font(.headline)
                            Text(profile.fullName)
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        //Add button if user have vacation request
                        if !viewModel.vacationRequests.isEmpty {
                            Button(action: { showRequestList.toggle() }) {
                                HStack {
                                    Text("My Vacation Requests")
                                        .font(.headline)
                                        .foregroundColor(Color("primaryColor"))
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color("primaryColor"))
                                }
                                .padding(.horizontal)
                            }
                            .padding(.horizontal)
                        }
                        
                    }
                } else if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                }
                
                CalendarView(
                    selectedDate: $viewModel.selectedDate,
                    approvedVacations: viewModel.approvedVacations,
                    onYearChange: viewModel.updateYear,
                    onRequestVacation: { showVacationRequests.toggle()}
                )
                
                VacationListView(vacations: viewModel.approvedVacations, selectedDate: viewModel.selectedDate)
                
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $showVacationRequests){
                if let teamId = viewModel.teamId{
                    VacationRequestView(teamId: teamId)
                }else{
                    Text("Error: Team Id not found")
                }
                
            }
            .navigationDestination(isPresented: $showRequestList){
                RequestsListView(vacationRequests: viewModel.vacationRequests)
            }
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}

#Preview {
    MyVacationsView()
}
