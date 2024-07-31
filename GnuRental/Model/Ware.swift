//
//  Ware.swift
//  GnuRental
//
//  Created by 정재영 on 4/11/24.
//

import Foundation

struct Ware: Codable, Identifiable {
    let wareId: Int
    let category: String
    let name: String
    let maxCount: Int
    let currentCount: Int

    var id: Int { wareId } // Identifiable 요구사항 충족
}

let wareSample: Ware = Ware(wareId: 1, category: "BALL", name: "농구공", maxCount: 10, currentCount: 10)
