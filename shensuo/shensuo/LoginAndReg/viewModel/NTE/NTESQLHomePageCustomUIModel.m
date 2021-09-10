//
//  NTESQLHomePageCustomUIModel.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/3/19.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESQLHomePageCustomUIModel.h"
#import "UIColor+NTESQuickPass.h"
#import "NTESQPDemoDefines.h"
#import "NTESQLNavigationView.h"
#import "NTESToastView.h"

@implementation NTESQLHomePageCustomUIModel

+ (instancetype)getInstance {
    return [[NTESQLHomePageCustomUIModel alloc] init];
}

- (NTESQuickLoginModel *)configCustomUIModel:(NSInteger)popType
                                    withType:(NSInteger)portraitType
                             faceOrientation:(UIInterfaceOrientation)faceOrientation {
    
    NTESQuickLoginModel *model = [[NTESQuickLoginModel alloc] init];
    model.presentDirectionType = NTESPresentDirectionPush;
    //    model.backgroundColor = [UIColor whiteColor];
    model.navTextColor = [UIColor blueColor];
    model.navBgColor = [UIColor whiteColor];
    model.bgImage = [UIImage imageNamed:@"begin_bg_gray"];
    model.faceOrientation = faceOrientation;
    model.navBarHidden = YES;
    model.navTextHidden = true;
    model.authWindowPop = NTESAuthWindowPopFullScreen;
    model.popBackgroundColor = [UIColor redColor];
    
    /// logo
    model.logoImg = [UIImage imageNamed:@"login_logo-1"];
    model.logoWidth = 52;
    model.logoHeight = 52;
    model.logoHidden = true;
    
    /// 手机号码
    model.numberFont = [UIFont boldSystemFontOfSize:32];
    model.numberOffsetX = 0;
    model.numberHeight = 45;
    
    ///  品牌
    model.brandFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    model.brandWidth = 200;
    model.brandBackgroundColor = [UIColor clearColor];
    model.brandHeight = 20;
    model.brandOffsetX = 0;
    
    /// 登录按钮
    model.logBtnTextFont = [UIFont boldSystemFontOfSize:21];
    //    model.logBtnEnableImg = [UIImage imageNamed:@"logo"];
    model.logBtnTextColor = [UIColor whiteColor];
    model.logBtnText = @"一键登录";
    model.logBtnRadius = 30;
    model.logBtnHeight = 60;

    /// 隐私协议
    model.appPrivacyText = @"同意《默认》和《全民形体用户协议》《隐私政策》并获得本机号码";
    /**导航栏标题*/
    model.navText = @"";
//    model.navTextColor = [UIColor clearColor];
    model.appFPrivacyText = @"《全民形体用户协议》";
    model.appPrivacyTitleText =  @"《全民形体用户协议》";
    model.appSPrivacyText = @"《隐私政策》";
    model.appSPrivacyTitleText =  @"《隐私政策》";
    model.appFPrivacyURL = @"https://www.quanminxingti.com/h5/#/userAgreement?hidden=true";
    model.appSPrivacyURL = @"https://www.quanminxingti.com/h5/#/privacyPolicy?hidden=true";
    model.shouldHiddenPrivacyMarks = false;
    model.uncheckedImg = [[UIImage imageNamed:@"login_dis"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    model.checkedImg = [[UIImage imageNamed:@"login_agree"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    model.checkboxWH = 16;
    model.privacyState = YES;
    model.isOpenSwipeGesture = NO;
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    model.closePopImg = [UIImage imageNamed:@"ic_close"];
    model.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    model.appPrivacyWordSpacing = 1;
    model.appPrivacyLineSpacing = 5;
    model.progressColor = [UIColor whiteColor];
    model.protocolColor = [[UIColor alloc] initWithRed:1 green:117/255.0 blue:23/255.0 alpha:1];
    
    model.logBtnEnableImg = [UIImage imageNamed:@"login_btn_bg"];
    model.checkedSelected = false;
    if (@available(iOS 13.0, *)) {
        model.statusBarStyle = UIStatusBarStyleDarkContent;
        //        model.statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        model.statusBarStyle = UIStatusBarStyleDefault;
        //        model.statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    model.authWindowPop = NTESAuthWindowPopFullScreen;
    model.numberColor = [UIColor whiteColor];
    model.brandColor = [UIColor whiteColor];
    
    
    /// 全屏、竖屏模式
    model.logoOffsetTopY = 148;
    model.numberOffsetTopY = SCREEN_HEIGHT - 340;
    model.brandOffsetTopY = SCREEN_HEIGHT - 297;
    model.logBtnOffsetTopY = SCREEN_HEIGHT - 256;
    model.appPrivacyOriginBottomMargin = 32;
    model.logBtnOriginLeft = 40;
    model.logBtnOriginRight = 40;
    model.appPrivacyOriginLeftMargin = 53;
    model.appPrivacyOriginRightMargin = 32;
    model.privacyFont = [UIFont systemFontOfSize:14];
    
    CGFloat navHeight;
    
    model.faceOrientation = faceOrientation;
    navHeight = (IS_IPHONEX_SET ? 44.f : 20.f) + 44;
    
    model.isRepeatPlay = YES;
    model.customViewBlock = ^(UIView * _Nullable customView) {
        
        //        customView.backgroundColor = [UIColor blackColor];
        UILabel *otherLabel = [[UILabel alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
        [otherLabel addGestureRecognizer:tap];
        otherLabel.userInteractionEnabled = YES;
        otherLabel.text = @"手机验证码登录";
        otherLabel.textAlignment = NSTextAlignmentCenter;
        otherLabel.textColor = [UIColor ntes_colorWithHexString:@"#324DFF"];
        otherLabel.font = [UIFont systemFontOfSize:18];
        [customView addSubview:otherLabel];
        
        otherLabel.textColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
        
        /// 全屏、竖屏模式
        [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(customView);
            make.bottom.mas_equalTo(-154);
            make.height.mas_equalTo(16);
        }];
        [otherLabel sizeToFit];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor whiteColor];
        [customView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(otherLabel);
                    make.height.mas_equalTo(1);
                    make.bottom.equalTo(otherLabel).offset(3);
        }];
        
        UILabel *mainTitleLabel = [[UILabel alloc] init];
        mainTitleLabel.numberOfLines = 0;
        [customView addSubview:mainTitleLabel];

        mainTitleLabel.text = @"回归正确体态，\n让你的身体和生活，\n享受真正的舒适。";
        mainTitleLabel.font = [UIFont boldSystemFontOfSize:36];
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 16 - (mainTitleLabel.font.lineHeight - mainTitleLabel.font.pointSize);
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        mainTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:mainTitleLabel.text attributes:attributes];
        mainTitleLabel.textColor = [UIColor whiteColor];
        mainTitleLabel.textAlignment = NSTextAlignmentLeft;
        
        [mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(32);
            make.height.mas_equalTo(165);
            make.right.mas_equalTo(-32);
            make.bottom.mas_equalTo(-440);
        }];
        
        UILabel *subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.numberOfLines = 0;
        [customView addSubview:subTitleLabel];

        subTitleLabel.text = @"学形体，用全民形体。";
        subTitleLabel.font = [UIFont systemFontOfSize:21];
        subTitleLabel.textColor = [UIColor whiteColor];
        subTitleLabel.textAlignment = NSTextAlignmentLeft;
        
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(32);
            make.height.mas_equalTo(29);
            make.right.mas_equalTo(-32);
            make.top.equalTo(mainTitleLabel.mas_bottom).offset(19);
        }];
        
        UILabel *loginTitleLabel = [[UILabel alloc] init];
        loginTitleLabel.numberOfLines = 0;
        [customView addSubview:loginTitleLabel];

        loginTitleLabel.text = @"一键登录";
        loginTitleLabel.font = [UIFont boldSystemFontOfSize:21];
        loginTitleLabel.textColor = [UIColor whiteColor];
        loginTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        [loginTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(32);
            make.height.mas_equalTo(29);
            make.right.mas_equalTo(-32);
            make.bottom.mas_equalTo(-212);
        }];
        
        
        UIButton *numBtn = [UIButton new];
        [numBtn setTitle:@"账户登录" forState:UIControlStateNormal];
        [numBtn setTitleColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1] forState:UIControlStateNormal];
        numBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [customView addSubview:numBtn];
        [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(70);
                    make.height.mas_equalTo(22);
                    make.right.mas_equalTo(-16);
                    make.top.mas_equalTo(53);
        }];
        
        [numBtn addTarget:self action:@selector(btnTapped) forControlEvents:UIControlEventTouchUpInside];
        
