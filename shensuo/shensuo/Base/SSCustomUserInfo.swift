//
//  SSCustomUserInfo.swift
//  shensuo
//
//  Created by  yang on 2021/6/22.
//

import UIKit
//轻点事件

public func customTap(target: Any, action: Selector,view: UIView){
    
    let tap = UITapGestureRecognizer.init(target: target, action: action)
    view.addGestureRecognizer(tap)

}

func heightWithFont(font : UIFont = UIFont.systemFont(ofSize: 18), fixedWidth : CGFloat,str: String) -> CGFloat {
        
    guard str.length > 0 && fixedWidth > 0 else {
            
            return 0
        }
        
        let size = CGSize(width:fixedWidth, height:CGFloat.greatestFiniteMagnitude)
    let rect = str.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context:nil)
        
        return rect.size.height
    }

func labelHeightLineSpac(font : UIFont = UIFont.systemFont(ofSize: 18), fixedWidth : CGFloat,str: String,lineSpec: CGFloat = 2) -> CGFloat{
    
    var attrButes:[NSAttributedString.Key : Any]! = nil;
    let paraph = NSMutableParagraphStyle()
    paraph.lineSpacing = lineSpec
    attrButes = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:paraph]
      
    let size:CGRect = str.boundingRect(with: CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrButes, context: nil)
    return size.height
}

func labelWidthFont(font : UIFont = UIFont.systemFont(ofSize: 18), fixedWidth : CGFloat,str: String) -> CGFloat{
    
    var attrButes:[NSAttributedString.Key : Any]! = nil;
    let paraph = NSMutableParagraphStyle()
    attrButes = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:paraph]
      
    let size:CGRect = str.boundingRect(with: CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrButes, context: nil)
    return size.width
}

class SSCustomUserInfo: NSObject {

  
    
}
