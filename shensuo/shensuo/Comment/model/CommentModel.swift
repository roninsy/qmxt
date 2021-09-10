//
//  CommentModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/4/26.
//

import UIKit
import KakaJSON

///评论model
struct CommentModel : Convertible {
    var isShowMore = false
    var needShowMore = false
    var normalHei = 16 + 35 - 5 + 12 + 17 + 24
    var cellHei: Int? = 0
//    let sourceId: String? = ""
//    let image: String? = ""

    var imgArr : [String] = NSMutableArray() as! [String]
    
//    headImage    string
//    '评论所属用户头像'
    let headImage: String? = ""
//    nickName    string
//    '评论所属用户昵称'
    let nickName: String? = ""
    //    verify是否认证用户 0未认证 1个人认证 2企业认证
    let verify: Int? = 0
//    content    string
    let content: String? = ""
//    courseId    integer($int64)
    let courseId: Int? = 0
//    createdTime    string($date-time)
    let createdTime: String? = ""
//    deleted    boolean
    let deleted : Bool? = false
//    id    integer($int64)
    let id: String? = ""
//    image01    string
    let image01: String? = ""
//    image02    string
    let image02: String? = ""
//    image03    string
    let image03: String? = ""
//    image04    string
    let image04: String? = ""
//    image05    string
    let image05: String? = ""
//    image06    string
    let image06: String? = ""
//    image07    string
    let image07: String? = ""
//    image08    string
    let image08: String? = ""
//    image09    string
    let image09: String? = ""
//    replyCount    integer($int64) 回复数量
    let replyCount: Int? = 0
//    replyList    [...]
    var replyList : [ReplyListModel]? = nil
//    userId    integer($int64)
    let userId: String? = ""
    mutating func kj_didConvertToModel(from json: [String : Any]) {
        if (image01?.count ?? 0) > 0 {
            imgArr.append(image01!)
        }
        if (image02?.count ?? 0) > 0 {
            imgArr.append(image02!)
        }
        if (image03?.count ?? 0) > 0 {
            imgArr.append(image03!)
        }
        if (image04?.count ?? 0) > 0 {
            imgArr.append(image04!)
        }
        if (image05?.count ?? 0) > 0 {
            imgArr.append(image05!)
        }
        if (image06?.count ?? 0) > 0 {
            imgArr.append(image06!)
        }
        if (image07?.count ?? 0) > 0 {
            imgArr.append(image07!)
        }
        if (image08?.count ?? 0) > 0 {
            imgArr.append(image08!)
        }
        if (image09?.count ?? 0) > 0 {
            imgArr.append(image09!)
        }
        if (self.replyList?.count ?? 0) > 2{
            self.needShowMore = true
        }
    }
}

///回复model
struct ReplyListModel : Convertible {
    
    var normalHei = 8 + 30 + 2 + 9 + 17 + 24
    var cellHei: Int? = 0
    var imgArr : [String] = NSMutableArray() as! [String]
    
//    verify是否认证用户 0未认证 1个人认证 2企业认证
    let verify: Int? = 0
//    atNickName
    let atNickName: String? = ""
    //    headImage    string
    //    '评论所属用户头像'
        let headImage: String? = ""
    //    nickName    string
    //    '评论所属用户昵称'
        let nickName: String? = ""
//    atUserId    integer($int64)
    let atUserId: Int? = 0
//    commentId    integer($int64)
    let commentId: Int? = 0
//    complainedTimes    integer($int32)
    let complainedTimes: Int? = 0
//    content    string
    let content: String? = ""
//    courseId    integer($int64)
    let courseId: Int? = 0
//    createdTime    string($date-time)
    let createdTime: String? = ""
//    deleted    boolean
    let deleted : Bool? = false
//    id    integer($int64)
    let id: String? = ""
//    image01    string
    let image01: String? = ""
//    image02    string
    let image02: String? = ""
//    image03    string
    let image03: String? = ""
//    image04    string
    let image04: String? = ""
//    image05    string
    let image05: String? = ""
//    image06    string
    let image06: String? = ""
//    image07    string
    let image07: String? = ""
//    image08    string
    let image08: String? = ""
//    image09    string
    let image09: String? = ""
//    replyCount    integer($int64)
    let replyCount: Int? = 0
//    replyList    [...]
//    userId    integer($int64)
    let userId: String? = ""

    mutating func kj_didConvertToModel(from json: [String : Any]) {
        if (image01?.count ?? 0) > 0 {
            imgArr.append(image01!)
        }
        if (image02?.count ?? 0) > 0 {
            imgArr.append(image02!)
        }
        if (image03?.count ?? 0) > 0 {
            imgArr.append(image03!)
        }
        if (image04?.count ?? 0) > 0 {
            imgArr.append(image04!)
        }
        if (image05?.count ?? 0) > 0 {
            imgArr.append(image05!)
        }
        if (image06?.count ?? 0) > 0 {
            imgArr.append(image06!)
        }
        if (image07?.count ?? 0) > 0 {
            imgArr.append(image07!)
        }
        if (image08?.count ?? 0) > 0 {
            imgArr.append(image08!)
        }
        if (image09?.count ?? 0) > 0 {
            imgArr.append(image09!)
        }
    }
}
