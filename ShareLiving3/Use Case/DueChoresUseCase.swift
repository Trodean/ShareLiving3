//
//  DueChoresUseCase.swift
//  ShareLiving3
//
//  Created by Yang Peng on 8/10/2026.
//

import Foundation

struct DueChoresUseCase{

    private let repository: ChoreRepo

    init(repository: ChoreRepo){
        self.repository = repository
    }
    func execute(for date: Date = Date()) -> [Chore] {

        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: date)
        let startOfTomorrow =
            calendar.date(
                byAdding: .day,
                value: 1,
                to: startOfToday
            ) ?? date
        let endOfToday =
            startOfTomorrow.addingTimeInterval(-1)

        return repository.getIncompleteChores(
            dueBy: endOfToday
        )
    }
}
