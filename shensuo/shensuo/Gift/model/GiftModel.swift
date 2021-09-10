//
//  GiftModel.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/5/25.
//

import UIKit
import KakaJSON

struct GiftModel : Convertible {

    //    @Column(columnDefinition = "varchar(20) not null comment '礼物名称'")
    //    private String name;
        let id: String? = ""
//    @Column(columnDefinition = "varchar(20) not null comment '礼物名称'")
//    private String name;
    let name: String? = ""
//    @Column(columnDefinition = "bigint not null comment '美币'")
//    private Long points;
    let points: String? = ""
//    @Column(columnDefinition = "varchar(300) not null comment '图片地址'")
//    private String image;
    let image: String? = ""
//    @Column(columnDefinition = "varchar(300) comment '动画文件地址'")
//    private String dynamicImage;
    let dynamicImage: String? = ""

}
