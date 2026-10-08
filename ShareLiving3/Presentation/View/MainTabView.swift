//
//  MainTabView.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//
// Controls navigation between the home page and main household features, also passes shared view models and housemate data to the screens if needed.
import SwiftUI

struct MainTabView: View {

    @ObservedObject var expenseViewModel: EViewModel
    @ObservedObject var choreViewModel: ChoreViewModel
    
    let housemates = [
        Housemate(id: UUID(), name: "Yang"),
        Housemate(id: UUID(), name: "Jason"),
        Housemate(id: UUID(), name: "Phoebe"),
        Housemate(id: UUID(), name: "Crystal"),
        Housemate(id: UUID(), name: "Damian"),
        Housemate(id: UUID(), name: "Luna")
    ]

    @State private var showHomePage = true
    @State private var selectedTab = 0

    var body: some View {
        if showHomePage {
            HomePageView(
                openExpenses: {
                    selectedTab = 0
                    showHomePage = false
                },
                openChores: {
                    selectedTab = 1
                    showHomePage = false
                },
                openGrocery: {
                    selectedTab = 2
                    showHomePage = false
                },
                openHousemates: {
                    selectedTab = 3
                    showHomePage = false
                },
            )
        } else {
            TabView(selection: $selectedTab) {

                ExpensesView(
                    onHome: goHome,
                    expenseViewModel: expenseViewModel,
                    housemates: housemates
                )
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Expenses")
                }
                .tag(0)

                ChoresView(
                    onHome: goHome,
                    housemates: housemates,
                    choreViewModel: choreViewModel
                )
                .tabItem {
                    Image(systemName: "checkmark.square")
                    Text("Chores")
                }
                .tag(1)

                GroceryView(
                    onHome: goHome
                )
                .tabItem {
                    Image(systemName: "cart")
                    Text("Grocery")
                }
                .tag(2)

                HousematesView(
                    onHome: goHome
                )
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Housemates")
                }
                .tag(3)
            }
        }
    }

    private func goHome() {
        showHomePage = true
    }
}

#Preview {

    let expenseRepo = InMemorySERepository()
    let expenseUseCase = RecordUseCases(
        repository: expenseRepo
    )
    let settlementPlanUseCase = SettlementPlanUseCase(
        repository: expenseRepo
    )

    let choreRepo = InMemoryChoreRepo()
    let assignUseCase = AHCUseCase(
        repository: choreRepo
    )
    let completeUseCase = CompleteChoreUseCase(
        repository: choreRepo
    )
    let dueChoresUseCase = DueChoresUseCase(
        repository: choreRepo
    )
    MainTabView(
        expenseViewModel: EViewModel(
            recordUseCase: expenseUseCase,
            settlementPlanUseCase: settlementPlanUseCase
        ),
        choreViewModel: ChoreViewModel(
            assignUseCase: assignUseCase,
            completeUseCase: completeUseCase,
            dueChoresUseCase: dueChoresUseCase
        )
    )
}
