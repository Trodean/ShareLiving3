//
//  CompleteChoreUseCase.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
// Finally this one handles the process of completing chore. It prevents a chore from being completed more than once and updates the stored chore state.

import Foundation

struct CompleteChoreUseCase {

    private let repository: any ChoreRepo

    init(repository: any ChoreRepo) {
        self.repository = repository
    }

    func execute(_ chore: Chore) throws -> Chore {
        guard !chore.isCompleted else {
            throw CompleteChoreError.alreadyCompleted
        }

        var completedChore = chore
        completedChore.isCompleted = true

        repository.updateChore(completedChore)

        return completedChore
    }
}
