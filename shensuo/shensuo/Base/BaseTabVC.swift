//
//  BaseTabVC.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/13.
//

import UIKit
import ESTabBarController_swift

class BaseTabVC: ESTabBarController {
    let course = UINavigationController.init(rootViewController: HomeController.init())
    let scheme = UINavigationController.init(rootViewController: CourseController.init())
    let more = UINavigationController.init(rootViewController: ProjectHomeVC.init())
    let community = UINavigationController.init(rootViewController: SSCommunityViewController.init())
    let mine = UINavigationController.init(rootViewController: SSMyNewViewController.init())
    override func viewDidLoad() {
        
        let item = ESTabBarItem.init(title: "首页", image: UIImage(named: "bottom_home")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "bottom_homesel")?.withRenderingMode(.alwaysOriginal))
        item.badgeColor = .orange
        course.tabBarItem = item
        scheme.tabBarItem = ESTabBarItem.init(title: "课程", image: UIImage(named: "bottom_kecheng")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "bottom_kechengsel")?.withRenderingMode(.alwaysOriginal))
        more.tabBarItem = ESTabBarItem.init(title: "方案", image: UIImage(named: "bottom_fangan")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "bottom_fangansel")?.withRenderingMode(.alwaysOriginal))
        community.tabBarItem = ESTabBarItem.init(title: "社区", image: UIImage(named: "bottom_shequ")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "bottom_shequsel")?.withRenderingMode(.alwaysOriginal))
        mine.tabBarItem = ESTabBarItem.init(title: "我的", image: UIImage(named: "bottom_mine")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "bottom_minesel")?.withRenderingMode(.alwaysOriginal))
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .init(hex: "#FD8024")
        self.viewControllers = [course, scheme, more, community, mine]
    }
}


