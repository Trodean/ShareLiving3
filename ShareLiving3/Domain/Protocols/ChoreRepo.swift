//
//  ChoreRepo.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//

import Foundation
// Defines the data operations for household chores.
protocol ChoreRepo {
    func addChore(_ chore: Chore)
    func updateChore(_ chore: Chore)
    func getAllChores() -> [Chore]
}
