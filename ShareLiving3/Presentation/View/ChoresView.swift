//
//  ChoresView.swift
//  SharedLiving3
//
//  Created by Yang Peng on 16/9/2026.
//
// Displays household chores based on their due dates and completion status.
// What users can do: Switch between upcoming chores and all chores, assign new chores and complete existing ones.

import SwiftUI

struct ChoresView: View{

    let onHome: () -> Void
    let housemates: [Housemate]

    @ObservedObject var choreViewModel: ChoreViewModel
    @State private var selectedFilter = 0
    @State private var showAddChore = false
    @State private var showError = false

    private var choresInSevenDays: [Chore] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let sevenDaysLater = calendar.date(
            byAdding: .day,
            value: 7,
            to: today
        ) ?? today
        
        return choreViewModel.chores
            .filter {
                $0.dueDate >= today &&
                $0.dueDate <= sevenDaysLater
            }
            .sorted {
                $0.dueDate < $1.dueDate
            }
    }

    //new: overdue chores come from DueChoresUseCase
    private var overdueChores: [Chore] {
        let today = Calendar.current.startOfDay(for: Date())

        return choreViewModel.dueChores.filter {
            $0.dueDate < today
        }
    }

    //new: unfinished chores due today
    private var dueTodayChores: [Chore] {
        choreViewModel.dueChores.filter {
            Calendar.current.isDateInToday($0.dueDate)
        }
    }

    private var todayChores: [Chore] {
        choresInSevenDays.filter {
            Calendar.current.isDateInToday($0.dueDate)
        }
    }

    private var upcomingChores: [Chore] {
        choresInSevenDays.filter {
            !Calendar.current.isDateInToday($0.dueDate)
        }
    }

    private var allChores: [Chore] {
        choreViewModel.chores.sorted {
            $0.dueDate < $1.dueDate
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {

                    Picker(
                        "Chore Filter",
                        selection: $selectedFilter
                    ) {
                        Text("In 7 Days").tag(0)
                        Text("All Chores").tag(1)
                    }
                    .pickerStyle(.segmented)

                    if selectedFilter == 0 {
                        sevenDayView
                    } else {
                        allChoresView
                    }

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
            .background(
                Color("AppBackground")
                    .ignoresSafeArea()
            )
            .navigationTitle("Chores")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        onHome()
                    } label: {
                        Image(systemName: "house.fill")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddChore = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddChore) {
            NavigationStack {
                AssignChoreView(
                    housemates: housemates,
                    choreViewModel: choreViewModel
                )
            }
        }
        .alert(
            "Unable to Complete Chore",
            isPresented: $showError
        ) {
            Button("OK", role: .cancel) {
                choreViewModel.errorMsg = nil
            }
        } message: {
            Text(choreViewModel.errorMsg ?? "")
        }
    }

    private var sevenDayView: some View {
        VStack(alignment: .leading, spacing: 22) {

            dueChoresSummary

            if !overdueChores.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Overdue")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Spacer()

                        Text("DUE")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }

                    choreList(overdueChores)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Today")
                    .font(.title2)
                    .fontWeight(.semibold)

                if todayChores.isEmpty {
                    emptyMessage("No chores for today.")
                } else {
                    choreList(todayChores)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Upcoming")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Spacer()

                    Text("DUE")
                        .font(.caption)
                        .fontWeight(.semibold)
                }

                if upcomingChores.isEmpty {
                    emptyMessage("No upcoming chores.")
                } else {
                    choreList(upcomingChores)
                }
            }
        }
    }

    //New: Due Chores summary
    private var dueChoresSummary: some View {

        HStack(spacing: 14) {

            Image(
                systemName: choreViewModel.dueChores.isEmpty
                    ? "checkmark.circle.fill"
                    : "exclamationmark.circle.fill"
            )
            .font(.title2)
            .foregroundStyle(dueSummaryColor)
            .padding(12)
            .background(
                Circle()
                    .fill(
                        dueSummaryColor.opacity(0.12)
                    )
            )

            VStack(alignment: .leading, spacing: 4) {

                Text("Due Chores")
                    .font(.headline)

                Text(dueChoresSummaryText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if !choreViewModel.dueChores.isEmpty {

                Text("\(choreViewModel.dueChores.count)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(dueSummaryColor)
            }
        }
        .padding(16)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
            .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
            .stroke(
                Color.black.opacity(0.04),
                lineWidth: 1
            )
        )
    }
    private var dueChoresSummaryText: String {

        let overdueCount = overdueChores.count
        let todayCount = dueTodayChores.count

        if overdueCount == 0 && todayCount == 0 {
            return "You're all caught up."
        }
        if overdueCount == 0 {
            return "\(todayCount) due today"
        }
        if todayCount == 0 {
            return "\(overdueCount) overdue"
        }
        return "\(overdueCount) overdue · \(todayCount) due today"
    }
    
    private var dueSummaryColor: Color {
        if !overdueChores.isEmpty {
            return .red
        }
        if !dueTodayChores.isEmpty {
            return .orange
        }
        return Color("SharedGreen")
    }
    
    private var allChoresView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Chores")
                .font(.title2)
                .fontWeight(.semibold)

            if allChores.isEmpty {
                emptyMessage("No chores assigned yet.")
            } else {
                choreList(allChores)
            }
        }
    }

    private func choreList(_ chores: [Chore]) -> some View {
        VStack(spacing: 0) {
            ForEach(
                Array(chores.enumerated()),
                id: \.element.id
            ) { index, chore in

                ChoreRowView(
                    title: chore.title,
                    assignee: chore.assignee.name,
                    status: statusText(for: chore),
                    isCompleted: chore.isCompleted,
                    onComplete: {
                        choreViewModel.completeChore(chore)
                    }
                )

                if index < chores.count - 1 {
                    Divider()
                }
            }
        }
        .background(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
            .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
            .stroke(
                Color.black.opacity(0.04),
                lineWidth: 1
            )
        )
    }
    private func emptyMessage(
        _ message: String
    ) -> some View {

        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle")
                .foregroundStyle(Color("SharedGreen"))
            Text(message)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .font(.subheadline)
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(
                cornerRadius: 16,
                style: .continuous
            )
            .fill(Color.white)
        )
    }

    private func statusText(for chore: Chore) -> String {
        if chore.isCompleted {
            return "DONE"
        }

        if Calendar.current.isDateInToday(chore.dueDate) {
            return "TODAY"
        }

        if chore.dueDate <
            Calendar.current.startOfDay(for: Date()) {
            return "OVERDUE"
        }

        return chore.dueDate.formatted(
            .dateTime
                .month(.abbreviated)
                .day()
        )
        .uppercased()
    }
}

