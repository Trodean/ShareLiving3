//
//  InMemoryChoreRepo.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
// no using now only for testing
// add new func on 8/10/2026

import Foundation

final class InMemoryChoreRepo: ChoreRepo {

    private var chores: [Chore] = []

    func addChore(_ chore: Chore) {
        chores.append(chore)
    }

    func updateChore(_ chore: Chore) {
        guard let index = chores.firstIndex(where: {
            $0.id == chore.id
        }) else {
            return
        }

        chores[index] = chore
    }

    func getAllChores() -> [Chore] {
        chores
    }
    
    func getIncompleteChores(dueBy date: Date) -> [Chore] {
        chores
            .filter { chore in
                chore.isCompleted == false &&
                chore.dueDate <= date
            }
            .sorted {
                $0.dueDate < $1.dueDate
            }
    }
}
