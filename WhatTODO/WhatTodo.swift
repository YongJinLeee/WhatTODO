//
//  WhatTodo.swift
//  WhatTODO
//
//  Created by LeeYongJin
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
        let nextId: Int = ListManager.lastId + 1
        ListManager.lastId = nextId
            
        return TodoData(id: nextId, isDone: false, detailMSG: detailMSG, isToday: isToday)
        
    }
    // 신규 생성된 노드 Todo List에 추가
    func addTodo(_ task: TodoData) {
        tasks.append(task)
        saveTodo()
    }
    
    // 선택 혹은 del버튼 눌린 노드 삭제 (del 핸들러에는 해당 노드 id가 전달되어야)
    func deleteTodo(_ task: TodoData) {
        // tasks의 배열에서 id 일치 하지 않는 노드만 추려 배열 재구성
        tasks = tasks.filter { $0.id != task.id }
        saveTodo()
//        tasks = tasks.filter { existingTodo in
//            return existingTodo.id != task.id
//        }
// 축약
// 복잡도에서 if ~ firstIndex 보다 filter가 우위에 있음. 대용량 자료 처리까지 고려
    }
    // 배열에 새로운 index 감지되면 구조체 업데이트
    func updateTodo(_ task: TodoData) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].DataUpdate(isDone: false, detailMSG: task.detailMSG, isToday: task.isToday)
        saveTodo()
    }
    
    // 업데이트된 구조체 Directory화 및 json 파일 저장
    func saveTodo() {
        Storage.store(tasks, to: .documents, as: "tasks.json")
    }
    
    // 저장된 파일 불러오기 (앱 재시작, 백그라운드에서 재시작 등 다시 호출 할 상황)
    func retriveTodo() {
       tasks = Storage.retrive("tasks.json", from: .caches, as: [TodoData].self) ?? []
        
        let lastId =  tasks.last?.id ?? 0
        ListManager.lastId = lastId
    }

}
// ListManager 메소드로 WhatTodoList View를 컨트롤하는 class
class WhatTodoViewModel {
    
    enum Section: Int, CaseIterable {
        case today
        case upcoming
        
        var title: String {
            switch self {
            case .today: return "Today"
            default: return "Upcoming"
            }
        }
    }
    
    private let manager = ListManager.shared
    
    // 해당 cell의 task 정보가 담긴 TodoData 호출
    var tasks: [TodoData] {
        return manager.tasks
    }
    
    // isToday Bool 값에 따라 위치할 섹션 분할, 섹션 내 아이템 개수 호출 용도
    var todaysTask: [TodoData] {
        return tasks.filter { $0.isToday == true }
    }
    var upcomingTasks: [TodoData] {
        return tasks.filter { $0.isToday == false }
    }
    
    //섹션 개수
    var numOfSection: Int {
        return Section.allCases.count
    }
    
    func addTodo(_ task: TodoData) {
        manager.addTodo(task)
    }
    
    func deleteTodo(_ task: TodoData) {
        manager.deleteTodo(task)
    }
    
    func updateTodo(_ task: TodoData) {
        manager.updateTodo(task)
    }
    
    func loadTodo() {
        manager.retriveTodo()
    }
}
