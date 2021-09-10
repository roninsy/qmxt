//
//  SearchCourseHeadView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/8.
//

import UIKit
import CollectionKit

class SearchCourseHeadView: UIView,UITextFieldDelegate {

    var subSelIndex = 0
    
    var searchBlock : stringBlock? = nil
    
    var selSubBlock : stringBlock? = nil
    
    let backBtn = UIButton.initWithBackBtn(isBlack: true)
    
    let titleLab = UILabel.initSomeThing(title: "全部课程", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 18), ali: .center)
    
    let grayBG = UIView()
    
    let searchIcon = UIImageView.initWithName(imgName: "searchicon")
    
    let searchTF = UITextField()
    
    let cleanBtn = UIButton.initImgv(imgv: .initWithName(imgName: "search_clean"))
    
    let searchBtn = UIButton.initTitle(title: "搜索", font: .MediumFont(size: 16), titleColor: .init(hex: "#333333"), bgColor: .clear)
    
    let selView = SearchCourseTitleListView()
    
    var subSelHei : CGFloat = 51
    var myHei : CGFloat = 130 + NavStatusHei
    
    var ds = ArrayDataSource<KechengChildTypeModel>()
    
    let listView = CollectionView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#F7F8F9")
        let whiteBG = UIView()
        whiteBG.backgroundColor = .white
        self.addSubview(whiteBG)
        whiteBG.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(myHei)
        }
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(16)
            make.top.equalTo(NavStatusHei + 15)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popViewController(animated: true)
        }
        
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.left.right.equalToSuperview()
            make.centerY.equalTo(backBtn)
        }
        
        grayBG.backgroundColor = .init(hex: "#EEEFF1")
        grayBG.layer.cornerRadius = 18
        grayBG.layer.masksToBounds = true
        
        self.addSubview(grayBG)
        grayBG.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.left.equalTo(16)
            make.top.equalTo(titleLab.snp.bottom).offset(13)
            make.right.equalTo(-64)
        }
        
        self.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalTo(grayBG)
            make.left.equalTo(grayBG).offset(16)
        }
        
        searchTF.placeholder = "搜索课程标题"
        searchTF.returnKeyType = .search
        self.addSubview(searchTF)
        searchTF.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerY.equalTo(grayBG)
            make.left.equalTo(grayBG).offset(39)
            make.right.equalTo(grayBG).offset(-39)
        }
        searchTF.delegate = self
        searchTF.reactive.controlEvents(.editingChanged).observeValues { tf in
            self.cleanBtn.isHidden = tf.text?.length == 0
        }
        
        self.addSubview(cleanBtn)
        cleanBtn.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.right.equalTo(grayBG).offset(-16)
            make.centerY.equalTo(grayBG)
        }
        cleanBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.searchTF.text = ""
            btn.isHidden = true
        }
        cleanBtn.isHidden = true
        
        self.addSubview(searchBtn)
        searchBtn.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(32)
            make.right.equalTo(0)
            make.centerY.equalTo(grayBG)
        }
        
        searchBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            self.searchBlock?(self.searchTF.text ?? "")
            self.endEditing(false)
        }
        
        self.addSubview(selView)
        selView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.equalToSuperview()
            make.top.equalTo(grayBG.snp.bottom).offset(4)
        }
        
        let viewSource = ClosureViewSource(viewUpdater: { (view: CourseTypeSelView, data: KechengChildTypeModel, index: Int) in
            view.model = data
            view.isSel = index == self.subSelIndex
        })

        let sizeSource = { (index: Int, data: KechengChildTypeModel, collectionSize: CGSize) -> CGSize in
            return CGSize(width: 64, height: 27)
        }
        
        let provider = BasicProvider(
          dataSource: ds,
          viewSource: viewSource,
          sizeSource: sizeSource
        )

        provider.layout = RowLayout.init("provider", spacing: 12, justifyContent: JustifyContent.start, alignItems: .start)

        provider.tapHandler = { hand in
            let model = hand.data
            self.subSelIndex = hand.index
            self.ds.reloadData()
            self.selSubBlock?(model.id ?? "")
        }

        listView.provider = provider
        listView.showsVerticalScrollIndicator = false
        listView.showsHorizontalScrollIndicator = false
        self.addSubview(listView)
        listView.snp.makeConstraints { (make) in
            make.top.equalTo(selView.snp.bottom).offset(12)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(27)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchBlock?(textField.text ?? "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.endEditing(false)
        }
        return true
    }

}
