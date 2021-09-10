//
//  BananerImageModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/31.
//

import UIKit
import KakaJSON

struct BananerImageModel : Convertible {

//    @Id
//    private Long id;
//
//    @Column(columnDefinition = "datetime not null comment '发布时间'")
//    private Date createdTime;
//
//    @Column(columnDefinition = "varchar(50) not null comment '广告名称'")
//    private String name;
//
//    @Column(columnDefinition = "varchar(200) not null comment '图片地址'")
//    private String image;
//
//    /**
//     * 常量定义 AdConstants
//     */
//    @Column(columnDefinition = "int(3) not null comment '广告类型 1VIP会员、2课程、3方案、4动态、5美丽日记、6美丽相册、7个人主页、" +
//            " 8优质机构榜、9明星导师榜 、10美币任务、11美币魔盒、12发布动态'")
//    private int type;
//
//    @Column(columnDefinition = "bigint comment '内容id'")
//    private Long contentId;
//
//    @Column(columnDefinition = "int(2) not null comment '位置,1首页，2课程首页，3方案首页'")
//    private int position;
//
//    @Column(columnDefinition = "int not null comment '排序'")
//    private int sort;
//
//    @Column(columnDefinition = "bigint not null comment '发布者'")
//    private Long adminId;
//
//    @Column(columnDefinition = "bit(1) not null comment '1上架，0下架'")
//    private boolean onShelves = true;
//
//    @Column(columnDefinition = "bit(1) not null comment '1删除，0正常'")
//    private Boolean deleted =false;
//    adminId    integer($int64)
//    contentId    integer($int64)
    let contentId: String = ""
//    createdTime    string($date-time)
//    deleted    boolean
//    id    integer($int64)
//    image    string
    let image: String? = ""
//    name    string
//    onShelves    boolean
//    position    integer($int32)
//    sort    integer($int32)
//    type    integer($int32)
    let type: Int = -1
    
    let name: String? = ""
    
    let sort: Int = 0
    
    let id: String? = ""
}
