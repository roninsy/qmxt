//
//  GoodMasterView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/7.
//

import UIKit

class GoodMasterListView: UIView,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    lazy var nodataView : UIView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = .white
        let img = UIImageView.initWithName(imgName: "nodata_company")
        view.addSubview(img)
        img.snp.makeConstraints { make in
            make.width.equalTo(310)
            make.height.equalTo(177)
            make.top.equalTo(300)
            make.centerX.equalToSuperview()
        }
        
        let tip = UILabel.initSomeThing(title: "暂无导师", titleColor: .black, font: .MediumFont(size: 16), ali: .center)
        view.addSubview(tip)
        tip.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(22)
            make.top.equalTo(img.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        return view
    }()
    
    var topTitle = UILabel.initSomeThing(title: "明星导师榜", titleColor: .white, font: .SemiboldFont(size: 18), ali: .center)
    var pageNum = 1
    var type = 1{
        didSet{
            if type == 1 {
                tipLab.text = "--按销量等指标综合计算--"
            }else if type == 2{
                tipLab.text = "--按礼物点赞等指标综合计算--"
            }else if type == 3{
                tipLab.text = "--按入驻时间销量礼物等指标综合计算--"
            }
        }
    }
    let listView = UITableView()
    let topBgImg = UIImageView.initWithName(imgName: "good_master_top_bg")
    let topTitleImg = UIImageView.initWithName(imgName: "good_master_top_title")
    let headView = UIView()
    
    let backBtn = UIButton.initWithBackBtn(isBlack: false)
    
    let imgArr = [UIImageView.initWithName(imgName: "company_sel_1"),UIImageView.initWithName(imgName: "company_sel_2"),UIImageView.initWithName(imgName: "company_sel_3")]
    
    let btnArr = [UIButton.initTitle(title: "销量最高", fontSize: 16, titleColor: .init(hex: "#333333")),UIButton.initTitle(title: "人气最高", fontSize: 16, titleColor: .init(hex: "#333333")),UIButton.initTitle(title: "新秀导师", fontSize: 16, titleColor: .init(hex: "#333333"))]
    
    let tipLab = UILabel.initSomeThing(title: "--按销量等指标综合计算--", titleColor: .init(hex: "#333333"), font: .systemFont(ofSize: 14), ali: .center)
    
    var models : [GoodCompanyListModel] = NSArray() as! [GoodCompanyListModel]
    let imgHei = screenWid / 414 * 266
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#F7F8F9")
       
        self.addSubview(topBgImg)
        topBgImg.contentMode = .scaleAspectFill
        topBgImg.snp.makeConstraints { make in
            make.height.equalTo(imgHei)
            make.left.right.equalToSuperview()
            make.top.equalTo(0)
        }
        
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.left.equalTo(16)
            make.top.equalTo(NavStatusHei + 9)
        }
        backBtn.reactive.controlEvents(.touchUpInside).observeValues { btn in
            HQGetTopVC()?.navigationController?.popViewController(animated: true)
        }
        
        self.addSubview(topTitle)
        topTitle.contentMode = .scaleAspectFill
        topTitle.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.left.right.equalToSuperview()
            make.centerY.equalTo(backBtn)
        }
        topTitle.isHidden = true
        
        self.addSubview(topTitleImg)
        topTitleImg.snp.makeConstraints { make in
            make.width.equalTo(224)
            make.height.equalTo(73)
            make.top.equalTo(imgHei - 105)
            make.centerX.equalToSuperview()
        }
        
        setupHeadView()
        let topView = UIView()
        topView.frame = .init(x: 0, y: 0, width: screenWid, height: imgHei - NavStatusHei - 42 - 16)
        listView.delegate = self
        listView.dataSource = self
        listView.layer.cornerRadius = 16
        listView.layer.masksToBounds = true
        listView.backgroundColor = .clear
        listView.showsVerticalScrollIndicator = false
        listView.separatorStyle = .none
        listView.tableHeaderView = topView
        self.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(NavStatusHei + 42)
            make.bottom.equalTo(0)
            make.left.right.equalToSuperview()
        }
        
        listView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.pageNum += 1
            self.getNetInfo()
        })
        
        self.addSubview(nodataView)
        nodataView.snp.makeConstraints { make in
            make.top.equalTo(NavStatusHei + 42)
            make.bottom.equalTo(0)
            make.left.right.equalToSuperview()
        }
        nodataView.isHidden = true
    }
    
    func setupHeadView(){
        headView.frame = .init(x: 0, y: 0, width: screenWid, height: 102)
        HQRoude(view: headView, cs: [.topLeft,.topRight], cornerRadius: 16)
        headView.backgroundColor = .white
        let img1 = imgArr[0]
        headView.addSubview(img1)
        img1.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(screenWid/414*292)
            make.top.right.equalToSuperview()
        }
        
        let img2 = imgArr[1]
        headView.addSubview(img2)
        img2.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.top.right.equalToSuperview()
        }
        
        let img3 = imgArr[2]
        headView.addSubview(img3)
        img3.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(screenWid/414*292)
            make.top.left.equalToSuperview()
        }
        img1.tag = 0
        img2.tag = 1
        img3.tag = 2
        img2.isHidden = true
        img3.isHidden = true
        
        let btnWid = screenWid / 3
        for i in 0...2{
            let btn = btnArr[i]
            headView.addSubview(btn)
            btn.tag = i
            btn.snp.makeConstraints { make in
                make.width.equalTo(btnWid)
                make.height.equalTo(50)
                make.top.equalTo(0)
                make.left.equalTo(btnWid * CGFloat(i))
            }
            btn.reactive.controlEvents(.touchUpInside).observeValues { btn2 in
                DispatchQueue.main.async {
                    for img in self.imgArr{
                        img.isHidden = img.tag != btn2.tag
                        self.pageNum = 1
                        self.type = btn2.tag
                        self.getNetInfo()
                    }
                }
            }
        }
        
        headView.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.equalTo(0)
            make.left.right.equalToSuperview()
        }
        
        getNetInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNetInfo(){
        if self.pageNum == 1{
            self.models.removeAll()
        }
        NetworkProvider.request(.getTutorTop(pageNumber: self.pageNum, pageSize: 10, topType: self.type)) { result in
            self.listView.mj_footer?.endRefreshing()
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let arr : NSArray? = model!.data?["content"] as? NSArray
                            if (arr?.count ?? 0) > 0 {
                                let tempArr = arr!.kj.modelArray(type: GoodCompanyListModel.self) as! [GoodCompanyListModel]
                                if tempArr.count < 10 {
                                    self.listView.mj_footer?.endRefreshingWithNoMoreData()
                                }
                                if self.pageNum == 1 {
                                    self.models = tempArr
                                }else{
                                    self.models = self.models + tempArr
                                }
                            }else{
                                self.listView.mj_footer?.endRefreshingWithNoMoreData()
                            }
                            self.listView.reloadData()
                        }
                    }
                    
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 102
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.nodataView.isHidden = self.models.count > 0
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : GoodMasterListCell? = tableView.dequeueReusableCell(withIdentifier: "GoodMasterListCell") as? GoodMasterListCell
        if cell == nil {
            cell = GoodMasterListCell.init(style: .default, reuseIdentifier: "GoodMasterListCell")
        }
        cell?.model = self.models[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 216
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.topTitle.isHidden = scrollView.contentOffset.y < (imgHei - NavStatusHei - 42 - 16)
    }
}



