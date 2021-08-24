//
//  WhatTodo.swift
//  WhatTODO
//
//  Created by LeeYongJin on 2021/08/24.
//

import UIKit

// Equatable 객체간 동등비교를 위한 protocol(다르다면 업데이트 발생)
struct TodoData: Codable, Equatable {
    
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

class ListManager {
    //싱글톤; 타입 인스턴스 및 타입 프로퍼티
    static let shared = ListManager()
    
    static var lastId: Int = 0
    
    var tasks: [TodoData] = []
    
    func createTodo(detailMSG: String, isToday: Bool) -> TodoData {
        // 신규 id 부여 및 다음 노드 아이디 변수 재할당
        var nextId: Int = ListManager.lastId + 1
        ListManager.lastId = nextId
            
        return TodoData(id: nextId, isDone: false, detailMSG: detailMSG, isToday: isToday)
        
    }
    // 신규 생성된 노드 Todo List에 추가
    func addTodo(_ task: TodoData) {
        tasks.append(task)
    }
    
    // 선택 혹은 del버튼 눌린 노드 삭제 (del 핸들러에는 해당 노드 id가 전달되어야)
    func deleteTodo(_ task: TodoData) {
        if let currentId = tasks.firstIndex(of: task) { // 삭제할 할일 노드의 아이디 검출
            tasks.remove(at: currentId)
            // 공식 문서에서는 복잡도가 O(n)
            // filter closure 사용..?
        }
    }
}
