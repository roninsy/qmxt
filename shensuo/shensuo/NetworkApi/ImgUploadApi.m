//
//  ImgUploadApi.m
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/24.
//

#import "ImgUploadApi.h"
#import <UIKit/UIKit.h>



@implementation ImgUploadApi

- (void)uploadImg:(UIImage *)img successBlock:(nonnull successBlock)sblock faildBlock:(nonnull falidBlock)fBlock {
    
    NSString *url = @"oss-accelerate.aliyuncs.com";
    OSSStsTokenCredentialProvider *cre = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:self.accessKeyId secretKeyId:self.secretKeyId securityToken:self.securityToken];
    self.client = [[OSSClient alloc] initWithEndpoint:url credentialProvider:cre];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 配置必填字段，其中bucketName为存储空间名称；objectKey等同于objectName，表示将文件上传到OSS时需要指定包含文件后缀在内的完整路径，例如abc/efg/123.jpg。
    put.bucketName = @"qmxt-sh";
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970] * 1000*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    put.objectKey = [NSString stringWithFormat:@"%@.png", timeString];
    
    //    put.uploadingFileURL = [NSURL fileURLWithPath:@"<filepath>"];
    put.uploadingData = UIImagePNGRepresentation(img); // 直接上传NSData
    // 配置可选字段。
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 指定当前上传长度、当前已经上传总长度、待上传的总长度。
        NSLog(@"upload: %lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };

    self.putTask = [self.client putObject:put];
    [self.putTask continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            OSSLogError(@"%@", task.error);
            if (fBlock) {
                fBlock();
            }
        } else {
            OSSPutObjectResult * result = task.result;
            if (sblock) {
                sblock(put.objectKey);
            }
            NSLog(@"Result - requestId: %@, headerFields: %@, servercallback: %@",
                  result.requestId,
                  result.httpResponseHeaderFields,
                  result.serverReturnJsonString);
            
        }
        return nil;
    }];
}

- (void)uploadVideo:(NSURL *)videoUrl successBlock:(successBlock)sblock faildBlock:(falidBlock)fBlock{
    
    NSString *url = @"oss-accelerate.aliyuncs.com";
    OSSStsTokenCredentialProvider *cre = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:self.accessKeyId secretKeyId:self.secretKeyId securityToken:self.securityToken];
    self.client = [[OSSClient alloc] initWithEndpoint:url credentialProvider:cre];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 配置必填字段，其中bucketName为存储空间名称；objectKey等同于objectName，表示将文件上传到OSS时需要指定包含文件后缀在内的完整路径，例如abc/efg/123.jpg。
    put.bucketName = @"qmxt-sh";
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970] * 1000*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    put.objectKey = [NSString stringWithFormat:@"%@.mov", timeString];
    
        put.uploadingFileURL = videoUrl;
    // 配置可选字段。
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 指定当前上传长度、当前已经上传总长度、待上传的总长度。
        NSLog(@"upload: %lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };

    self.putTask = [self.client putObject:put];
    [self.putTask continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            OSSLogError(@"%@", task.error);
            if (fBlock) {
                fBlock();
            }
        } else {
            OSSPutObjectResult * result = task.result;
            if (sblock) {
                sblock(put.objectKey);
            }
            NSLog(@"Result - requestId: %@, headerFields: %@, servercallback: %@",
                  result.requestId,
                  result.httpResponseHeaderFields,
                  result.serverReturnJsonString);
            
        }
        return nil;
    }];
    
}
- (void)showSVGA:(NSString *)name plc:(SVGAPlayer *)play{
    SVGAParser *parser = [[SVGAParser alloc] init];
    play.backgroundColor = UIColor.redColor;
    [parser parseWithNamed:name inBundle:[NSBundle mainBundle] completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            if (videoItem != nil) {
                play.videoItem = videoItem;
                [play startAnimation];
            }
     } failureBlock:^(NSError * _Nonnull error) {
        NSLog(@"err:%@",error);
     }];
    
}
@end


@implementation UITextFieldKeybordDelete

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
     // Drawing code
 }
 */

- (void) deleteBackward{
    [super deleteBackward];
    if (_keyInputDelegate && [_keyInputDelegate respondsToSelector:@selector(deleteBackward)]) {
        [_keyInputDelegate deleteBackward];
    }
}




@end