struct ChoreRowView: View {

    let title: String
    let assignee: String
    let status: String
    let isCompleted: Bool
    let onComplete: () -> Void

    var body: some View {
        HStack(spacing: 14) {

            Button {
                onComplete()
            } label: {

                Image(
                    systemName: isCompleted
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(.title2)
                .foregroundStyle(
                    isCompleted
                        ? Color("SharedGreen")
                        : Color.secondary
                )
            }
            .buttonStyle(.plain)
            .disabled(isCompleted)

            VStack(
                alignment: .leading,
                spacing: 5
            ) {

                Text(title)
                    .font(.headline)
                    .strikethrough(isCompleted)
                    .foregroundStyle(
                        isCompleted
                            ? Color.secondary
                            : Color.primary
                    )
                Label(
                    assignee,
                    systemImage: "person.fill"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()
            Text(status)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(statusColor)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(
                            statusColor.opacity(0.12)
                        )
                )
        }
        .padding()
        .frame(minHeight: 72)
        .opacity(
            isCompleted ? 0.65 : 1
        )
    }

    private var statusColor: Color {

        if isCompleted {
            return Color("SharedGreen")
        }
        switch status {

        case "OVERDUE":
            return .red
        case "TODAY":
            return .orange
        default:
            return Color("SharedGreen")
        }
    }
}




#Preview{
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
    ChoresView(
        onHome: {},
        housemates: housemates,
        choreViewModel: choreViewModel
    )
}
