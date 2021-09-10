//
//  SSReleaseTopCell.swift
//  shensuo
//
//  Created by  yang on 2021/6/22.
//

import UIKit
import Kingfisher

class SSReleaseTopCell: SSBaseCell, UICollectionViewDataSource,UICollectionViewDelegate, UITextViewDelegate {

    
    public var vc: UIViewController?
    var marginView = UIView()
    var titleView = UIView()
    var lineView: UIView!
    var titleTf:UITextView = {
        let com = UITextView.init()
        var placeHolderLabel = UILabel.init()
        placeHolderLabel.text = "填写标题会有更多赞哦~"
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.textColor = .lightGray
        placeHolderLabel.sizeToFit()
        com.addSubview(placeHolderLabel)
        com.font = .MediumFont(size: 16)
        placeHolderLabel.font = .systemFont(ofSize: 13)
        com.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        return com
    }()
    let maxNumL = UILabel.initSomeThing(title: "0/30", fontSize: 16, titleColor: .init(hex: "#878889"))
    var collectionView: UICollectionView!
    let centerV = UIView()
    var imageTitle: UILabel!
    var numL: UILabel!
    var listArray = [UIImage.init(named: "check_addbtn_icon")]
    var titleBlock : stringBlock? = nil
    var selectImageBlcok: intBlock? = nil
    var jumpBigImageBlcok: intBlock? = nil
    //是否有封面
    var hasHeadImg: Bool = false
    var headImg: String?
    var inType = 0
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if listArray.count < 9 {
            
            return listArray.count
        }
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SSReleaseImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SSReleaseImageCell.self), for: indexPath) as! SSReleaseImageCell
        if hasHeadImg && indexPath.item == 0 && inType != 8{
            
            cell.image.kf.setImage(with: URL(string: headImg ?? ""))
        }else{
            
        
            cell.image.image = self.listArray[indexPath.item]
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.inType == 8 {
            
            return
        }
        
        if self.listArray.count > 9 {
            
            jumpBigImageBlcok?(indexPath.item)
        }
        else{
            
            if indexPath.item == listArray.count - 1 {
                
                selectImageBlcok?(indexPath.item)

            }
            else{
                
                jumpBigImageBlcok?(indexPath.item)

            }
        }
        
    }
    
    func reloadImageData(list: Array<UIImage>, detalisModel: SSReleaseModel,
                         stepList: [CourseStepListModel],inType: Int,noteType: Int,title: String) {
        
        listArray = list
        self.inType = inType
        hasHeadImg = false
        if inType != 1 {
            if inType == 8 {
                hasHeadImg = true
                listArray.append(detalisModel.shareImg)
                
            }else{
                if detalisModel.headImageName != "" && detalisModel.headImageName.contains("http"){
//                    if noteType == 1 && listArray.count > 0{
//                        hasHeadImg = false
//                    }else{
                        hasHeadImg = true
                        headImg = detalisModel.headImageName
                    listArray.append(UIImage())
//                    }
                }
            }
        }
        switch inType {
            case 0:
                break
            case 1:
                titleTf.text = "我已完成课程\(title)"
                break
            case 2:
                titleTf.text = "我已完成课程小节\(title)"
                break
            case 3:
                titleTf.text = "我已开通VIP年卡会员，尊享四大特权"
                break
            case 4:
                titleTf.text = "我已完成方案\(title)"
                break
            case 5:
                titleTf.text = "我已完成当天方案\(title)"
                break
            case 6,7:
                titleTf.text = detalisModel.title
            case 8:
                titleTf.text = "我已开通VIP年卡会员，尊享四大特权"
            default:
                break
        }
        imageTitle.text = noteType == 1 ? "视频" : "图片"
        if noteType == 2 && inType != 8{
        
            listArray.insert(UIImage.init(named: "check_addbtn_icon"), at: list.count)
            numL.isHidden = false
        }else{
            
            numL.isHidden = listArray.count > 0
        }
        self.numL.isHidden = noteType == 1
      
        var str = self.listArray.count < 10 ? "\(self.listArray.count - 1)" : "9"
        str = str + "/"
        str = str + "9"
        self.numL.text = str
        self.collectionView.reloadData()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        titleBlock?(textView.text ?? "")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.length > 30 {
            HQGetTopVC()?.view.makeToast("标题最大为30个字符")
            textView.text = textView.text.subString(to: 29)
//
//          var height = heightWithFont(font: UIFont.MediumFont(size: 16), fixedWidth: screenWid - 32, str: textView.text)
//            if height > 55 {
//
//                height = 55
////                textView.isScrollEnabled = false
//            }else{
//
//
//            }
//            textView.setContentOffset(.zero, animated: false)
//            titleTf.snp.updateConstraints { make in
//
//                make.height.equalTo(height)
//            }
        }
        
        self.maxNumL.text = "\(textView.text.length)/30"
    }
    
    func buildUI() {
        
        
        marginView.backgroundColor = bgColor
        contentView.addSubview(marginView)
        
        contentView.addSubview(titleView)
        
        lineView = UIView.init()
        titleView.addSubview(lineView)
        titleView.isUserInteractionEnabled = true
        
        titleView.addSubview(titleTf)
        titleTf.delegate = self
        titleTf.returnKeyType = .done
    
        customTap(target: self, action: #selector(titleViewTap), view: titleView)
        
        addSubview(centerV)
        
        imageTitle = UILabel.initSomeThing(title: "图片", fontSize: 16, titleColor: color33)
        imageTitle.font = .MediumFont(size: 16)
        centerV.addSubview(imageTitle)
        numL = UILabel.initSomeThing(title: "0/9", fontSize: 14, titleColor: color99)
    
        centerV.addSubview(numL)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        
        layout.itemSize = .init(width: 90, height: 90)
        layout.sectionInset = .init(top: 10, left: 16, bottom: 10, right: 16)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SSReleaseImageCell.self, forCellWithReuseIdentifier: String(describing: SSReleaseImageCell.self))
        collectionView.backgroundColor = .white
        collectionView.scrollToItem(at: IndexPath.init(item: listArray.count - 1, section: 0), at: .right, animated: false)
        
        layoutSub()
    }
    
    @objc func titleViewTap() {
        
        self.titleBlock?("")
        
    }
    
    public func setVC(vc: UIViewController){
        
        
    }
    
     func layoutSub() {
//        super.layoutSubviews()
        
        marginView.snp.makeConstraints { make in
            
            make.leading.trailing.top.equalTo(contentView)
            make.height.equalTo(normalMarginHeight)
        }
        
        
        centerV.snp.makeConstraints { make in
            
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(40)
            make.top.equalTo(marginView.snp.bottom).offset(0.5)
        }
        
        imageTitle.snp.makeConstraints { make in
            
            make.centerY.equalTo(centerV)
            make.leading.equalTo(16)
        }
        
        numL.snp.makeConstraints { make in
            
            make.centerY.equalTo(centerV)
            make.trailing.equalTo(-16)
        }
        
        collectionView.snp.makeConstraints { make in
            
            make.height.equalTo(116)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(centerV.snp.bottom)
        }
        
        let titleLine = UIView()
        titleLine.backgroundColor = bgColor
        contentView.addSubview(titleLine)
        titleLine.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(12)
            make.top.equalTo(collectionView.snp.bottom)
        }
        
        titleView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(58.0)
            make.top.equalTo(titleLine.snp.bottom)
        }
    
        
        titleTf.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-100)
            make.center.equalToSuperview()
            make.height.equalTo(30)
        }
        
        maxNumL.textAlignment = .right
        contentView.addSubview(maxNumL)
        maxNumL.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.height.equalTo(20)
            make.width.equalTo(60)
            make.centerY.equalTo(titleTf)
        }

        lineView.snp.makeConstraints { make in
            
            make.leading.equalTo(11)
            make.trailing.equalTo(9)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
