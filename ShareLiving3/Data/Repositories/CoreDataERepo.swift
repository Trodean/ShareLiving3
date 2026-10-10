//
//  CoreDataERepo.swift
//  ShareLiving3
//
//  Created by Yang Peng on 8/10/2026.
//

import Foundation
import CoreData

final class CoreDataExpenseRepository: SERepository {

    private let context: NSManagedObjectContext

    init(
        context: NSManagedObjectContext =
            PersistenceController.shared.container.viewContext
    ) {
        self.context = context
    }


    func addExpenses(_ expense: SharedExpenses) {

        let expenseEntity = SharedExpensesEntity(context: context)

        expenseEntity.id = expense.id
        expenseEntity.title = expense.title
        expenseEntity.amount = expense.amount
        expenseEntity.category = expense.category.rawValue
        expenseEntity.date = expense.date

        // Payer
        let payerEntity = fetchOrCreateHousemate(expense.payer)
        expenseEntity.payer = payerEntity
        //Shares
        for share in expense.shares {

            let shareEntity = ExpenseShareEntity(context: context)

            shareEntity.id = UUID()
            shareEntity.portions = Int16(share.portions)
            shareEntity.isSettled = false
            shareEntity.settledDate = nil

            shareEntity.housemate =
                fetchOrCreateHousemate(share.housemate)

            shareEntity.expense = expenseEntity
        }

        saveContext()
    }


    func getAllexpenses() -> [SharedExpenses] {

        let request = SharedExpensesEntity.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "date",
                ascending: false
            )
        ]

        do {
            let entities = try context.fetch(request)

            return entities.compactMap {
                mapToDomain($0)
            }

        } catch {
            print(
                "Failed to fetch expenses: \(error.localizedDescription)"
            )

            return []
        }
    }
    
    func isMonthSettled(
        monthKey: String
    ) -> Bool {

        let request = MonthlySettlementEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "monthKey == %@",
            monthKey
        )

        request.fetchLimit = 1

        do {
            let result = try context.fetch(request)

            return !result.isEmpty

        } catch {
            print(
                "Failed to check monthly settlement: \(error.localizedDescription)"
            )

            return false
        }
    }


    func settleMonth(
        monthKey: String,
        settledDate: Date
    ) throws {

        guard !isMonthSettled(monthKey: monthKey) else {
            throw MonthlySettlementRepositoryError.alreadySettled
        }

        let settlement =
            MonthlySettlementEntity(context: context)

        settlement.id = UUID()
        settlement.monthKey = monthKey
        settlement.settledDate = settledDate

        try context.save()
    }

    private func fetchOrCreateHousemate(
        _ housemate: Housemate
    ) -> HousemateEntity {

        let request = HousemateEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "id == %@",
            housemate.id as CVarArg
        )

        request.fetchLimit = 1

        if let existing =
            try? context.fetch(request).first {

            return existing
        }

        let entity = HousemateEntity(context: context)

        entity.id = housemate.id
        entity.name = housemate.name

        entity.avatarName = ""
        entity.email = ""
        entity.createdAt = Date()
        entity.isitCurrent = false

        return entity
    }



    private func mapToDomain(
        _ entity: SharedExpensesEntity
    ) -> SharedExpenses? {

        guard
            let id = entity.id,
            let title = entity.title,
            let categoryRaw = entity.category,
            let category = ExpenseCategory(rawValue: categoryRaw),
            let payerEntity = entity.payer,
            let payerID = payerEntity.id,
            let payerName = payerEntity.name,
            let date = entity.date
        else {
            return nil
        }

        let payer = Housemate(
            id: payerID,
            name: payerName
        )

        let shareEntities =
            entity.shares as? Set<ExpenseShareEntity>
            ?? []

        let shares: [Shares] =
            shareEntities.compactMap { shareEntity in

                guard
                    let housemateEntity = shareEntity.housemate,
                    let housemateID = housemateEntity.id,
                    let housemateName = housemateEntity.name
                else {
                    return nil
                }

                return Shares(
                    housemate: Housemate(
                        id: housemateID,
                        name: housemateName
                    ),
                    portions: Int(shareEntity.portions)
                )
            }

        return SharedExpenses(
            id: id,
            title: title,
            amount: entity.amount,
            category: category,
            payer: payer,
            shares: shares,
            date: date
        )
    }


    private func saveContext() {

        guard context.hasChanges else {
            return
        }

        do {
            try context.save()

        } catch {
            print(
                "Failed to save expense: \(error.localizedDescription)"
            )
        }
    }
}
