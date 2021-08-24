//
//  WhatTodo.swift
//  WhatTODO
//
//  Created by LeeYongJin on 2021/08/24.
//

import UIKit

// Equatable 객체간 동등비교를 위한 protocol(다르다면 업데이트 발생)
struct WhatTodo: Codable, Equatable {
    
    let id: Int // 객체 관리 용도 구분자
    var isDone: Bool // 완료 여부
    var detailMSG: String // description comment
    var isToday: Bool // 기일 도래 여부
    
    // 값 변화 감지 함수
    mutating func DataUpdate(isDone: Bool, detailMSG: String, isToday: Bool) {
        self.isDone = isDone
        self.detailMSG = detailMSG
        self.isToday = isToday
    }
    
    // 좌우엽 비교 (id 검출)
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

