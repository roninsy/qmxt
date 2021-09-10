//
//  ImgUploadApi.h
//  shensuo
//
//  Created by 陈鸿庆 on 2021/3/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AliyunOSSiOS/OSSService.h>
#import <SVGAPlayer/SVGA.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^successBlock)(NSString *imageUrl);
typedef void(^falidBlock)(void);

@interface ImgUploadApi : NSObject

@property(nonatomic,strong)OSSClient *client;
@property(nonatomic,strong)OSSTask * putTask;

@property (nonatomic, strong) NSString *accessKeyId;
@property (nonatomic, strong) NSString *secretKeyId;
@property (nonatomic, strong) NSString *securityToken;

- (void)uploadImg:(UIImage *)img successBlock:(successBlock)sblock faildBlock:(falidBlock)fBlock;
- (void)uploadVideo:(NSURL *)videoUrl successBlock:(successBlock)sblock faildBlock:(falidBlock)fBlock;
- (void)showSVGA:(NSString *)name plc:(SVGAPlayer *)play;
@end

@protocol keyInputTextFieldDelegate <NSObject>

- (void) deleteBackward;

@end

@interface UITextFieldKeybordDelete : UITextField
@property (nonatomic,weak) id<keyInputTextFieldDelegate>keyInputDelegate;
@end

NS_ASSUME_NONNULL_END
