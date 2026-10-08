//
//  AssignChoreView.swift
//  SharedLiving3
//
//  Created by Yang Peng on 16/9/2026.
//
// Collects the information needed to assign a new household chore.
// Users can enter a chore name, choose a due date, and select the housemate responsible for the task.

import SwiftUI

struct AssignChoreView: View {

    @Environment(\.dismiss) private var dismiss
    

    let housemates: [Housemate]
    @ObservedObject var choreViewModel: ChoreViewModel
    
    @State private var title = ""
    @State private var selectedAssigneeID: UUID?
    @State private var dueDate = Date()

    var body: some View {
        Form {
            Section("Chore Details") {
                TextField("Chore name", text: $title)

                DatePicker(
                    "Due Date",
                    selection: $dueDate,
                    displayedComponents: .date
                )
            }

            Section("Assigned To") {
                Picker("Housemate", selection: $selectedAssigneeID) {
                    ForEach(housemates) { housemate in
                        Text(housemate.name)
                            .tag(Optional(housemate.id))
                    }
                }
            }
            Section {
                Button("Assign Chore") {
                    saveChore()
                }
            }
        }
        .alert(
            "Unable to Assign Chore",
            isPresented: Binding(
                get: {
                    choreViewModel.errorMsg != nil
                },
                set: { isPresented in
                    if !isPresented {
                        choreViewModel.errorMsg = nil
                    }
                }
            )
        ) {
            Button("OK", role: .cancel) {
                choreViewModel.errorMsg = nil
            }
        } message: {
            Text(choreViewModel.errorMsg ?? "")
        }
        .navigationTitle("Assign Chore")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if selectedAssigneeID == nil {
                selectedAssigneeID = housemates.first?.id
            }
        }
    }
    
    private func saveChore() {
        guard let assignee = housemates.first(where: {
            $0.id == selectedAssigneeID
        }) else {
            choreViewModel.errorMsg = "Please select a housemate."
            return
        }
        let chore = Chore(
            id: UUID(),
            title: title,
            assignee: assignee,
            dueDate: dueDate,
            isCompleted: false
        )

        let success = choreViewModel.assignChore(chore)

        if success{
            dismiss()
        }
    }
}
#Preview {
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
    let choreViewModel = ChoreViewModel(
        assignUseCase: assignUseCase,
        completeUseCase: completeUseCase,
        dueChoresUseCase: dueChoresUseCase
    )
    let housemates = [
        Housemate(
            id: UUID(),
            name: "Yang"
        ),
        Housemate(
            id: UUID(),
            name: "Alex"
        )
    ]
    AssignChoreView(
        housemates: housemates,
        choreViewModel: choreViewModel
    )
}
