//
//  ViewController.swift
//  WhatTODO
//
//  Created by LeeYongJin on 2021/08/13.
//

import UIKit

class WhatTodoListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 키보드 디텍션 bottom 조절용 connection
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var isTodayBtn: UIButton!
    @IBOutlet weak var addTaskBtn: UIButton!
    
    let WhatTodoListViewModel = WhatTodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // Task 추가 제거, Tab Bar Controller
    // BLG1
    @IBAction func addTaskBtnTapped(_ sender: Any) {
        // 없으면 void return
        guard let detail = inputTextField.text, detail.isEmpty == false else { return }
        let whatTodo = ListManager.shared.createTodo(detailMSG: detail, isToday: isTodayBtn.isSelected)
        
        WhatTodoListViewModel.addTodo(whatTodo)
        collectionView.reloadData()
        // [해결] collection View reload 또는 update 기능 추가 필요..
        // task 업로드 후 텍스트 필드 초기화 및 today 버튼 초기화
        inputTextField.text = ""
        isTodayBtn.isSelected = false
        
    }
    
    // Data 관리 - NSCoding, Property List, Serialization, Core Data, Realm 등등
    // 적고 덜 복잡한 데이터 관리 -> NSCoding, Peroperty List
    // 많고 복잡한 데이터 관리 -> Core data, Realm
    
    // 최근 사용 경향 Cadable(Swift4에 추가, NSCoding보다는 덜 복잡하고 더 직관적이며, JSON과 유사한 프로토콜 제공)


    @IBAction func isTodayBtnToggle(_ sender: Any) {
        isTodayBtn.isSelected = !isTodayBtn.isSelected
    }
    
}

extension WhatTodoListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 섹션 수 설정 - Today, UpComming
        return WhatTodoListViewModel.numOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 섹선 내 아이템 수 -> 생성하는 대로되도록
        if section == 0 {
            // 첫 번째 섹션 내 아이템 수 (0번)
            return WhatTodoListViewModel.todaysTask.count
        } else {
            return WhatTodoListViewModel.upcomingTasks.count
        }
        // 개선점 : 추후 섹션을 더 분리할 수 있는 기능을 추가하면 수정 필요함
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // section 내 data 담을 custom cell 호출
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhatTodoListCell", for: indexPath) as? WhatTodoListCell else {
            return UICollectionViewCell()
        }
        var tasks: TodoData
        if indexPath.section == 0 {
            tasks = WhatTodoListViewModel.todaysTask[indexPath.item]
        } else {
            tasks = WhatTodoListViewModel.upcomingTasks[indexPath.item]
        }
        // 셀 정보 업데이트
        cell.updateUI(task: tasks)
        
        cell.doneBtnTapHandler = { isdone in tasks.isDone = isdone
            self.WhatTodoListViewModel.updateTodo(tasks)
            self.collectionView.reloadData()
        }
        
        cell.deleteBtnTapped {
            self.WhatTodoListViewModel.deleteTodo(tasks)
            self.collectionView.reloadData()
        }
        
        return cell
    
}

// header View 클래스
class WhatTodoListHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        }
    }
}
// cell 사이즈 조정
extension WhatTodoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
}