//        UIButton *userBtn = [UIButton new];
//        [userBtn setTitle:@"游客登录" forState:UIControlStateNormal];
//        [userBtn setTitleColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1] forState:UIControlStateNormal];
//        userBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [customView addSubview:userBtn];
//        [userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.width.mas_equalTo(70);
//                    make.height.mas_equalTo(22);
//                    make.left.mas_equalTo(16);
//                    make.top.mas_equalTo(53);
//        }];
//        
//        [userBtn addTarget:self action:@selector(userBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    };
    
    model.backActionBlock = ^{
        NSLog(@"backAction===返回按钮点击");
    };
    
    model.loginActionBlock = ^(BOOL isChecked) {
        NSLog(@"loginAction");
        if (isChecked) {
            NSLog(@"loginAction====复选框已勾选");
        } else {
            NSLog(@"loginAction====复选框未勾选");
        }
    };
    
    model.checkActionBlock = ^(BOOL isChecked) {
        NSLog(@"checkAction");
        if (isChecked) {
            NSLog(@"checkAction===选中复选框");
        } else {
            NSLog(@"checkAction===取消复选框");
        }
    };
    
    model.privacyActionBlock = ^(int privacyType) {
        if (privacyType == 0) {
            NSLog(@"点击默认协议");
        } else if (privacyType == 1) {
            NSLog(@"点击客户第1个协议");
        } else if (privacyType == 2) {
            NSLog(@"点击客户第2个协议");
        }
        NSLog(@"privacyAction");
    };
    model.privacyColor = [UIColor whiteColor];
    //    model.statusBarHidden = YES;
    
    
    return model;
}

- (void)labelTapped {
    [[NTESQuickLoginManager sharedInstance] closeAuthController:^{
        
    }];;
}

- (void)btnTapped {
    NSNotification *notification =[NSNotification notificationWithName:@"pushToPassNotification" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)userBtnTapped {
    NSNotification *notification =[NSNotification notificationWithName:@"pushToUserDefultNotification" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end

