//
//  Reserve.swift
//  GnuRental
//
//  Created by 정재영 on 2/15/24.
//

import Foundation

final class Reserve {
    private(set) var reserveItems: [ReserveItem]
    
    // 생성자
    init() {
        self.reserveItems = [
            ReserveItem(title: "축구장", image: "IconSoccerPlace"),
            ReserveItem(title: "농구장", image: "IconBasketballPlace"),
            ReserveItem(title: "테니스장", image: "IconTennisPlace"),
//            ReserveItem(title: "그룹 스터디룸", image: "IconStudyRoom"),
//            ReserveItem(title: "열람 좌석", image: "IconLibrarySeat"),
        ]
    }
}
