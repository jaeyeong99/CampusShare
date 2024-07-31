//
//  ReserveItem.swift
//  GnuRental
//
//  Created by 정재영 on 2/5/24.
//

import Foundation


struct ReserveItem: Identifiable {
    var id = UUID()
    
    let title : String
    let image : String
}

// Priview의 파라미터로 사용하기 위해 선언
let ReserveItemSample: ReserveItem = ReserveItem(title: "축구장", image: "IconSoccerPlace")

