//
//  WhatTodoListCell.swift
//  WhatTODO
//
//  Created by LeeYongJin on 2021/08/19.
//

import UIKit

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
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func updateUI(task: TodoData) {
        checkIcon.isSelected = task.isDone
        descriptionsLabel.text = task.detailMSG
        descriptionsLabel.alpha = task.isDone ? 0.2 : 1  // 투명도
        deleteButton.isHidden = task.isDone == false
        
    }
    
    
}
