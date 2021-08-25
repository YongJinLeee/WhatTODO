//
//  WhatTodoListCell.swift
//  WhatTODO
//
//  Created by LeeYongJin
//

import UIKit

// MVVM : View
class WhatTodoListCell: UICollectionViewCell {

    @IBOutlet weak var checkIcon: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var descriptionsLabel: UILabel!
    @IBOutlet weak var cancelLineThroughView: UIView!
    
    @IBOutlet weak var cancelLineThroughWidth: NSLayoutConstraint!
    
    // 각 버튼의 동작 핸들러 함수
    // 동작 여부를 외부로 부터 받아 수행 (ViewModel) -> 구현은 해당 코드 바깥에서 되도록 설계
    var doneBtnTapHandler: ((Bool) -> Void)?
    var delBtnTapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func updateUI(task: TodoData) {
        checkIcon.isSelected = task.isDone
        descriptionsLabel.text = task.detailMSG
        descriptionsLabel.alpha = task.isDone ? 0.2 : 1  // 투명도
        deleteButton.isHidden = task.isDone == false
        
        showCancelLine(task.isDone) // 취소선 긋기 여부
    }
    // true인 경우 취소선
    private func showCancelLine(_ show: Bool) {
        if show {
            cancelLineThroughWidth.constant = descriptionsLabel.bounds.width
        } else {
            cancelLineThroughWidth.constant = 0
        }
    }
    
    // app 종료, 재시작 등으로 UI를 재설정 및 재배열하는 함수. 일종의 초기화
    func reset() {
        descriptionsLabel.alpha = 1 //투명도 0
        deleteButton.isHidden = true
        showCancelLine(false)
    }
    
    func checkBtnToggle(_ sender: Any) {
        checkIcon.isSelected = !checkIcon.isSelected
        //view 조정
        let isDone = checkIcon.isSelected
        showCancelLine(isDone)
        descriptionsLabel.alpha = isDone ? 0.2 : 1
        deleteButton.isHidden = !isDone // 반대 관계 (true: 숨김 / false: 보임)
        
        // 실제 data 변경할 핸들러
        doneBtnTapHandler?(isDone)
    }
    func deleteBtnTapped(_ sender: Any) {
        // 탭이 되었다는 사실만 핸들러에 담고, 실제 연산은 외부에서 이루어지도록 구현
        delBtnTapHandler?()
    }
}
// section분할시마다 Object사용을 위한 ReusableView class
class WhatTodoListHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
