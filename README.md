# TODO List app

투두리스트 


```
Task 추가 제거, Tab Bar Controller
Data 관리 - NSCoding, Property List, Serialization, Core Data, Realm 등등
적고 단순한 데이터 관리 -> NSCoding, Peroperty List
많고 복잡한 데이터 관리 -> Coredata, Realm
최근 사용 경향은 Codable(Swift4에 추가, NSCoding보다는 덜 복잡하고 더 직관적이며, JSON Encoding & Decoding 프로토콜 준수)
```

데이터 관리는 JSON으로
codable protocol은 https://babbab2.tistory.com/61 에서 참고하여 구성했습니다.

-------------
210903

1.키보드 높이에 따라 Input View 위치를 변경하는 것은 해결되었다.
Main View 전체 높이가 safe area에 연동되어 auto layout이 설정되어있었던 것이 문제였다. 해당 부분을 삭제함으로서 해결되었다.

2. cell 재사용은 한칸 한칸 동일한 길이의 width가 설정되어야 하는데 그것이 빠졌는지 Label 안에 들어가는 텍스트의 길이에 따라 중구난방으로 셀 크기가 결정된다.

해결해야지..

![스크린샷 2021-09-03 19 42 23](https://user-images.githubusercontent.com/40759743/131993182-7d93ef90-16a4-441b-9f7e-760fe13328b7.png)




-----------
210902

컬렉션 뷰가 뜨지 않는 것은 이렇게 delegate와 data를 연결하지 않아서...(하...)였다.

기초적인 실수를 한 것 같아 자책을 했지만? 다음부터 그르즈믈흐으지..🤗


![스크린샷 2021-09-02 21 57 26](https://user-images.githubusercontent.com/40759743/131847602-e866e2a4-a3b8-4093-a492-ebc00caa655f.png)

View는 여전히 말썽이다. 키보드도 해결이 안되었고 cell 내 컨텐츠들의 정렬도 중구난방이다. 

Auto Layout을 다시 설정하고, action 관련 delegate도 확인필요.

![스크린샷 2021-09-02 21 55 47](https://user-images.githubusercontent.com/40759743/131847429-9a1e7b12-2d1c-4cc4-a4ee-e563db7eda28.png)


---------

210831

아래와같이 컬렉션 뷰 부분만 뜨지 않아 Storyboard내 objcet간 위상차 문제인가 싶어 이것저것 설정도 건들고, 뷰를 아예 새로 구성하기도 하기도 했는데 여전히 해결을 못했다.


Text Field가 있는 Input View도 키보드 프레임의 높이에 따라 Bottom 사이즈가 변동되도록 구현을 했는데 코드가 작동하지 않고 여전히 뷰를 덮어버린다..컬렉션뷰가 호출되지 않은 것 때문인지..?


우선 호출부터 해결해야한다..


![스크린샷 2021-09-02 21 37 29](https://user-images.githubusercontent.com/40759743/131844694-17ccfac9-c19e-4f2f-962a-ed6e72e8464b.png)


-------------


키보드 관련
키보드 높이 -> 유니버설 앱, 기기별 사이즈 때문에 시스템에서 키보드 프레임 정보를 받아와 진행하도록 함

```
 @objc private func adjstInputView(notify: Notification) {
        guard let userInfo = notify.userInfo else { return }
        // 키보드 올라 왔을때 위치와 사이즈 정보 받기
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notify.name == UIResponder.keyboardWillShowNotification {
            //노치 인셋
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
        } else {
            inputViewBottom.constant = 0
        }
        //console test message
        print("Keyboard Frame 확인 : \(keyboardFrame)")
    }
```


![스크린샷 2021-09-02 21 46 08](https://user-images.githubusercontent.com/40759743/131845979-e117d91c-3850-49dc-9ea3-acb6b69dc411.png)


print로 결과를 찍어봐도 콘솔창에서 키보드 높이 변화에 따른 값 변화가 감지된다. 아무래도 View의 Constraint 설정에 문제가 있는 것 같다
