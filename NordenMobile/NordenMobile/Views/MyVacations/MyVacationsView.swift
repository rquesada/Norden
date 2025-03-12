import SwiftUI

struct MyVacationsView: View {
    @StateObject private var viewModel = VacationsViewModel()
    @State private var showVacationRequests = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Vacations")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color("primaryColor"))

                if let profile = viewModel.collaboratorProfile,
                   let accountName = viewModel.accountName {
                    VStack {
                        HStack {
                            Text("Account: ")
                                .font(.headline)
                            Text(accountName)
                                .font(.headline)
                                .foregroundColor(.gray)
                        }

                        HStack {
                            Text("Name: ")
                                .font(.headline)
                            Text(profile.fullName)
                                .font(.headline)
                                .foregroundColor(.gray)
                        }

                        if !viewModel.vacationRequests.isEmpty {
                            NavigationLink(destination: RequestsListView(vacationRequests: viewModel.vacationRequests)) {
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

                ScrollView {
                    VStack {
                        CalendarView(
                            selectedDate: $viewModel.selectedDate,
                            approvedVacations: viewModel.approvedVacations,
                            onYearChange: viewModel.updateYear,
                            onRequestVacation: { showVacationRequests.toggle() }
                        )

                        VacationListView(vacations: viewModel.approvedVacations, selectedDate: viewModel.selectedDate)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $showVacationRequests) {
                if let teamId = viewModel.collaboratorProfile?.accountId,
                   let collaboratorId = viewModel.collaboratorProfile?.collaboratorId {
                    VacationRequestView(teamId: teamId, collaboradorId: collaboratorId, isPresented: $showVacationRequests)
                } else {
                    Text("Error: Team Id or collaboratorId not found")
                }
            }
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}

#Preview {
    MyVacationsView()
        .environmentObject(AuthViewModel())
}
