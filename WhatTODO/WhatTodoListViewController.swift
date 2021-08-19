//
//  ViewController.swift
//  WhatTODO
//
//  Created by LeeYongJin on 2021/08/13.
//

import UIKit

class WhatTodoListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    // Task 추가 제거, Tab Bar Controller
    // Data 관리 - NSCoding, Property List, Serialization, Core Data, Realm 등등
    // 적고 덜 복잡한 데이터 관리 -> NSCoding, Peroperty List
    // 많고 복잡한 데이터 관리 -> Core data, Realm
    
    // 최근 사용 경향 Cadable(Swift4에 추가, NSCoding보다는 덜 복잡하고 더 직관적이며, JSON과 유사한 프로토콜 제공)


}

extension WhatTodoListViewController {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: 커스텀 셀
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhatTodoListCell", for: indexPath) as? WhatTodoListCell else {
            return UICollectionViewCell()
        }
        return cell
        
        return cell
    
}

// header View 클래스
class WhatTodoListHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
