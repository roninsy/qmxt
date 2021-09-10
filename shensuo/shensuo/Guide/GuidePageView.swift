//
//  GuidePageView.swift
//  GuidePageView
//
//  Created by lisilong on 2018/1/4.
//  Copyright © 2018年 tuandai. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

public class GuidePageView: UIView {
    ///主标题
    let mainTitle = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#333333"), font: .boldSystemFont(ofSize: 28), ali: .center)
    ///副标题
    let subTitle = UILabel.initSomeThing(title: "", titleColor: .init(hex: "#666666"), font: .systemFont(ofSize: 16), ali: .center)
    
    let mainTitleArr = ["科学变美","健康变美","优雅变美"]
    let subTitleArr = ["人工智能量身定制，让您科学变美","随时随地训练，让您健康变美","专业女神导师，让您优雅变美"]
    private lazy var guideScrollView: UIScrollView = {
        let view = UIScrollView.init()
        view.backgroundColor = UIColor.clear
        view.bounces = false
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        ///修正偏移问题
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    /// 指示器
    var pageControl = UIImageView.initWithName(imgName: "guide_bot1")
    
    /// 跳过按钮
    let skipButton: UIButton = UIButton.initTitle(title: "跳过", fontSize: 16, titleColor: .white)
    
    /// 登录注册按钮
    let logtinButton = UIButton.initBGImgAndTitle(img: UIImage.init(named: "login_btn_bg")!, title: "立即进入", font: .boldSystemFont(ofSize: 18), titleColor: .white, space: 0)
    
    /// 是否打开右滑进入主题，default: false
    public var isSlipIntoHomeView: Bool = false
    
    /// 是否隐藏跳过按钮(true 隐藏; false 不隐藏)，default: false
    private var isHiddenSkipBtn: Bool = false
    
    /// 是否隐藏立即体验按钮(true 隐藏; false 不隐藏)，default: false
    private var isHiddenStartBtn: Bool = false
    
    /// 数据源
    private var imageArray: Array<String>?
    
    var startCompletion: (() -> ())?
    var loginCompletion: (() -> ())?
    let pageControlHeight: CGFloat = 40.0
    let startHeigth: CGFloat = 30.0
    let loginHeight: CGFloat = 40.0
    /// 是否正在做滑入动作
    private var isSliping: Bool = false
    
    // MARK: - life cycle
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// App启动引导页
    ///
    /// - Parameters:
    ///   - frame: 引导页大小
    ///   - images: 引导页图片（gif/png/jpeg...）注意：gif图不可放在Assets中，否则加载不出来（建议引导页的图片都不要放在Assets文件中，因为使用imageName加载时，系统会缓存图片，造成内存暴增）
    ///   - isHiddenSkipBtn: 是否隐藏跳过按钮
    ///   - isHiddenStartBtn: 是否隐藏立即体验按钮
    ///   - loginRegistCompletion: 登录/注册回调
    ///   - startCompletion: 立即体验回调
    public convenience init(frame: CGRect = UIScreen.main.bounds,
                            images: Array<String>,
                            isHiddenSkipBtn: Bool = false,
                            isHiddenStartBtn: Bool = false,
                            loginRegistCompletion: (() -> ())?,
                            startCompletion: (() -> ())?) {
        self.init(frame: frame)
        
        self.imageArray       = images
        self.isHiddenSkipBtn  = isHiddenSkipBtn
        self.isHiddenStartBtn = isHiddenStartBtn
        self.startCompletion  = startCompletion
        self.loginCompletion  = loginRegistCompletion
        
        setupSubviews(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup
    private func setupSubviews(frame: CGRect) {
        let size = UIScreen.main.bounds.size
        guideScrollView.frame = frame
        guideScrollView.contentSize = CGSize.init(width: frame.size.width * CGFloat(imageArray?.count ?? 0) + 50.0, height: frame.size.height)
        self.addSubview(guideScrollView)
        

//        skipButton.isHidden = isHiddenSkipBtn
        skipButton.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        skipButton.layer.cornerRadius = 18
        skipButton.layer.masksToBounds = true
        self.addSubview(skipButton)
        skipButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(36)
            make.top.equalTo(39)
            make.right.equalTo(-32)
        }
        skipButton.addTarget(self, action: #selector(skipBtnClicked), for: .touchUpInside)
        
        guard imageArray != nil, imageArray?.count ?? 0 > 0 else { return }
        for index in 0..<(imageArray?.count ?? 1) {
            let name        = imageArray![index]
            let imageFrame  = CGRect.init(x: size.width * CGFloat(index), y: 0.0, width: size.width, height: size.height)

            var view: UIImageView = UIImageView.init(frame: imageFrame)
                view.contentMode = .scaleAspectFill
                view.clipsToBounds = true
            view.image = UIImage.init(named: name)
            
            //添加“立即体验”按钮和登录/注册按钮
            if imageArray?.last == name {

            }
            guideScrollView.addSubview(view)
        }
        
        self.addSubview(mainTitle)
        mainTitle.text = mainTitleArr[0]
        mainTitle.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-142)
        }
        
        self.addSubview(subTitle)
        subTitle.text = subTitleArr[0]
        subTitle.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-105)
        }
        
