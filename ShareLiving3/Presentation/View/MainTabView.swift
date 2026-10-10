//
//  MainTabView.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//
// Controls navigation between the home page and main household features, also passes shared view models and housemate data to the screens if needed.

import SwiftUI
import WidgetKit

struct MainTabView: View {

    @ObservedObject var expenseViewModel: EViewModel
    @ObservedObject var choreViewModel: ChoreViewModel

    let housemates = [
        Housemate(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            name: "Yang"
        ),
        Housemate(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
            name: "Jason"
        ),
        Housemate(
            id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
            name: "Phoebe"
        ),
        Housemate(
            id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
            name: "Crystal"
        ),
        Housemate(
            id: UUID(uuidString: "55555555-5555-5555-5555-555555555555")!,
            name: "Damian"
        ),
        Housemate(
            id: UUID(uuidString: "66666666-6666-6666-6666-666666666666")!,
            name: "Luna"
        )
    ]
    
    @State private var showHomePage = true
    @State private var selectedTab = 0

    var body: some View {

        Group {

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
                        selectedTab = 3
                        showHomePage = false
                    },
                    openHousemates: {
                        selectedTab = 4
                        showHomePage = false
                    },
                    openBoard: {
                        selectedTab = 2
                        showHomePage = false
                    }
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

                    HouseholdBoardView()
                        .tabItem {
                            Image(systemName: "megaphone")
                            Text("Board")
                        }
                        .tag(2)

                    GroceryView(
                        onHome: goHome
                    )
                    .tabItem {
                        Image(systemName: "cart")
                        Text("Grocery")
                    }
                    .tag(3)

                    HousematesView(
                        onHome: goHome
                    )
                    .tabItem {
                        Image(systemName: "person.3")
                        Text("Housemates")
                    }
                    .tag(4)
                }
            }
        }
        .onAppear {
            updateWidgetData()
        }
        .onChange(of: choreViewModel.dueChores.count) { _, _ in
            updateWidgetData()
        }
        .onChange(of: expenseViewModel.settlementPlan.count) { _, _ in
            updateWidgetData()
        }
        .onOpenURL { url in

            guard url.scheme == "shareliving3" else {
                return
            }

            showHomePage = false

            switch url.host {

            case "expenses":
                selectedTab = 0

            case "chores":
                selectedTab = 1

            case "board":
                selectedTab = 2

            case "grocery":
                selectedTab = 3

            case "housemates":
                selectedTab = 4

            default:
                showHomePage = true
            }
        }
    }

    private func goHome() {
        showHomePage = true
    }

    private func updateWidgetData() {

        SharedWidgetData.save(
            dueChoreCount: choreViewModel.dueChores.count,
            repaymentCount: expenseViewModel.settlementPlan.count
        )

        WidgetCenter.shared.reloadAllTimelines()
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

    let settleMonthUseCase = SettleMonthUseCase(
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
            settlementPlanUseCase: settlementPlanUseCase,
            settleMonthUseCase: settleMonthUseCase
        ),
        choreViewModel: ChoreViewModel(
            assignUseCase: assignUseCase,
            completeUseCase: completeUseCase,
            dueChoresUseCase: dueChoresUseCase
        )
    )
}
