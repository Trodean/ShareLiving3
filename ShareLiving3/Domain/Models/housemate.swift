//
//  housemate.swift
//  SharedLiving2
//
//  Created by Yang Peng on 15/9/2026.
//

import Foundation

// Represents a person who belongs to the shared household.
struct Housemate: Identifiable, Codable {
    let id: UUID
    let name: String
}
