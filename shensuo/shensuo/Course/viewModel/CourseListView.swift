//
//  KeChengListView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/1.
//

import UIKit
import CollectionKit

class CourseListView: UIView {
    var ds = ArrayDataSource<KeChengModel>()
    let listView = CollectionView()
    var models : [KeChengModel]? = nil{
        didSet{
            if models != nil {
                ds.data = models!
                ds.reloadData()
            }
        }
    }
    
    var nowPage = 1
    override init(frame: CGRect) {
        super.init(frame: frame)
        let viewSource = ClosureViewSource(viewUpdater: { (view: KeChengInfoView, data: KeChengModel, index: Int) in
            view.model = data
        })
        let sizeSource = { (index: Int, data: KeChengModel, collectionSize: CGSize) -> CGSize in
            return CGSize(width: data.wid, height: data.modelHei)
        }
        
        let provider = BasicProvider(
          dataSource: ds,
          viewSource: viewSource,
          sizeSource: sizeSource
        )

        provider.layout = FlowLayout(spacing: 10, justifyContent: .center)
        provider.tapHandler = { hand in
//            var model = hand.data
            self.makeToast("打开课程")
        }
        
        listView.delegate = self
        listView.provider = provider
        listView.showsVerticalScrollIndicator = false
        listView.showsHorizontalScrollIndicator = false
        self.addSubview(listView)
        listView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNetInfo(){
        NetworkProvider.request(.homeListData(page: nowPage)) { result in
            switch result{
            case let .success(moyaResponse):
                do {
                    let code = moyaResponse.statusCode
                    if code == 200{
                        let json = try moyaResponse.mapString()
                        
                        let model = json.kj.model(ResultDicModel.self)
                        if model?.code == 0 {
                            let dic = model!.data!
                            let total = dic["totalElements"] as! String
                            if (total.toInt ?? 0) > 0 {
                                let arr = dic["content"] as! NSArray
                                if self.nowPage == 1 {
                                    self.models = arr.kj.modelArray(type: KeChengModel.self)
                                        as? [KeChengModel]
                                }else{
                                    let models = arr.kj.modelArray(type: KeChengModel.self)
                                        as? [KeChengModel]
                                    self.models = self.models! + (models ?? [])
                                }
                                
                            }
                        }else{
                            
                        }
                    }
                    
                }catch {
                
            }
        case .failure(_):
            HQGetTopVC()?.view.makeToast("网络有误，请稍后重试")
            
            }
        }
    }
}


extension CourseListView : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 1 {
            listView.isScrollEnabled = false
            let sv : UIScrollView = self.superview as! UIScrollView
            sv.isScrollEnabled = true
        }
    }
}
