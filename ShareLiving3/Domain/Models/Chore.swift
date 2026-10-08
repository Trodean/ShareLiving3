//
//  Chore.swift
//  SharedLiving2
//
//  Created by Yang Peng on 15/9/2026.
// Represents a household task assigned to one housemate.
// It records who is responsible, when the task is due & whether it has been completed.

import Foundation

struct Chore:  Identifiable, Codable {
    let id: UUID
    let title: String
    let assignee: Housemate
    let dueDate: Date
    var isCompleted: Bool
}
