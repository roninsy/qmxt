//
//  WaterFallLayout.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/8/12.
//

import Foundation
import UIKit

class WaterFallLayout: UICollectionViewFlowLayout {
    // item个数
    let itemCount: Int
    // items的布局信息
    var attributeArray: Array<UICollectionViewLayoutAttributes>?
    
    var isSelf = false
    // 实现必要的构造方法
    required init?(coder: NSCoder) {
        itemCount = 0
        super.init(coder: coder)
    }
    
    // 自定义一个初始化构造方法
    init(itemCount: Int,isSelf : Bool) {
        self.itemCount = itemCount
        self.isSelf = isSelf
        super.init()
    }
    
    // 准备方法
    override func prepare() {
        // 调用父类的准备方法
        super.prepare()
        // 设置为竖直布局
        self.scrollDirection = .vertical
        // 初始化数组
        attributeArray = Array<UICollectionViewLayoutAttributes>()
        // 先计算每个item的宽度，默认为两列布局
        let WIDTH = (UIScreen.main.bounds.size.width - 36)/2
        // 定义一个元组表示每一列的动态高度
        var queueHeight:(one: CGFloat, two: CGFloat) = (0,0)
        // 进行循环设置
        for index in 0..<self.itemCount {
            // 设置indexPath，默认一个分区
            let indexPath = IndexPath(item: index, section: 0)
            // 创建布局属性类
            let attris = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            // 随机一个高度在80到90之间的值
            let height: CGFloat = (index == 0 && self.isSelf == true) ? 115 : floor(WIDTH * 1.6)
            // 哪列高度小就把它放那列下面
            // 标记那一列
            var queue = 0
            if queueHeight.one <= queueHeight.two {
                queueHeight.one += (height + self.minimumInteritemSpacing)
                queue = 0
            } else {
                queueHeight.two += (height+self.minimumInteritemSpacing)
                queue = 1
            }
            // 设置item的位置
            let tmpH = queue == 0 ? queueHeight.one-height : queueHeight.two-height
            attris.frame = CGRect(x: (self.minimumInteritemSpacing+WIDTH)*CGFloat(queue), y: CGFloat(tmpH), width: WIDTH, height: CGFloat(height))
            // 添加到数组中
            attributeArray?.append(attris)
        }
        // 以最大一列的高度计算每个item高度的中间值，这样就可以保证滑动范围的正确
        if queueHeight.one <= queueHeight.two {
            self.itemSize = CGSize(width: WIDTH, height: CGFloat(Int(queueHeight.two)*2/self.itemCount)-self.minimumLineSpacing)
        } else {
            self.itemSize = CGSize(width: WIDTH, height: CGFloat(Int(queueHeight.one)*2/self.itemCount)-self.minimumLineSpacing)
        }
    }
    // 将设置好存放每个item的布局信息返回
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributeArray
    }
}