        logtinButton.addTarget(self, action: #selector(skipBtnClicked), for: .touchUpInside)
        self.addSubview(logtinButton)
        logtinButton.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-46)
        }
        logtinButton.isHidden = true
        
        self.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-54)
        }
    }
    
    // MARK: - actions
    private func removeGuideViewFromSupview() {
        UIView.animate(withDuration: 1.0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    /// 点击“跳过”按钮事件，立即退出引导页
    @objc private func skipBtnClicked() {
        if self.startCompletion != nil {
            self.startCompletion!()
        }
        let isFristKey = DefaultsKey<String?>(isFristKeyString)
        Defaults[key: isFristKey] = "false"
        self.removeGuideViewFromSupview()
    }
    
    
    /// 作为 pod 第三方库取图片资源
    ///
    /// - Parameter name: 图片名
    /// - Returns: 图片
    private func imageFromBundle(name: String) -> UIImage {
        let podBundle = Bundle(for: self.classForCoder)
        let bundleURL = podBundle.url(forResource: "GuideImage", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)
        let image = UIImage(named: String(name), in: bundle, compatibleWith: nil)
        return image!
    }
    
    /// 根据UIColor创建UIImage
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 图片大小
    /// - Returns: 图片
    private func creatImage(color: UIColor, size: CGSize = CGSize.init(width: 100, height: 100)) -> UIImage {
        let size = (size == CGSize.zero ? CGSize(width: 100, height: 100): size)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

// MARK: - <UIScrollViewDelegate>
extension GuidePageView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isSlipIntoHomeView else { return }
        guard isSliping == false else { return }
        
        let totalWidth = UIScreen.main.bounds.size.width * CGFloat((imageArray?.count ?? 1) - 1)
        let offsetX = scrollView.contentOffset.x - totalWidth
        if offsetX > 30 {
            isSliping = true
            UIView.animate(withDuration: 1.0, animations: {
                self.guideScrollView.alpha = 0.0
                var frame = self.guideScrollView.frame
                frame.origin.x = -UIScreen.main.bounds.size.width
                self.guideScrollView.frame = frame
            }) { (_) in
                self.isSliping = false
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > (scrollView.bounds.size.width * 2 + 20) {
            self.removeGuideViewFromSupview()
            return
        }
        
        let page: Int = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        // 设置指示器
        let name = "guide_bot\(page+1)"
        self.pageControl.image = UIImage.init(named: name)
        
        self.skipButton.isHidden = page == 2
        logtinButton.isHidden = page != 2
        pageControl.isHidden = page == 2
        if page < 3 {
            self.mainTitle.text = mainTitleArr[page]
            self.subTitle.text = subTitleArr[page]
        }
        
    }
}

