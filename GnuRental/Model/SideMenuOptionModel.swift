//
//  SideMenuOptionModel.swift
//  GnuRental
//
//  Created by 정재영 on 4/21/24.
//

import Foundation

enum SideMenuOptionModel: Int, CaseIterable {
    case rentalHistory
    case reserveHistory
    
    var title: String {
        switch self {
        case .rentalHistory:
            return "물품 대여 내역"
        case .reserveHistory:
            return "시설 예약 내역"
        }
    }
}

extension SideMenuOptionModel: Identifiable {
    var id: Int { return self.rawValue }
}
