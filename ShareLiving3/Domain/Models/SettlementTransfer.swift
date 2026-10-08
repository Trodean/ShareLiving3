//
//  SettlementTransfer.swift
//  ShareLiving3
//
//  Created by Yang Peng on 8/10/2026.
//

import Foundation

struct SettlementTransfer: Identifiable {

    let id: UUID

    let from: Housemate
    let to: Housemate
    let amount: Double

    init(
        id: UUID = UUID(),
        from: Housemate,
        to: Housemate,
        amount: Double
    ) {
        self.id = id
        self.from = from
        self.to = to
        self.amount = amount
    }
}
