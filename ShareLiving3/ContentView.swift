import SwiftUI

struct ContentView: View {

    
    @StateObject private var expenseViewModel: EViewModel
    @StateObject private var choreViewModel: ChoreViewModel

    init(){
        let expenseRepo = CoreDataExpenseRepository()

        let expenseUseCase = RecordUseCases(
            repository: expenseRepo
        )
        let choreRepo = CoreDataChoreRepository()

        let assignChoreUseCase = AHCUseCase(
            repository: choreRepo
        )
        let completeChoreUseCase = CompleteChoreUseCase(
            repository: choreRepo
        )

        _expenseViewModel = StateObject(
            wrappedValue: EViewModel(
                recordUseCase: expenseUseCase
            )
        )
        _choreViewModel = StateObject(
            wrappedValue: ChoreViewModel(
                assignUseCase: assignChoreUseCase,
                completeUseCase: completeChoreUseCase
            )
        )
    }

    var body: some View {
        MainTabView(
            expenseViewModel: expenseViewModel,
            choreViewModel: choreViewModel
        )
    }
}

#Preview {
    ContentView()
}
