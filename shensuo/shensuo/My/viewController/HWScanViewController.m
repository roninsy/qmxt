//
//  HWScanViewController.m
//  HWScanTest
//
//  Created by sxmaps_w on 2017/2/18.
//  Copyright © 2017年 hero_wqb. All rights reserved.
//

#import "HWScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>
#import "shensuo-Swift.h"

#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height

@interface HWScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, weak) UIImageView *line;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) BOOL isLight;
@end

@implementation HWScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isLight = NO;
    //创建控件
    [self creatControl];
    
    //设置参数
    [self setupCamera];
    //初始化信息
    [self initInfo];
    //添加定时器
    [self addTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}



- (void)initInfo
{
//    //背景色
//    self.view.backgroundColor = [UIColor blackColor];
//
//    //导航标题
//    self.navigationItem.title = @"二维码/条形码";
//
//    //导航右侧相册按钮
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(photoBtnOnClick)];
    
    UIView *topV = [[UIView alloc] init];
    [self.view addSubview:topV];
    topV.backgroundColor = [UIColor clearColor];
    CGFloat NavStatusHei = [UIApplication sharedApplication].windows[0].safeAreaInsets.bottom > 0 ? 44 : 20;
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(NavStatusHei);
    }];
    UIButton *backBtn = [[UIButton alloc] init];
    [topV addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"my_backimage"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents: UIControlEventTouchUpInside];
  

    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(topV);
        make.width.height.mas_equalTo(48);
        make.top.equalTo(topV).offset(2);
        
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
    [topV addSubview:titleL];
    titleL.text = @"扫一扫";
    titleL.font = [UIFont boldSystemFontOfSize:18];
    titleL.textColor = [UIColor whiteColor];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(topV);
        
    }];
    
    
}

-(void)backBtnAction{
    
    [self stopScanning];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatControl
{
    CGFloat scanW = KMainW * 0.65;
    CGFloat padding = 10.0f;
    CGFloat labelH = 20.0f;
    CGFloat cornerW = 26.0f;
    CGFloat marginX = (KMainW - scanW) * 0.5;
    CGFloat marginY = (KMainH - scanW - padding - labelH) * 0.5;
    
    //遮盖视图
    for (int i = 0; i < 4; i++) {
        UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, (marginY + scanW) * i - 70, KMainW, marginY + (padding + labelH) * i)];
        if (i == 2) {
            cover.frame = CGRectMake((marginX + scanW) * (i - 2), marginY - 70, marginX, scanW);

        }else if(i == 3){
            
            cover.frame = CGRectMake((marginX + scanW) * (i - 2), marginY - 70, marginX, scanW);

        }else if(i == 1){
            
            cover.frame = CGRectMake(0, (marginY + scanW) * i - 70, KMainW, marginY + (padding + labelH) * i + 70);

        }
        cover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [self.view addSubview:cover];
    }
    
    //扫描视图
    UIView *scanView = [[UIView alloc] initWithFrame:CGRectMake(marginX, marginY - 70, scanW, scanW)];
    [self.view addSubview:scanView];
    
    //扫描线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scanW, 2)];
    [self drawLineForImageView:line];
    [scanView addSubview:line];
    self.line = line;
    
    //边框
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scanW, scanW)];
    borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    borderView.layer.borderWidth = 1.0f;
    [scanView addSubview:borderView];
    
    //扫描视图四个角
    for (int i = 0; i < 4; i++) {
        CGFloat imgViewX = (scanW - cornerW) * (i % 2);
        CGFloat imgViewY = (scanW - cornerW) * (i / 2);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgViewX, imgViewY, cornerW, cornerW)];
        if (i == 0 || i == 1) {
            imgView.transform = CGAffineTransformRotate(imgView.transform, M_PI_2 * i);
        }else {
            imgView.transform = CGAffineTransformRotate(imgView.transform, - M_PI_2 * (i - 1));
        }
        [self drawImageForImageView:imgView];
        [scanView addSubview:imgView];
    }
    
    
    
    //提示标签
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((KMainW - 120)/2, CGRectGetMaxY(scanView.frame) + padding, 120, labelH)];
    label.text = @"请扫描二维码";
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    [self setBtn:[UIImage imageNamed:@"icon-xiangce"] btnStr:@"相册" compareView:label btnAction:@selector(photoBtnOnClick) index:1];
    [self setBtn:[UIImage imageNamed:@"icon-guanbi"] btnStr:@"轻触照亮" compareView:label btnAction:@selector(lightBtnOnClick) index:2];
}



