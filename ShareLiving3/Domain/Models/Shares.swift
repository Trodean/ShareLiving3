//
//  Shares.swift
//  SharedLiving2
//
//  Created by Yang Peng on 15/9/2026.
// Represents one housemate's share of a household expense.
//  The number of portions is used to describe how much of the total expense that housemate should cover.

import Foundation

struct Shares: Codable {
    let housemate: Housemate
    let portions: Int
}
