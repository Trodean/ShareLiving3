//
//  ChoreViewModel.swift
//  SharedLiving2
//
//  Created by Yang Peng on 16/9/2026.
//
// This connects the chore views with the core use cases, managing assigned chores, completed chores updates, and any related errors.

import Foundation
import Combine

final class ChoreViewModel: ObservableObject{

    @Published var chores: [Chore] = []
    @Published var errorMsg: String?
    private let assignUseCase: AHCUseCase
    private let completeUseCase: CompleteChoreUseCase

    init (
        assignUseCase: AHCUseCase,
        completeUseCase: CompleteChoreUseCase
    ) {
        self.assignUseCase = assignUseCase
        self.completeUseCase = completeUseCase
        self.chores = assignUseCase.getAllChores()
    }
    
    
    @discardableResult
    func assignChore(_ chore: Chore) -> Bool  {
        do{
            try assignUseCase.execute(chore)

            chores.append(chore)
            errorMsg = nil
            return true
        } catch{
            errorMsg = String(describing: error)

            return false
        }
    }

    
    @discardableResult
    func completeChore(_ chore: Chore) -> Bool{
        do {
            let completedChore = try completeUseCase.execute(chore)

            guard let index = chores.firstIndex(where: {
                $0.id == completedChore.id
            }) else {
                return false
            }

            chores[index] = completedChore
            errorMsg = nil

            return true
        } catch {
            errorMsg = String(describing: error)

            return false
        }
    }
}