-(void)setBtn: (UIImage *)btnImg btnStr: (NSString *)btnStr compareView: (UIView *)compareView btnAction: (SEL)btnAction index: (int)index{
    
    UIButton *btn = [[UIButton alloc] init];
    [self.view addSubview:btn];
    [btn setImage:btnImg forState:UIControlStateNormal];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(compareView).offset(46);
        if (index == 1) {
            make.trailing.equalTo(compareView.mas_leading).offset(6);
        }else{
            make.leading.equalTo(compareView.mas_trailing).offset(-6);
        }
        make.width.height.mas_equalTo(56);
    }];
    
    [btn addTarget:self action:btnAction forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleL = [[UILabel alloc] init];
    [self.view addSubview:titleL];
    titleL.text = btnStr;
    titleL.font = [UIFont systemFontOfSize:14];
    titleL.textColor = [UIColor whiteColor];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(btn.mas_bottom).offset(6);
        make.centerX.equalTo(btn);
    }];
    
    if (index == 1) {
        
        UIButton * btn1 = [[UIButton alloc] init];
        [self.view addSubview:btn1];
        btn1.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn1 setTitle:@"我的二维码" forState:UIControlStateNormal];
        btn1.layer.cornerRadius = 22.5;
        btn1.layer.masksToBounds = YES;
        btn1.layer.borderColor = [UIColor whiteColor].CGColor;
        btn1.layer.borderWidth = 0.5;
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.view);
            make.top.equalTo(btn.mas_bottom).offset(60);
            make.height.mas_offset(45);
            make.width.mas_equalTo(120);
        }];
        [btn1 addTarget:self action:@selector(jumpActiom) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)jumpActiom{
    
    ShareVC *vc = [[ShareVC alloc] init];
    [vc setupMainView];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)setupCamera
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //初始化相机设备
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
 
        //初始化输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
        
        //初始化输出流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        //设置代理，主线程刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        _session = [[AVCaptureSession alloc] init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([_session canAddInput:input]) [_session addInput:input];
        if ([_session canAddOutput:output]) [_session addOutput:output];
        
        //条码类型（二维码/条形码）
        output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil];
        
        //更新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            _preview.frame = CGRectMake(0, 0, KMainW, KMainH);
            [self.view.layer insertSublayer:_preview atIndex:0];
            [_session startRunning];
        });
    });
}

- (void)addTimer
{
    _distance = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction
{
    if (_distance++ > KMainW * 0.65) _distance = 0;
    _line.frame = CGRectMake(0, _distance, KMainW * 0.65, 2);
}

- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

//照明按钮点击事件
- (void)lightBtnOnClick
{
    //判断是否有闪光灯
    if (![_device hasTorch]) {
        [self showAlertWithTitle:@"当前设备没有闪光灯，无法开启照明功能" message:nil sureHandler:nil cancelHandler:nil];
        return;
    }
    
    self.isLight = !self.isLight;
//    btn.selected = !btn.selected;
    
    [_device lockForConfiguration:nil];
    if (self.isLight) {
        [_device setTorchMode:AVCaptureTorchModeOn];
    }else {
        [_device setTorchMode:AVCaptureTorchModeOff];
    }
    [_device unlockForConfiguration];
}

//进入相册
- (void)photoBtnOnClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
    }else {
        [self showAlertWithTitle:@"当前设备不支持访问相册" message:nil sureHandler:nil cancelHandler:nil];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描完成
    if ([metadataObjects count] > 0) {
        //停止扫描
        [self stopScanning];
//        //显示结果
//        [self showAlertWithTitle:@"扫描结果" message:[[metadataObjects firstObject] stringValue] sureHandler:nil cancelHandler:nil];
        NSString *res = [[metadataObjects firstObject] stringValue];
        NSArray *arr = [res componentsSeparatedByString:@"&userId="];
        if (arr.count > 1) {
            SSPersionDetailViewController *vc = [SSPersionDetailViewController new];
            NSString *cid = arr[1];
            vc.cid = cid;
            [self.navigationController pushViewController:vc animated:true];
        }
    }
}

- (void)stopScanning
{
    [_session stopRunning];
    _session = nil;
    [_preview removeFromSuperlayer];
    [self removeTimer];
}

#pragma mark - UIImagePickerControllrDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        //获取相册图片
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        //识别图片
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];

        //识别结果
        if (features.count > 0) {
            NSString *res = [[features firstObject] messageString];
            NSArray *arr = [res componentsSeparatedByString:@"&userId="];
            if (arr.count > 1) {
                SSPersionDetailViewController *vc = [SSPersionDetailViewController new];
                NSString *cid = arr[1];
                vc.cid = cid;
                [self.navigationController pushViewController:vc animated:true];
            }
//            [self showAlertWithTitle:@"扫描结果" message:[[features firstObject] messageString] sureHandler:nil cancelHandler:nil];
            
        }else{
            [self showAlertWithTitle:@"没有识别到二维码或条形码" message:nil sureHandler:nil cancelHandler:nil];
        }
    }];
}

//提示弹窗
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message sureHandler:(void (^)())sureHandler cancelHandler:(void (^)())cancelHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:sureHandler];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancelHandler];
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//绘制角图片
- (void)drawImageForImageView:(UIImageView *)imageView
{
    UIGraphicsBeginImageContext(imageView.bounds.size);

    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条宽度
    CGContextSetLineWidth(context, 6.0f);
    //设置颜色
    CGContextSetStrokeColorWithColor(context, [[UIColor orangeColor] CGColor]);
    //路径
    CGContextBeginPath(context);
    //设置起点坐标
    CGContextMoveToPoint(context, 0, imageView.bounds.size.height);
    //设置下一个点坐标
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, imageView.bounds.size.width, 0);
    //渲染，连接起点和下一个坐标点
    CGContextStrokePath(context);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

//绘制线图片
- (void)drawLineForImageView:(UIImageView *)imageView
{
    CGSize size = imageView.bounds.size;
    UIGraphicsBeginImageContext(size);

    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建一个颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //设置开始颜色
    const CGFloat *startColorComponents = CGColorGetComponents([[UIColor greenColor] CGColor]);
    //设置结束颜色
    const CGFloat *endColorComponents = CGColorGetComponents([[UIColor whiteColor] CGColor]);
    //颜色分量的强度值数组
    CGFloat components[8] = {startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]
    };
    //渐变系数数组
    CGFloat locations[] = {0.0, 1.0};
    //创建渐变对象
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    //绘制渐变
    CGContextDrawRadialGradient(context, gradient, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.25, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.5, kCGGradientDrawsBeforeStartLocation);
    //释放
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
