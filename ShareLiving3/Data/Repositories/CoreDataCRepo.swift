//
//  CoreDataCRepo.swift
//  ShareLiving3
//
//  Created by Yang Peng on 8/10/2026.
//

import Foundation
import CoreData

final class CoreDataChoreRepository: ChoreRepo {

    private let context: NSManagedObjectContext

    init(
        context: NSManagedObjectContext =
            PersistenceController.shared.container.viewContext
    ) {
        self.context = context
    }

    func addChore(_ chore: Chore) {

        let choreEntity = ChoreEntity(context: context)

        choreEntity.id = chore.id
        choreEntity.title = chore.title
        choreEntity.dueDate = chore.dueDate
        choreEntity.isCompleted = chore.isCompleted

        choreEntity.assignee =
            fetchOrCreateHousemate(chore.assignee)

        saveContext()
    }

    func updateChore(_ chore: Chore) {

        let request = ChoreEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "id == %@",
            chore.id as CVarArg
        )
        request.fetchLimit = 1

        do {
            guard let choreEntity =
                    try context.fetch(request).first
            else {
                return
            }
            choreEntity.title = chore.title
            choreEntity.dueDate = chore.dueDate
            choreEntity.isCompleted = chore.isCompleted

            choreEntity.assignee =
                fetchOrCreateHousemate(chore.assignee)

            saveContext()

        } catch {
            print(
                "Failed to update chore: \(error.localizedDescription)"
            )
        }
    }

    func getAllChores() -> [Chore] {

        let request = ChoreEntity.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "dueDate",
                ascending: true
            )
        ]

        do {
            let entities = try context.fetch(request)
            return entities.compactMap {
                mapToDomain($0)
            }

        } catch {
            print(
                "Failed to fetch chores: \(error.localizedDescription)"
            )
            return []
        }
    }
    func getIncompleteChores(dueBy date: Date) -> [Chore] {
        let request = ChoreEntity.fetchRequest ()

        request.predicate = NSPredicate(
            format: "isCompleted == NO AND dueDate <= %@",
            date as NSDate
        )
        request.sortDescriptors = [
            NSSortDescriptor(
                key: "dueDate",
                ascending: true
            )
        ]
        do{
            let entities = try context.fetch(request)

            return entities.compactMap {
                mapToDomain($0)
            }

        } catch {
            print(
                "Failed to fetch incomplete chores: \(error.localizedDescription)"
            )

            return []
        }
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
        return entity
    }

    private func mapToDomain(
        _ entity: ChoreEntity
    ) -> Chore? {

        guard
            let id = entity.id,
            let title = entity.title,
            let dueDate = entity.dueDate,
            let assigneeEntity = entity.assignee,
            let assigneeID = assigneeEntity.id,
            let assigneeName = assigneeEntity.name
        else {
            return nil
        }

        let assignee = Housemate(
            id: assigneeID,
            name: assigneeName
        )

        return Chore(
            id: id,
            title: title,
            assignee: assignee,
            dueDate: dueDate,
            isCompleted: entity.isCompleted
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
                "Failed to save chore: \(error.localizedDescription)"
            )
        }
    }
}
