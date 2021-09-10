//
//  UIViewController+Extension.swift
//  MuslimUmmah
//
//  Created by RSY on 2019/6/12.
//  Copyright © 2019 com.advance. All rights reserved.
//

import Foundation

// MARK: - UIViewController 扩展
extension UIViewController {
    
    /// 添加子视图控制器，并将子视图控制器的view视图添加到指定目标视图中。
    ///
    /// - Parameters:
    ///   - childController: 子视图控制器
    ///   - toTargetView: 指定目标视图，默认为图控制器的view视图
    ///   - useAutoLayout: 是否使用自动布局，默认 false
    func addChild·X(_ childController: UIViewController, toTargetView: UIView? = .none, useAutoLayout: Bool = false) {
        let superView: UIView = toTargetView ?? view
        let subView: UIView = childController.view
        self.addChild(childController)
//        childController.beginAppearanceTransition(true, animated: false)
        superView.addSubview(subView)
        subView.frame = superView.bounds
        if useAutoLayout {
            superView.addConstraints(
                [NSLayoutConstraint(item: subView, attribute: .width, relatedBy: .equal, toItem: superView, attribute: .width, multiplier: 1, constant: 0),
                 NSLayoutConstraint(item: subView, attribute: .height, relatedBy: .equal, toItem: superView, attribute: .height, multiplier: 1, constant: 0),
                 NSLayoutConstraint(item: subView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1, constant: 0),
                 NSLayoutConstraint(item: subView, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1, constant: 0)])
        }
//        childController.endAppearanceTransition()
        childController.didMove(toParent: self)
    }
    
    /// 将试图控制器从父视图控制器中删除，同时，其view视图也将从该视图的父视图中删除。
    func removeFromParent·X() {
        self.willMove(toParent: nil)
//        self.beginAppearanceTransition(false, animated: false)
        self.view.removeFromSuperview()
//        self.endAppearanceTransition()
        self.removeFromParent()
    }
    
    /// Parent of the view controller that is directly managed by the navigation controller.
    ///
    /// If current view controller's parent is the navigation controller, then this variable
    /// return itself.
    var parentInNavigationStack: UIViewController? {
        guard let navigationController = navigationController else { return nil }
        var controller: UIViewController? = self
        var parent: UIViewController? = controller?.parent
        while parent != nil {
            if parent == navigationController {
                return controller
            }
            
            controller = parent
            parent = controller?.parent
        }
        return nil
    }
    
}
