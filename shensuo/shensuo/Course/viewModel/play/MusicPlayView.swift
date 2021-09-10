//
//  MusicPlayView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/7/8.
//
///音频播放视图

import UIKit

class MusicPlayView: UIView {
    
    var startAnimate = false
    var model : CourseStepListModel? = nil{
        didSet{
            if model != nil {
                self.headImg.kf.setImage(with: URL.init(string: model?.headerImage ?? ""),placeholder: UIImage.init(named: "normal_img_zfx"))
                self.titleLab.text = model?.title
                self.titleLab.sizeToFit()
                self.letMeGo()
            }
        }
    }
    
    /// 0 大屏 1 小屏
    var type = 0
    
    let bgView = UIImageView.initWithName(imgName: "play_music_main_bg")
    
    let grayBg = UIView()
    let headBg = UIImageView.initWithName(imgName: "play_music_black_bg")
    
    let headImg = UIImageView()
    
    ///白色指针
    let zhenImg = UIImageView.initWithName(imgName: "play_music_zhen")
    
    let titleLab = UILabel.initSomeThing(title: "", titleColor: .white, font: .SemiboldFont(size: 28), ali: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///开启动画
    func letMeGo(){
        if !startAnimate {
            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                DispatchQueue.main.async {
                    //连续旋转
                    UIView.animate(withDuration: 0.1) {
                        self.headBg.transform = self.headBg.transform.rotated(by: -(.pi / 36))
                    }
                }
            })
        }
    }
    
    func setupUI(){
        grayBg.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 0.1)
        self.addSubview(grayBg)
        self.addSubview(headBg)
        headBg.addSubview(headImg)
        self.addSubview(zhenImg)
        self.addSubview(titleLab)
        titleLab.numberOfLines = 0
        if type == 0 {
            grayBg.layer.cornerRadius = 190 / 2
            grayBg.layer.masksToBounds = true
            
            grayBg.snp.makeConstraints { make in
                make.width.height.equalTo(190)
                make.centerY.equalToSuperview()
                make.left.equalTo(72)
            }
            
            headBg.snp.makeConstraints { make in
                make.edges.equalTo(grayBg)
            }
            
            headImg.contentMode = .scaleAspectFill
            headImg.layer.cornerRadius = 115 / 2
            headImg.layer.masksToBounds = true
            headImg.snp.makeConstraints { make in
                make.width.height.equalTo(115)
                make.center.equalTo(headBg)
            }
            
            zhenImg.snp.makeConstraints { make in
                make.width.equalTo(55)
                make.height.equalTo(84)
                make.left.equalTo(157)
                make.top.equalTo(headBg).offset(-41)
            }
            
            titleLab.snp.makeConstraints { make in
                make.left.equalTo(headBg.snp.right).offset(24)
                make.right.equalTo(-175)
                make.centerY.equalTo(headBg)
            }
        }else{
            grayBg.layer.cornerRadius = 100 / 2
            grayBg.layer.masksToBounds = true
            
            grayBg.snp.makeConstraints { make in
                make.width.height.equalTo(100)
                make.top.equalTo(67)
                make.left.equalTo(20)
            }
            
            headBg.snp.makeConstraints { make in
                make.edges.equalTo(grayBg)
            }
            
            headImg.contentMode = .scaleAspectFill
            headImg.layer.cornerRadius = 63 / 2
            headImg.layer.masksToBounds = true
            headImg.snp.makeConstraints { make in
                make.width.height.equalTo(63)
                make.center.equalTo(headBg)
            }
            
            zhenImg.snp.makeConstraints { make in
                make.width.equalTo(34)
                make.height.equalTo(54)
                make.left.equalTo(70)
                make.top.equalTo(40)
            }
            
            titleLab.font = .boldSystemFont(ofSize: 16)
            titleLab.snp.makeConstraints { make in
                make.left.equalTo(headBg.snp.right).offset(16)
                make.right.equalTo(-16)
                make.centerY.equalTo(headBg)
            }
        }
    }
}
