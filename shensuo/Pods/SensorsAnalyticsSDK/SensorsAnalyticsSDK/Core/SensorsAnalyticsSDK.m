//  SensorsAnalyticsSDK.m
//  SensorsAnalyticsSDK
//
//  Created by 曹犟 on 15/7/1.
//  Copyright © 2015-2020 Sensors Data Co., Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif


#import <Availability.h>
#import <objc/runtime.h>
#include <sys/sysctl.h>
#include <stdlib.h>

#import "SAJSONUtil.h"
#import "SAGzipUtility.h"
#import "SensorsAnalyticsSDK.h"
#import "UIApplication+AutoTrack.h"
#import "UIViewController+AutoTrack.h"
#import "NSObject+DelegateProxy.h"
#import "SASwizzle.h"
#import "NSString+HashCode.h"
#import "SensorsAnalyticsExceptionHandler.h"
#import "SAURLUtils.h"
#import "SAAppExtensionDataManager.h"
#import "SAAutoTrackUtils.h"

#ifndef SENSORS_ANALYTICS_DISABLE_KEYCHAIN
    #import "SAKeyChainItemWrapper.h"
#endif

#import <WebKit/WebKit.h>

#import "SARemoteConfigManager.h"
#import "UIView+AutoTrack.h"
#import "SACommonUtility.h"
#import "SAConstants+Private.h"
#import "SensorsAnalyticsSDK+Private.h"
#import "SAAlertController.h"
#import "SAWeakPropertyContainer.h"
#import "SADateFormatter.h"
#import "SAFileStore.h"
#import "SATrackTimer.h"
#import "SAEventStore.h"
#import "SAHTTPSession.h"
#import "SANetwork.h"
#import "SAReachability.h"
#import "SAEventTracker.h"
#import "SAScriptMessageHandler.h"
#import "WKWebView+SABridge.h"
#import "SAIdentifier.h"
#import "SAPresetProperty.h"
#import "SAValidator.h"
#import "SALog+Private.h"
#import "SAConsoleLogger.h"
#import "SAModuleManager.h"
#import "SAAppLifecycle.h"
#import "SAReferrerManager.h"
#import "SATrackEventObject.h"
#import "SAProfileEventObject.h"
#import "SASuperProperty.h"

#define VERSION @"2.6.4"

void *SensorsAnalyticsQueueTag = &SensorsAnalyticsQueueTag;

static dispatch_once_t sdkInitializeOnceToken;

@implementation SensorsAnalyticsDebugException

@end

@implementation UIImage (SensorsAnalytics)
- (NSString *)sensorsAnalyticsImageName {
    return objc_getAssociatedObject(self, @"sensorsAnalyticsImageName");
}

- (void)setSensorsAnalyticsImageName:(NSString *)sensorsAnalyticsImageName {
    objc_setAssociatedObject(self, @"sensorsAnalyticsImageName", sensorsAnalyticsImageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end

@implementation UIView (SensorsAnalytics)

- (UIViewController *)sensorsAnalyticsViewController {
    return self.sensorsdata_viewController;
}

//viewID
- (NSString *)sensorsAnalyticsViewID {
    return objc_getAssociatedObject(self, @"sensorsAnalyticsViewID");
}

- (void)setSensorsAnalyticsViewID:(NSString *)sensorsAnalyticsViewID {
    objc_setAssociatedObject(self, @"sensorsAnalyticsViewID", sensorsAnalyticsViewID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//ignoreView
- (BOOL)sensorsAnalyticsIgnoreView {
    return [objc_getAssociatedObject(self, @"sensorsAnalyticsIgnoreView") boolValue];
}

- (void)setSensorsAnalyticsIgnoreView:(BOOL)sensorsAnalyticsIgnoreView {
    objc_setAssociatedObject(self, @"sensorsAnalyticsIgnoreView", [NSNumber numberWithBool:sensorsAnalyticsIgnoreView], OBJC_ASSOCIATION_ASSIGN);
}

//afterSendAction
- (BOOL)sensorsAnalyticsAutoTrackAfterSendAction {
    return [objc_getAssociatedObject(self, @"sensorsAnalyticsAutoTrackAfterSendAction") boolValue];
}

- (void)setSensorsAnalyticsAutoTrackAfterSendAction:(BOOL)sensorsAnalyticsAutoTrackAfterSendAction {
    objc_setAssociatedObject(self, @"sensorsAnalyticsAutoTrackAfterSendAction", [NSNumber numberWithBool:sensorsAnalyticsAutoTrackAfterSendAction], OBJC_ASSOCIATION_ASSIGN);
}

//viewProperty
- (NSDictionary *)sensorsAnalyticsViewProperties {
    return objc_getAssociatedObject(self, @"sensorsAnalyticsViewProperties");
}

- (void)setSensorsAnalyticsViewProperties:(NSDictionary *)sensorsAnalyticsViewProperties {
    objc_setAssociatedObject(self, @"sensorsAnalyticsViewProperties", sensorsAnalyticsViewProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<SAUIViewAutoTrackDelegate>)sensorsAnalyticsDelegate {
    SAWeakPropertyContainer *container = objc_getAssociatedObject(self, @"sensorsAnalyticsDelegate");
    return container.weakProperty;
}

- (void)setSensorsAnalyticsDelegate:(id<SAUIViewAutoTrackDelegate>)sensorsAnalyticsDelegate {
    SAWeakPropertyContainer *container = [SAWeakPropertyContainer containerWithWeakProperty:sensorsAnalyticsDelegate];
    objc_setAssociatedObject(self, @"sensorsAnalyticsDelegate", container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end


static SensorsAnalyticsSDK *sharedInstance = nil;

@interface SensorsAnalyticsSDK()

// 在内部，重新声明成可读写的
@property (atomic, strong) SensorsAnalyticsPeople *people;

@property (nonatomic, strong) SANetwork *network;

@property (nonatomic, strong) SAEventTracker *eventTracker;

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) dispatch_queue_t readWriteQueue;

@property (nonatomic, strong) SATrackTimer *trackTimer;

@property (nonatomic, strong) NSRegularExpression *propertiesRegex;

@property (nonatomic, strong) NSTimer *timer;

//用户设置的不被AutoTrack的Controllers
@property (nonatomic, strong) NSMutableArray *ignoredViewControllers;
@property (nonatomic, weak) UIViewController *previousTrackViewController;

@property (nonatomic, strong) NSMutableArray *ignoredViewTypeList;

// 兼容 UA 值打通逻辑，后续废弃 UA 值打通逻辑时可以全部移除
@property (atomic, copy) NSString *userAgent;
@property (nonatomic, copy) NSString *addWebViewUserAgent;

@property (nonatomic, strong) NSMutableSet<NSString *> *trackChannelEventNames;

@property (nonatomic, strong) SAConfigOptions *configOptions;

@property (nonatomic, copy) BOOL (^trackEventCallback)(NSString *, NSMutableDictionary<NSString *, id> *);

@property (nonatomic, strong) NSMutableArray <UIViewController *> *launchedPassivelyControllers;

@property (nonatomic, strong) SAIdentifier *identifier;

@property (nonatomic, strong) SAPresetProperty *presetProperty;

@property (nonatomic, strong) SASuperProperty *superProperty;

@property (atomic, strong) SAConsoleLogger *consoleLogger;

@property (nonatomic, strong) SAAppLifecycle *appLifecycle;

@property (nonatomic, strong) SAReferrerManager *referrerManager;

@end

@implementation SensorsAnalyticsSDK {
    SensorsAnalyticsNetworkType _networkTypePolicy;
}

#pragma mark - Initialization
+ (void)startWithConfigOptions:(SAConfigOptions *)configOptions {
    NSAssert(sensorsdata_is_same_queue(dispatch_get_main_queue()), @"神策 iOS SDK 必须在主线程里进行初始化，否则会引发无法预料的问题（比如丢失 $AppStart 事件）。");
    if (configOptions.enableEncrypt) {
        NSAssert((configOptions.saveSecretKey && configOptions.loadSecretKey) ||
                 (!configOptions.saveSecretKey && !configOptions.loadSecretKey), @"存储公钥和获取公钥的回调需要全部实现或者全部不实现。");
    }
    dispatch_once(&sdkInitializeOnceToken, ^{
        sharedInstance = [[SensorsAnalyticsSDK alloc] initWithConfigOptions:configOptions debugMode:SensorsAnalyticsDebugOff];
        [SAModuleManager startWithConfigOptions:sharedInstance.configOptions debugMode:SensorsAnalyticsDebugOff];
        [sharedInstance startRemoteConfig];
        [sharedInstance startAppLifecycle];
    });
}

+ (SensorsAnalyticsSDK *_Nullable)sharedInstance {
    NSAssert(sharedInstance, @"请先使用 startWithConfigOptions: 初始化 SDK");
    if ([SARemoteConfigManager sharedInstance].isDisableSDK) {
        SALogDebug(@"【remote config】SDK is disabled");
        return nil;
    }
    return sharedInstance;
}

+ (SensorsAnalyticsSDK *)sdkInstance {
    NSAssert(sharedInstance, @"请先使用 startWithConfigOptions: 初始化 SDK");
    return sharedInstance;
}

- (instancetype)initWithServerURL:(NSString *)serverURL
                 andLaunchOptions:(NSDictionary *)launchOptions
                     andDebugMode:(SensorsAnalyticsDebugMode)debugMode {
    @try {

        SAConfigOptions * options = [[SAConfigOptions alloc]initWithServerURL:serverURL launchOptions:launchOptions];
        self = [self initWithConfigOptions:options debugMode:debugMode];
    } @catch(NSException *exception) {
        SALogError(@"%@ error: %@", self, exception);
    }
    return self;
}

- (instancetype)initWithConfigOptions:(nonnull SAConfigOptions *)configOptions debugMode:(SensorsAnalyticsDebugMode)debugMode {
    @try {
        self = [super init];
        if (self) {
            _configOptions = [configOptions copy];

            _networkTypePolicy = SensorsAnalyticsNetworkType3G |
                SensorsAnalyticsNetworkType4G |
#ifdef __IPHONE_14_1
                SensorsAnalyticsNetworkType5G |
#endif
                SensorsAnalyticsNetworkTypeWIFI;
            
            _people = [[SensorsAnalyticsPeople alloc] init];

            NSString *serialQueueLabel = [NSString stringWithFormat:@"com.sensorsdata.serialQueue.%p", self];
            _serialQueue = dispatch_queue_create([serialQueueLabel UTF8String], DISPATCH_QUEUE_SERIAL);
            dispatch_queue_set_specific(_serialQueue, SensorsAnalyticsQueueTag, &SensorsAnalyticsQueueTag, NULL);

            NSString *readWriteQueueLabel = [NSString stringWithFormat:@"com.sensorsdata.readWriteQueue.%p", self];
            _readWriteQueue = dispatch_queue_create([readWriteQueueLabel UTF8String], DISPATCH_QUEUE_SERIAL);

            [[SAReachability sharedInstance] startMonitoring];
            
            _network = [[SANetwork alloc] init];
            [self setupSecurityPolicyWithConfigOptions:_configOptions];

            _eventTracker = [[SAEventTracker alloc] initWithQueue:_serialQueue];

            _referrerManager =[[SAReferrerManager alloc] init];
            _referrerManager.enableReferrerTitle = configOptions.enableReferrerTitle;
            
            _ignoredViewControllers = [[NSMutableArray alloc] init];
            _ignoredViewTypeList = [[NSMutableArray alloc] init];
            _trackChannelEventNames = [[NSMutableSet alloc] init];
            
            _trackTimer = [[SATrackTimer alloc] init];

            NSString *namePattern = @"^([a-zA-Z_$][a-zA-Z\\d_$]{0,99})$";
            _propertiesRegex = [NSRegularExpression regularExpressionWithPattern:namePattern options:NSRegularExpressionCaseInsensitive error:nil];

            _identifier = [[SAIdentifier alloc] initWithQueue:_readWriteQueue];
            
            _presetProperty = [[SAPresetProperty alloc] initWithQueue:_readWriteQueue libVersion:[self libVersion]];
            
            _superProperty = [[SASuperProperty alloc] init];
            
            // 取上一次进程退出时保存的distinctId、loginId、superProperties
            [self unarchiveTrackChannelEvents];

            if (_configOptions.enableTrackAppCrash) {
                // Install uncaught exception handlers first
                [[SensorsAnalyticsExceptionHandler sharedHandler] addSensorsAnalyticsInstance:self];
            }
            
            if (_configOptions.enableLog) {
                [self enableLog:YES];
            }
            
            // WKWebView 打通
            if (_configOptions.enableJavaScriptBridge) {
                [self swizzleWebViewMethod];
            }

            // 开启可视化全埋点或点击图
            if (_configOptions.enableVisualizedAutoTrack || _configOptions.enableHeatMap) {
                [self swizzleWebViewMethod];
            }
            if (_configOptions.enableTrackPush) {
                [[SAModuleManager sharedInstance] setEnable:YES forModuleType:SAModuleTypeAppPush];
                [SAModuleManager sharedInstance].launchOptions = configOptions.launchOptions;
            }
        }
        
    } @catch(NSException *exception) {
        SALogError(@"%@ error: %@", self, exception);
    }
    
    return self;
}

- (void)setupSecurityPolicyWithConfigOptions:(SAConfigOptions *)options {
    SASecurityPolicy *securityPolicy = options.securityPolicy;
    if (!securityPolicy) {
        return;
    }
    
#ifdef DEBUG
    NSURL *serverURL = [NSURL URLWithString:options.serverURL];
    if (securityPolicy.SSLPinningMode != SASSLPinningModeNone && ![serverURL.scheme isEqualToString:@"https"]) {
        NSString *pinningMode = @"Unknown Pinning Mode";
        switch (securityPolicy.SSLPinningMode) {
            case SASSLPinningModeNone:
                pinningMode = @"SASSLPinningModeNone";
                break;
            case SASSLPinningModeCertificate:
                pinningMode = @"SASSLPinningModeCertificate";
                break;
            case SASSLPinningModePublicKey:
                pinningMode = @"SASSLPinningModePublicKey";
                break;
        }
        NSString *reason = [NSString stringWithFormat:@"A security policy configured with `%@` can only be applied on a manager with a secure base URL (i.e. https)", pinningMode];
        @throw [NSException exceptionWithName:@"Invalid Security Policy" reason:reason userInfo:nil];
    }
#endif
    
    SAHTTPSession.sharedInstance.securityPolicy = securityPolicy;
}

- (void)enableLoggers {
    if (!self.consoleLogger) {
        SAConsoleLogger *consoleLogger = [[SAConsoleLogger alloc] init];
        [SALog addLogger:consoleLogger];
        self.consoleLogger = consoleLogger;
    }
}

+ (UInt64)getCurrentTime {
    return [[NSDate date] timeIntervalSince1970] * 1000;
}

+ (UInt64)getSystemUpTime {
    return NSProcessInfo.processInfo.systemUptime * 1000;
}

- (BOOL)shouldTrackViewController:(UIViewController *)controller ofType:(SensorsAnalyticsAutoTrackEventType)type {
    if ([self isViewControllerIgnored:controller]) {
        return NO;
    }

    return ![self isBlackListViewController:controller ofType:type];
}

- (BOOL)isBlackListViewController:(UIViewController *)viewController ofType:(SensorsAnalyticsAutoTrackEventType)type {
    static dispatch_once_t onceToken;
    static NSDictionary *allClasses = nil;
    dispatch_once(&onceToken, ^{
        NSBundle *sensorsBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[SensorsAnalyticsSDK class]] pathForResource:@"SensorsAnalyticsSDK" ofType:@"bundle"]];
        //文件路径
        NSString *jsonPath = [sensorsBundle pathForResource:@"sa_autotrack_viewcontroller_blacklist.json" ofType:nil];
        NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
        @try {
            allClasses = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        } @catch(NSException *exception) {  // json加载和解析可能失败
            SALogError(@"%@ error: %@", self, exception);
        }
    });

    NSDictionary *dictonary = (type == SensorsAnalyticsEventTypeAppViewScreen) ? allClasses[kSAEventNameAppViewScreen] : allClasses[kSAEventNameAppClick];
    for (NSString *publicClass in dictonary[@"public"]) {
        if ([viewController isKindOfClass:NSClassFromString(publicClass)]) {
            return YES;
        }
    }
    return [(NSArray *)dictonary[@"private"] containsObject:NSStringFromClass(viewController.class)];
}

- (NSDictionary *)getPresetProperties {
    return [NSDictionary dictionaryWithDictionary:[self.presetProperty currentPresetProperties]];
}

- (void)setServerUrl:(NSString *)serverUrl {
    [self setServerUrl:serverUrl isRequestRemoteConfig:NO];
}

- (NSString *)serverUrl {
    return self.network.serverURL.absoluteString;
}

- (void)setServerUrl:(NSString *)serverUrl isRequestRemoteConfig:(BOOL)isRequestRemoteConfig {
    if (serverUrl && ![serverUrl isKindOfClass:[NSString class]]) {
        SALogError(@"%@ serverUrl must be NSString, please check the value!", self);
        return;
    }

    dispatch_async(self.serialQueue, ^{
        self.configOptions.serverURL = serverUrl;
        if (isRequestRemoteConfig) {
            [[SARemoteConfigManager sharedInstance] retryRequestRemoteConfigWithForceUpdateFlag:YES];
        }
    });
}

- (void)setFlushNetworkPolicy:(SensorsAnalyticsNetworkType)networkType {
    @synchronized (self) {
        _networkTypePolicy = networkType;
    }
}

- (UIViewController *)currentViewController {
    return [SAAutoTrackUtils currentViewController];
}

- (void)setMaxCacheSize:(UInt64)maxCacheSize {
    @synchronized(self) {
        //防止设置的值太小导致事件丢失
        UInt64 temMaxCacheSize = maxCacheSize > 10000 ? maxCacheSize : 10000;
        self.configOptions.maxCacheSize = (NSInteger)temMaxCacheSize;
    };
}

- (UInt64)getMaxCacheSize {
    @synchronized(self) {
        return (UInt64)self.configOptions.maxCacheSize;
    };
}

- (void)login:(NSString *)loginId {
    [self login:loginId withProperties:nil];
}

- (void)login:(NSString *)loginId withProperties:(NSDictionary * _Nullable )properties {
    if (![self.identifier isValidLoginId:loginId]) {
        return;
    }

    SASignUpEventObject *object = [[SASignUpEventObject alloc] initWithEventId:kSAEventNameSignUp];
    object.dynamicSuperProperties = [self.superProperty acquireDynamicSuperProperties];
    dispatch_async(self.serialQueue, ^{
        [self.identifier login:loginId];
        [[NSNotificationCenter defaultCenter] postNotificationName:SA_TRACK_LOGIN_NOTIFICATION object:nil];
        [self trackEventObject:object properties:properties];
    });
}

- (void)logout {
    dispatch_async(self.serialQueue, ^{
        if (!self.loginId) {
            return;
        }
        [self.identifier logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:SA_TRACK_LOGOUT_NOTIFICATION object:nil];
    });
}

- (NSString *)loginId {
    return self.identifier.loginId;
}

- (NSString *)anonymousId {
    return self.identifier.anonymousId;
}

- (NSString *)distinctId {
    return self.identifier.distinctId;
}

- (void)resetAnonymousId {
    dispatch_async(self.serialQueue, ^{
        NSString *previousAnonymousId = [self.anonymousId copy];
        [self.identifier resetAnonymousId];
        if (self.loginId || [previousAnonymousId isEqualToString:self.anonymousId]) {
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SA_TRACK_RESETANONYMOUSID_NOTIFICATION object:nil];
    });
}

- (void)trackAppCrash {
    _configOptions.enableTrackAppCrash = YES;
    // Install uncaught exception handlers first
    [[SensorsAnalyticsExceptionHandler sharedHandler] addSensorsAnalyticsInstance:self];
}

- (void)ignoreViewType:(Class)aClass {
    [_ignoredViewTypeList addObject:aClass];
}

- (BOOL)isViewTypeIgnored:(Class)aClass {
    for (Class obj in _ignoredViewTypeList) {
        if ([aClass isSubclassOfClass:obj]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isViewControllerIgnored:(UIViewController *)viewController {
    if (viewController == nil) {
        return NO;
    }
    NSString *screenName = NSStringFromClass([viewController class]);
    if (_ignoredViewControllers.count > 0 && [_ignoredViewControllers containsObject:screenName]) {
        return YES;
    }
    
    return NO;
}

- (void)showDebugInfoView:(BOOL)show {
    [SAModuleManager.sharedInstance setShowDebugAlertView:show];
}

- (void)flush {
    dispatch_async(self.serialQueue, ^{
        [self.eventTracker flushAllEventRecords];
    });
}

- (void)deleteAll {
    dispatch_async(self.serialQueue, ^{
        [self.eventTracker.eventStore deleteAllRecords];
    });
}

#pragma mark - AppLifecycle

- (void)startAppLifecycle {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appLifecycleStateWillChange:) name:kSAAppLifecycleStateWillChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appLifecycleStateDidChange:) name:kSAAppLifecycleStateDidChangeNotification object:nil];
    
    _appLifecycle = [[SAAppLifecycle alloc] init];
}

// 处理事件触发之前的逻辑
- (void)appLifecycleStateWillChange:(NSNotification *)sender {
    NSDictionary *userInfo = sender.userInfo;
    SAAppLifecycleState newState = [userInfo[kSAAppLifecycleNewStateKey] integerValue];
    SAAppLifecycleState oldState = [userInfo[kSAAppLifecycleOldStateKey] integerValue];

    // 冷启动
    if (oldState == SAAppLifecycleStateInit && newState == SAAppLifecycleStateStart) {
        // 开启定时器
        [self startFlushTimer];
        // 请求远程配置
        [[SARemoteConfigManager sharedInstance] tryToRequestRemoteConfig];
        return;
    }

    // 热启动
    if (oldState != SAAppLifecycleStateInit && newState == SAAppLifecycleStateStart) {
        // 重新初始化远程配置
        [[SARemoteConfigManager sharedInstance] enableLocalRemoteConfig];
        // 请求远程配置
        [[SARemoteConfigManager sharedInstance] tryToRequestRemoteConfig];
        // 遍历 trackTimer
        UInt64 currentSysUpTime = [self.class getSystemUpTime];
        dispatch_async(self.serialQueue, ^{
            [self.trackTimer resumeAllEventTimers:currentSysUpTime];
        });
        return;
    }

    // 退出
    if (newState == SAAppLifecycleStateEnd) {
        // 清除本次启动解析的来源渠道信息
        [SAModuleManager.sharedInstance clearUtmProperties];
        // 停止计时器
        [self stopFlushTimer];
        // 删除远程配置请求
        [[SARemoteConfigManager sharedInstance] cancelRequestRemoteConfig];
        // 遍历 trackTimer
        UInt64 currentSysUpTime = [self.class getSystemUpTime];
        dispatch_async(self.serialQueue, ^{
            [self.trackTimer pauseAllEventTimers:currentSysUpTime];
        });
        // 清除 $referrer
        [_referrerManager clearReferrer];
    }
}

// 处理事件触发之后的逻辑
- (void)appLifecycleStateDidChange:(NSNotification *)sender {
    NSDictionary *userInfo = sender.userInfo;
    SAAppLifecycleState newState = [userInfo[kSAAppLifecycleNewStateKey] integerValue];
    SAAppLifecycleState oldState = [userInfo[kSAAppLifecycleOldStateKey] integerValue];

    // 尝试上报启动事件（包括冷启动和热启动）
    if (newState == SAAppLifecycleStateStart && ![self isAutoTrackEventTypeIgnored:SensorsAnalyticsEventTypeAppStart]) {
        [self flush];
    }

    // 热启动
    if (oldState != SAAppLifecycleStateInit && newState == SAAppLifecycleStateStart) {
        // track 被动启动的页面浏览
        if (self.launchedPassivelyControllers) {
            [self.launchedPassivelyControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull controller, NSUInteger idx, BOOL * _Nonnull stop) {
                [self trackViewScreen:controller properties:nil autoTrack:YES];
            }];
            self.launchedPassivelyControllers = nil;
        }
        // 开启定时器
        [self startFlushTimer];
        return;
    }

    // 退出
    if (newState == SAAppLifecycleStateEnd) {
        UIApplication *application = UIApplication.sharedApplication;
        __block UIBackgroundTaskIdentifier backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        void (^endBackgroundTask)(void) = ^() {
            [application endBackgroundTask:backgroundTaskIdentifier];
            backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        };
        backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:endBackgroundTask];

        dispatch_async(self.serialQueue, ^{
            // 上传所有的数据
            [self.eventTracker flushAllEventRecords];
            // 结束后台任务
            endBackgroundTask();
        });
        return;
    }

    // 终止
    if (newState == SAAppLifecycleStateTerminate) {
        dispatch_sync(self.serialQueue, ^{});
    }
}

#pragma mark - HandleURL
- (BOOL)canHandleURL:(NSURL *)url {
    return [SAModuleManager.sharedInstance canHandleURL:url] ||
    [[SARemoteConfigManager sharedInstance] canHandleURL:url];
}


- (BOOL)handleSchemeUrl:(NSURL *)url {
    if (!url) {
        return NO;
    }
    
    // 退到后台时的网络状态变化不会监听，因此通过 handleSchemeUrl 唤醒 App 时主动获取网络状态
    [[SAReachability sharedInstance] startMonitoring];
    
    if ([[SARemoteConfigManager sharedInstance] isRemoteConfigURL:url]) {
        [self enableLog:YES];
        [[SARemoteConfigManager sharedInstance] cancelRequestRemoteConfig];
        [[SARemoteConfigManager sharedInstance] handleRemoteConfigURL:url];
        return YES;
    } else {
        return [SAModuleManager.sharedInstance handleURL:url];
    }
}

#pragma mark - VisualizedAutoTrack

// 开启可视化模块
- (void)enableVisualize {
    [SAModuleManager.sharedInstance setEnable:YES forModuleType:SAModuleTypeVisualized];

    // 开启 WKWebView 和 js 的数据交互
    [self swizzleWebViewMethod];
}

#pragma mark - WKWebView 打通

- (void)swizzleWebViewMethod {
    static dispatch_once_t onceTokenWebView;
    dispatch_once(&onceTokenWebView, ^{
        NSError *error = NULL;

        [WKWebView sa_swizzleMethod:@selector(loadRequest:)
                         withMethod:@selector(sensorsdata_loadRequest:)
                              error:&error];

        [WKWebView sa_swizzleMethod:@selector(loadHTMLString:baseURL:)
                         withMethod:@selector(sensorsdata_loadHTMLString:baseURL:)
                              error:&error];

        if (@available(iOS 9.0, *)) {
            [WKWebView sa_swizzleMethod:@selector(loadFileURL:allowingReadAccessToURL:)
                             withMethod:@selector(sensorsdata_loadFileURL:allowingReadAccessToURL:)
                                  error:&error];

            [WKWebView sa_swizzleMethod:@selector(loadData:MIMEType:characterEncodingName:baseURL:)
                             withMethod:@selector(sensorsdata_loadData:MIMEType:characterEncodingName:baseURL:)
                                  error:&error];
        }

        if (error) {
            SALogError(@"Failed to swizzle on WKWebView. Details: %@", error);
            error = NULL;
        }
    });
}

- (void)addScriptMessageHandlerWithWebView:(WKWebView *)webView {
    NSAssert([webView isKindOfClass:[WKWebView class]], @"此注入方案只支持 WKWebView！❌");
    if (![webView isKindOfClass:[WKWebView class]]) {
        return;
    }

    @try {
        WKUserContentController *contentController = webView.configuration.userContentController;
        [contentController removeScriptMessageHandlerForName:SA_SCRIPT_MESSAGE_HANDLER_NAME];
        [contentController addScriptMessageHandler:[SAScriptMessageHandler sharedInstance] name:SA_SCRIPT_MESSAGE_HANDLER_NAME];

        NSMutableString *javaScriptSource = [NSMutableString string];

        // 开启 WKWebView 的 H5 打通功能
        if (self.configOptions.enableJavaScriptBridge) {
            if (self.configOptions.serverURL) {
                [javaScriptSource appendString:@"window.SensorsData_iOS_JS_Bridge = {};"];
                [javaScriptSource appendFormat:@"window.SensorsData_iOS_JS_Bridge.sensorsdata_app_server_url = '%@';", self.configOptions.serverURL];
            } else {
                SALogError(@"%@ get network serverURL is failed!", self);
            }
        }

        // App 内嵌 H5 数据交互
        if (self.configOptions.enableVisualizedAutoTrack || self.configOptions.enableHeatMap) {
            [javaScriptSource appendString:@"window.SensorsData_App_Visual_Bridge = {};"];
            if ([SAModuleManager sharedInstance].isConnecting) {
                [javaScriptSource appendFormat:@"window.SensorsData_App_Visual_Bridge.sensorsdata_visualized_mode = true;"];
            }
        }

        if (javaScriptSource.length == 0) {
            return;
        }

        NSArray<WKUserScript *> *userScripts = contentController.userScripts;
        __block BOOL isContainJavaScriptBridge = NO;
        [userScripts enumerateObjectsUsingBlock:^(WKUserScript *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj.source containsString:@"sensorsdata_app_server_url"] || [obj.source containsString:@"sensorsdata_visualized_mode"]) {
                isContainJavaScriptBridge = YES;
                *stop = YES;
            }
        }];

        if (!isContainJavaScriptBridge) {
            // forMainFrameOnly:标识脚本是仅应注入主框架（YES）还是注入所有框架（NO）
            WKUserScript *userScript = [[WKUserScript alloc] initWithSource:[NSString stringWithString:javaScriptSource] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
            [contentController addUserScript:userScript];

            // 通知其他模块，开启打通 H5
            if ([javaScriptSource containsString:@"sensorsdata_app_server_url"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SA_H5_BRIDGE_NOTIFICATION object:webView];
            }
        }
    } @catch (NSException *exception) {
        SALogError(@"%@ error: %@", self, exception);
    }
}

#pragma mark - Item 操作
- (void)itemSetWithType:(NSString *)itemType itemId:(NSString *)itemId properties:(nullable NSDictionary <NSString *, id> *)propertyDict {
    NSMutableDictionary *itemDict = [[NSMutableDictionary alloc] init];
    itemDict[kSAEventType] = SA_EVENT_ITEM_SET;
    itemDict[SA_EVENT_ITEM_TYPE] = itemType;
    itemDict[SA_EVENT_ITEM_ID] = itemId;

    dispatch_async(self.serialQueue, ^{
        [self trackItems:itemDict properties:propertyDict];
    });
}

- (void)itemDeleteWithType:(NSString *)itemType itemId:(NSString *)itemId {
    NSMutableDictionary *itemDict = [[NSMutableDictionary alloc] init];
    itemDict[kSAEventType] = SA_EVENT_ITEM_DELETE;
    itemDict[SA_EVENT_ITEM_TYPE] = itemType;
    itemDict[SA_EVENT_ITEM_ID] = itemId;
    
    dispatch_async(self.serialQueue, ^{
        [self trackItems:itemDict properties:nil];
    });
}

- (void)trackItems:(nullable NSDictionary <NSString *, id> *)itemDict properties:(nullable NSDictionary <NSString *, id> *)propertyDict {
    //item_type 必须为合法变量名
    NSString *itemType = itemDict[SA_EVENT_ITEM_TYPE];
    if (itemType.length == 0 || ![SAValidator isValidKey:itemType]) {
        NSString *errMsg = [NSString stringWithFormat:@"item_type name[%@] not valid", itemType];
        SALogError(@"%@", errMsg);
        [SAModuleManager.sharedInstance showDebugModeWarning:errMsg];
        return;
    }

    NSString *itemId = itemDict[SA_EVENT_ITEM_ID];
    if (itemId.length == 0 || itemId.length > 255) {
        SALogError(@"%@ max length of item_id is 255, item_id: %@", self, itemId);
        return;
    }
    
    // 校验 properties
    NSError *error = nil;
    propertyDict = [SAPropertyValidator validProperties:[propertyDict copy] error:&error];
    if (error) {
        SALogError(@"%@", error.localizedDescription);
        SALogError(@"%@ failed to item properties", self);
        [SAModuleManager.sharedInstance showDebugModeWarning:error.localizedDescription];
        return;
    }
    
    NSMutableDictionary *itemProperties = [NSMutableDictionary dictionaryWithDictionary:itemDict];
    
    // 处理 $project
    NSMutableDictionary *propertyMDict = [NSMutableDictionary dictionaryWithDictionary:propertyDict];
    id project = propertyMDict[kSAEventCommonOptionalPropertyProject];
    if (project) {
        itemProperties[kSAEventProject] = project;
        [propertyMDict removeObjectForKey:kSAEventCommonOptionalPropertyProject];
    }
    
    if (propertyMDict.count > 0) {
        itemProperties[kSAEventProperties] = propertyMDict;
    }
    
    itemProperties[kSAEventLib] = [self.presetProperty libPropertiesWithLibMethod:kSALibMethodCode];

    NSNumber *timeStamp = @([[self class] getCurrentTime]);
    itemProperties[kSAEventTime] = timeStamp;

    SALogDebug(@"\n【track event】:\n%@", itemProperties);

    [self.eventTracker trackEvent:itemProperties];
}
#pragma mark - track event
- (void)asyncTrackEventObject:(SABaseEventObject *)object properties:(NSDictionary *)properties {
    object.dynamicSuperProperties = [self.superProperty acquireDynamicSuperProperties];
    dispatch_async(self.serialQueue, ^{
        [self trackEventObject:object properties:properties];
    });
}

- (void)trackEventObject:(SABaseEventObject *)object properties:(NSDictionary *)properties {
    // 1. 远程控制校验
    if ([SARemoteConfigManager sharedInstance].isDisableSDK) {
        SALogDebug(@"【remote config】SDK is disabled");
        return;
    }

    if ([[SARemoteConfigManager sharedInstance] isBlackListContainsEvent:object.event]) {
        SALogDebug(@"【remote config】 %@ is ignored by remote config", object.event);
        return;
    }

    // 2. 事件名校验
    NSError *error = nil;
    [object validateEventWithError:&error];
    if (error) {
        SALogError(@"%@", error.localizedDescription);
        [SAModuleManager.sharedInstance showDebugModeWarning:error.localizedDescription];
        return;
    }

    // 3. 设置用户关联信息
    NSString *anonymousId = self.anonymousId;
    object.distinctId = self.distinctId;
    object.loginId = self.loginId;
    object.anonymousId = anonymousId;
    object.originalId = anonymousId;

    // 4. 添加属性
    [object addEventProperties:self.presetProperty.automaticProperties];
    [object addSuperProperties:self.superProperty.currentSuperProperties];
    [object addEventProperties:object.dynamicSuperProperties];
    [object addEventProperties:self.presetProperty.currentNetworkProperties];
    NSNumber *eventDuration = [self.trackTimer eventDurationFromEventId:object.eventId currentSysUpTime:object.currentSystemUpTime];
    [object addDurationProperty:eventDuration];
    [object addEventProperties:SAModuleManager.sharedInstance.latestUtmProperties];

    if (self.configOptions.enableAutoAddChannelCallbackEvent) {
        NSMutableDictionary *channelInfo = [self channelPropertiesWithEvent:object.event];
        channelInfo[SA_EVENT_PROPERTY_CHANNEL_INFO] = @"1";
        [object addChannelProperties:channelInfo];
    }
    
    if (self.configOptions.enableReferrerTitle) {
        [object addReferrerTitleProperty:self.referrerManager.referrerTitle];
    }

    // 5. 添加的自定义属性需要校验
    [object addCustomProperties:properties error:&error];
    [object addModuleProperties:@{kSAEventPresetPropertyIsFirstDay: @(self.presetProperty.isFirstDay)}];
    [object addModuleProperties:SAModuleManager.sharedInstance.properties];

    if (error) {
        SALogError(@"%@", error.localizedDescription);
        [SAModuleManager.sharedInstance showDebugModeWarning:error.localizedDescription];
        return;
    }

    // 6. trackEventCallback 接口调用
    if (![self willEnqueueWithObject:object]) {
        return;
    }

    // 7. 发送通知 & 事件采集
    NSDictionary *result = [object jsonObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:SA_TRACK_EVENT_NOTIFICATION object:nil userInfo:result];
    [self.eventTracker trackEvent:result isSignUp:object.isSignUp];
    SALogDebug(@"\n【track event】:\n%@", result);
}

- (BOOL)willEnqueueWithObject:(SABaseEventObject *)obj {
    if (!self.trackEventCallback || !obj.eventId) {
        return YES;
    }
    BOOL willEnque = self.trackEventCallback(obj.eventId, obj.properties);
    if (!willEnque) {
        SALogDebug(@"\n【track event】: %@ can not enter database.", obj.eventId);
        return NO;
    }
    // 校验 properties
    NSError *error = nil;
    NSMutableDictionary *properties = [SAPropertyValidator validProperties:obj.properties error:&error];
    if (error) {
        SALogError(@"%@ failed to track event.", self);
        return NO;
    }
    obj.properties = properties;
    return YES;
}

- (NSDictionary<NSString *, id> *)willEnqueueWithType:(NSString *)type andEvent:(NSDictionary *)e {
    if (!self.trackEventCallback || !e[@"event"]) {
        return [e copy];
    }
    NSMutableDictionary *event = [e mutableCopy];
    NSMutableDictionary<NSString *, id> *originProperties = event[@"properties"];
    BOOL isIncluded = self.trackEventCallback(event[@"event"], originProperties);
    if (!isIncluded) {
        SALogDebug(@"\n【track event】: %@ can not enter database.", event[@"event"]);
        return nil;
    }
    // 校验 properties
    NSError *error = nil;
    NSDictionary *validProperties = [SAPropertyValidator validProperties:originProperties error:&error];
    if (error) {
        SALogError(@"%@", error.localizedDescription);
        SALogError(@"%@ failed to track event.", self);
        [SAModuleManager.sharedInstance showDebugModeWarning:error.localizedDescription];
        return nil;
    }
    event[@"properties"] = validProperties;
    return event;
}

- (void)profile:(NSString *)type properties:(NSDictionary *)properties {
    SAProfileEventObject *object = [[SAProfileEventObject alloc] initWithType:type];
    [self asyncTrackEventObject:object properties:properties];
}

- (void)track:(NSString *)event {
    [self track:event withProperties:nil];;
}

- (void)track:(NSString *)event withProperties:(NSDictionary *)propertieDict {
    SACustomEventObject *object = [[SACustomEventObject alloc] initWithEventId:event];
    [self asyncTrackEventObject:object properties:propertieDict];
}

- (void)trackChannelEvent:(NSString *)event {
    [self trackChannelEvent:event properties:nil];
}

- (void)trackChannelEvent:(NSString *)event properties:(nullable NSDictionary *)propertyDict {
    if (_configOptions.enableAutoAddChannelCallbackEvent) {
        SACustomEventObject *object = [[SACustomEventObject alloc] initWithEventId:event];
        [self asyncTrackEventObject:object properties:propertyDict];
        return;
    }
    NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:propertyDict];
    // ua
    if ([propertyDict[SA_EVENT_PROPERTY_APP_USER_AGENT] length] == 0) {
        properties[SA_EVENT_PROPERTY_APP_USER_AGENT] = [SACommonUtility simulateUserAgent];
    }
    // idfa
    NSString *idfa = [SAIdentifier idfa];
    if (idfa) {
        [properties setValue:[NSString stringWithFormat:@"idfa=%@", idfa] forKey:SA_EVENT_PROPERTY_CHANNEL_INFO];
    } else {
        [properties setValue:@"" forKey:SA_EVENT_PROPERTY_CHANNEL_INFO];
    }

    BOOL isNotContains = ![self.trackChannelEventNames containsObject:event];
    properties[SA_EVENT_PROPERTY_CHANNEL_CALLBACK_EVENT] = @(isNotContains);
    if (isNotContains && event) {
        [self.trackChannelEventNames addObject:event];
        dispatch_async(self.serialQueue, ^{
            [self archiveTrackChannelEventNames];
        });
    }
    SACustomEventObject *object = [[SACustomEventObject alloc] initWithEventId:event];
    object.dynamicSuperProperties = [self.superProperty acquireDynamicSuperProperties];
    dispatch_async(self.serialQueue, ^{
        [object addChannelProperties:[self channelPropertiesWithEvent:object.event]];
        [self trackEventObject:object properties:properties];
    });
}

- (void)setCookie:(NSString *)cookie withEncode:(BOOL)encode {
    [_network setCookie:cookie isEncoded:encode];
}

- (NSString *)getCookieWithDecode:(BOOL)decode {
    return [_network cookieWithDecoded:decode];
}

- (BOOL)checkEventName:(NSString *)eventName {
    if ([SAValidator isValidKey:eventName]) {
        return YES;
    }
    NSString *errMsg = [NSString stringWithFormat:@"Event name[%@] not valid", eventName];
    SALogError(@"%@", errMsg);
    [SAModuleManager.sharedInstance showDebugModeWarning:errMsg];
    return NO;
}

- (nullable NSString *)trackTimerStart:(NSString *)event {
    if (![self checkEventName:event]) {
        return nil;
    }
    NSString *eventId = [_trackTimer generateEventIdByEventName:event];
    UInt64 currentSysUpTime = [self.class getSystemUpTime];
    dispatch_async(self.serialQueue, ^{
        [self.trackTimer trackTimerStart:eventId currentSysUpTime:currentSysUpTime];
    });
    return eventId;
}

- (void)trackTimerEnd:(NSString *)event {
    [self trackTimerEnd:event withProperties:nil];
}

- (void)trackTimerEnd:(NSString *)event withProperties:(NSDictionary *)propertyDict {
    // trackTimerEnd 事件需要支持新渠道匹配功能，且用户手动调用 trackTimerEnd 应归为手动埋点
    SACustomEventObject *object = [[SACustomEventObject alloc] initWithEventId:event];
    [self asyncTrackEventObject:object properties:propertyDict];
}

- (void)trackTimerPause:(NSString *)event {
    if (![self checkEventName:event]) {
        return;
    }
    UInt64 currentSysUpTime = [self.class getSystemUpTime];
    dispatch_async(self.serialQueue, ^{
        [self.trackTimer trackTimerPause:event currentSysUpTime:currentSysUpTime];
    });
}

- (void)trackTimerResume:(NSString *)event {
    if (![self checkEventName:event]) {
        return;
    }
    UInt64 currentSysUpTime = [self.class getSystemUpTime];
    dispatch_async(self.serialQueue, ^{
        [self.trackTimer trackTimerResume:event currentSysUpTime:currentSysUpTime];
    });
}

- (void)removeTimer:(NSString *)event {
    if (![self checkEventName:event]) {
        return;
    }
    dispatch_async(self.serialQueue, ^{
        [self.trackTimer trackTimerRemove:event];
    });
}

- (void)clearTrackTimer {
    dispatch_async(self.serialQueue, ^{
        [self.trackTimer clearAllEventTimers];
    });
}

- (void)ignoreAutoTrackViewControllers:(NSArray<NSString *> *)controllers {
    if (controllers == nil || controllers.count == 0) {
        return;
    }
    [_ignoredViewControllers addObjectsFromArray:controllers];

    //去重
    NSSet *set = [NSSet setWithArray:_ignoredViewControllers];
    if (set != nil) {
        _ignoredViewControllers = [NSMutableArray arrayWithArray:[set allObjects]];
    } else {
        _ignoredViewControllers = [[NSMutableArray alloc] init];
    }
}

- (void)identify:(NSString *)anonymousId {
    dispatch_async(self.serialQueue, ^{
        if (![self.identifier identify:anonymousId]) {
            return;
        }
        // 其他 SDK 接收匿名 ID 修改通知，例如 AB，SF
        if (!self.loginId) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SA_TRACK_IDENTIFY_NOTIFICATION object:nil];
        }
    });
}

- (NSString *)libVersion {
    return VERSION;
}

- (void)registerSuperProperties:(NSDictionary *)propertyDict {
    dispatch_async(self.serialQueue, ^{
        [self.superProperty registerSuperProperties:propertyDict];
    });
}

- (void)registerDynamicSuperProperties:(NSDictionary<NSString *, id> *(^)(void)) dynamicSuperProperties {
    [self.superProperty registerDynamicSuperProperties:dynamicSuperProperties];
}

- (void)unregisterSuperProperty:(NSString *)property {
    dispatch_async(self.serialQueue, ^{
        [self.superProperty unregisterSuperProperty:property];
    });
}

- (void)clearSuperProperties {
    dispatch_async(self.serialQueue, ^{
        [self.superProperty clearSuperProperties];
    });
}

- (NSDictionary *)currentSuperProperties {
    return [self.superProperty currentSuperProperties];
}

- (void)trackEventCallback:(BOOL (^)(NSString *eventName, NSMutableDictionary<NSString *, id> *properties))callback {
    if (!callback) {
        return;
    }
    SALogDebug(@"SDK have set trackEvent callBack");
    dispatch_async(self.serialQueue, ^{
        self.trackEventCallback = callback;
    });
}

#pragma mark - Local caches
- (void)unarchiveTrackChannelEvents {
    dispatch_async(self.serialQueue, ^{
        NSSet *trackChannelEvents = (NSSet *)[SAFileStore unarchiveWithFileName:SA_EVENT_PROPERTY_CHANNEL_INFO];
        [self.trackChannelEventNames unionSet:trackChannelEvents];
    });
}

- (void)archiveTrackChannelEventNames {
    [SAFileStore archiveWithFileName:SA_EVENT_PROPERTY_CHANNEL_INFO value:self.trackChannelEventNames];
}

- (NSMutableDictionary *)channelPropertiesWithEvent:(NSString *)event {
    BOOL isNotContains = ![self.trackChannelEventNames containsObject:event];
    if (isNotContains && event) {
        [self.trackChannelEventNames addObject:event];
        [self archiveTrackChannelEventNames];
    }
    return [NSMutableDictionary dictionaryWithObject:@(isNotContains) forKey:SA_EVENT_PROPERTY_CHANNEL_CALLBACK_EVENT];
}

- (void)startFlushTimer {
    SALogDebug(@"starting flush timer.");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.timer && [self.timer isValid]) {
            return;
        }

        if (self.appLifecycle.state != SAAppLifecycleStateStart) {
            return;
        }

        if ([SARemoteConfigManager sharedInstance].isDisableSDK) {
            return;
        }
        
        if (self.configOptions.flushInterval > 0) {
            double interval = self.configOptions.flushInterval > 100 ? (double)self.configOptions.flushInterval / 1000.0 : 0.1f;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                          target:self
                                                        selector:@selector(flush)
                                                        userInfo:nil
                                                         repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    });
}

- (void)stopFlushTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.timer) {
            [self.timer invalidate];
        }
        self.timer = nil;
    });
}

- (NSString *)getLastScreenUrl {
    return _referrerManager.referrerURL;
}

- (void)clearReferrerWhenAppEnd {
    _referrerManager.isClearReferrer = YES;
}

- (NSDictionary *)getLastScreenTrackProperties {
    return _referrerManager.referrerProperties;
}

- (SensorsAnalyticsDebugMode)debugMode {
    return SAModuleManager.sharedInstance.debugMode;
}

- (void)trackViewAppClick:(UIView *)view {
    [self trackViewAppClick:view withProperties:nil];
}

- (void)trackViewAppClick:(UIView *)view withProperties:(NSDictionary *)p {
    @try {
        if (view == nil) {
            return;
        }
        NSMutableDictionary *properties = [[NSMutableDictionary alloc]init];
        [properties addEntriesFromDictionary:[SAAutoTrackUtils propertiesWithAutoTrackObject:view isCodeTrack:YES]];
        if ([SAValidator isValidDictionary:p]) {
            [properties addEntriesFromDictionary:p];
        }

        // 添加自定义属性
        [SAModuleManager.sharedInstance visualPropertiesWithView:view completionHandler:^(NSDictionary * _Nullable visualProperties) {
            if (visualProperties) {
                [properties addEntriesFromDictionary:visualProperties];
            }
            SAPresetEventObject *object = [[SAPresetEventObject alloc] initWithEventId:kSAEventNameAppClick];
            [self asyncTrackEventObject:object properties:properties];
        }];
    } @catch (NSException *exception) {
        SALogError(@"%@: %@", self, exception);
    }
}

- (void)autoTrackViewScreen:(UIViewController *)controller {
    if (!controller) {
        return;
    }
    //过滤用户设置的不被AutoTrack的Controllers
    if (![self shouldTrackViewController:controller ofType:SensorsAnalyticsEventTypeAppViewScreen]) {
        return;
    }

    if (self.appLifecycle.state == SAAppLifecycleStateStartPassively) {
        if (!self.launchedPassivelyControllers) {
            self.launchedPassivelyControllers = [NSMutableArray array];
        }
        [self.launchedPassivelyControllers addObject:controller];
        return;
    }

    [self trackViewScreen:controller properties:nil autoTrack:YES];
}

- (void)trackViewScreen:(UIViewController *)controller {
    [self trackViewScreen:controller properties:nil];
}

- (void)trackViewScreen:(UIViewController *)controller properties:(nullable NSDictionary<NSString *, id> *)properties {
    [self trackViewScreen:controller properties:properties autoTrack:NO];
}

- (void)trackViewScreen:(UIViewController *)controller properties:(nullable NSDictionary<NSString *, id> *)properties autoTrack:(BOOL)autoTrack {
    if (!controller) {
        return;
    }

    if ([self isBlackListViewController:controller ofType:SensorsAnalyticsEventTypeAppViewScreen]) {
        return;
    }

    NSMutableDictionary *eventProperties = [[NSMutableDictionary alloc] init];

    NSDictionary *autoTrackProperties = [SAAutoTrackUtils propertiesWithViewController:controller];
    [eventProperties addEntriesFromDictionary:autoTrackProperties];

    if (autoTrack) {
        // App 通过 Deeplink 启动时第一个页面浏览事件会添加 utms 属性
        // 只需要处理全埋点的页面浏览事件
        [eventProperties addEntriesFromDictionary:SAModuleManager.sharedInstance.utmProperties];
        [SAModuleManager.sharedInstance clearUtmProperties];
    }

    if ([SAValidator isValidDictionary:properties]) {
        [eventProperties addEntriesFromDictionary:properties];
    }

    NSString *currentURL;
    if ([controller conformsToProtocol:@protocol(SAScreenAutoTracker)] && [controller respondsToSelector:@selector(getScreenUrl)]) {
        UIViewController<SAScreenAutoTracker> *screenAutoTrackerController = (UIViewController<SAScreenAutoTracker> *)controller;
        currentURL = [screenAutoTrackerController getScreenUrl];
    }
    currentURL = [currentURL isKindOfClass:NSString.class] ? currentURL : NSStringFromClass(controller.class);

    // 添加 $url 和 $referrer 页面浏览相关属性
    NSDictionary *newProperties = [_referrerManager propertiesWithURL:currentURL eventProperties:eventProperties serialQueue:self.serialQueue];

    SATrackEventObject *eventObject  = nil;
    if (autoTrack) {
        eventObject = [[SAAutoTrackEventObject alloc] initWithEventId:kSAEventNameAppViewScreen];
    } else {
        eventObject = [[SAPresetEventObject alloc] initWithEventId:kSAEventNameAppViewScreen];
    }
    [self asyncTrackEventObject:eventObject properties:newProperties];
}

- (void)trackEventFromExtensionWithGroupIdentifier:(NSString *)groupIdentifier completion:(void (^)(NSString *groupIdentifier, NSArray *events)) completion {
    @try {
        if (groupIdentifier == nil || [groupIdentifier isEqualToString:@""]) {
            return;
        }
        NSArray *eventArray = [[SAAppExtensionDataManager sharedInstance] readAllEventsWithGroupIdentifier:groupIdentifier];
        if (eventArray) {
            for (NSDictionary *dict in eventArray) {
                SACustomEventObject *object = [[SACustomEventObject alloc] initWithEventId:dict[kSAEventName]];
                [self asyncTrackEventObject:object properties:dict[kSAEventProperties]];
            }
            [[SAAppExtensionDataManager sharedInstance] deleteEventsWithGroupIdentifier:groupIdentifier];
            if (completion) {
                completion(groupIdentifier, eventArray);
            }
        }
    } @catch (NSException *exception) {
        SALogError(@"%@ error: %@", self, exception);
    }
}

#pragma mark - SensorsData  Analytics

- (void)set:(NSDictionary *)profileDict {
    [[self people] set:profileDict];
}

- (void)profilePushKey:(NSString *)pushTypeKey pushId:(NSString *)pushId {
    if ([pushTypeKey isKindOfClass:NSString.class] && pushTypeKey.length && [pushId isKindOfClass:NSString.class] && pushId.length) {
        NSString * keyOfPushId = [NSString stringWithFormat:@"sa_%@", pushTypeKey];
        NSString * valueOfPushId = [NSUserDefaults.standardUserDefaults valueForKey:keyOfPushId];
        NSString * newValueOfPushId = [NSString stringWithFormat:@"%@_%@", self.distinctId, pushId];
        if (![valueOfPushId isEqualToString:newValueOfPushId]) {
            [self set:@{pushTypeKey:pushId}];
            [NSUserDefaults.standardUserDefaults setValue:newValueOfPushId forKey:keyOfPushId];
        }
    }
}

- (void)profileUnsetPushKey:(NSString *)pushTypeKey {
    NSAssert(([pushTypeKey isKindOfClass:[NSString class]] && pushTypeKey.length), @"pushTypeKey should be a non-empty string object!!!❌❌❌");
    NSString *localKey = [NSString stringWithFormat:@"sa_%@", pushTypeKey];
    NSString *localValue = [NSUserDefaults.standardUserDefaults valueForKey:localKey];
    if ([localValue hasPrefix:self.distinctId]) {
        [self unset:pushTypeKey];
        [NSUserDefaults.standardUserDefaults removeObjectForKey:localKey];
    }
}

- (void)setOnce:(NSDictionary *)profileDict {
    [[self people] setOnce:profileDict];
}

- (void)set:(NSString *) profile to:(id)content {
    [[self people] set:profile to:content];
}

- (void)setOnce:(NSString *) profile to:(id)content {
    [[self people] setOnce:profile to:content];
}

- (void)unset:(NSString *) profile {
    [[self people] unset:profile];
}

- (void)increment:(NSString *)profile by:(NSNumber *)amount {
    [[self people] increment:profile by:amount];
}

- (void)increment:(NSDictionary *)profileDict {
    [[self people] increment:profileDict];
}

- (void)append:(NSString *)profile by:(NSObject<NSFastEnumeration> *)content {
    if ([content isKindOfClass:[NSSet class]] || [content isKindOfClass:[NSArray class]]) {
        [[self people] append:profile by:content];
    }
}

- (void)deleteUser {
    [[self people] deleteUser];
}

- (void)enableLog:(BOOL)enableLog {
    self.configOptions.enableLog = enableLog;
    [SALog sharedLog].enableLog = enableLog;
    if (!enableLog) {
        return;
    }
    [self enableLoggers];
}

- (void)enableTrackScreenOrientation:(BOOL)enable {
    [SAModuleManager.sharedInstance setEnable:enable forModuleType:SAModuleTypeDeviceOrientation];
}

- (void)enableTrackGPSLocation:(BOOL)enableGPSLocation {
    if (NSThread.isMainThread) {
        [SAModuleManager.sharedInstance setEnable:enableGPSLocation forModuleType:SAModuleTypeLocation];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^ {
            [SAModuleManager.sharedInstance setEnable:enableGPSLocation forModuleType:SAModuleTypeLocation];
        });
    }
}

- (void)clearKeychainData {
#ifndef SENSORS_ANALYTICS_DISABLE_KEYCHAIN
    [SAKeyChainItemWrapper deletePasswordWithAccount:kSAUdidAccount service:kSAService];
#endif

}

#pragma mark - RemoteConfig

- (void)startRemoteConfig {
    // 初始化远程配置类
    SARemoteConfigOptions *options = [[SARemoteConfigOptions alloc] init];
    options.configOptions = _configOptions;
    options.currentLibVersion = [self libVersion];
    
    __weak typeof(self) weakSelf = self;
    options.createEncryptorResultBlock = ^BOOL{
        return SAModuleManager.sharedInstance.hasSecretKey;
    };
    options.handleEncryptBlock = ^(NSDictionary * _Nonnull encryptConfig) {
        [SAModuleManager.sharedInstance handleEncryptWithConfig:encryptConfig];
    };
    options.trackEventBlock = ^(NSString * _Nonnull event, NSDictionary * _Nonnull properties) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SAPresetEventObject *object = [[SAPresetEventObject alloc] initWithEventId:event];
        [strongSelf asyncTrackEventObject:object properties:properties];
        // 触发 $AppRemoteConfigChanged 时 flush 一次
        [strongSelf flush];
    };
    options.triggerEffectBlock = ^(BOOL isDisableSDK, BOOL isDisableDebugMode) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (isDisableDebugMode) {
            SAModuleManager.sharedInstance.debugMode = SensorsAnalyticsDebugOff;
            [strongSelf enableLog:NO];
        }
        
        isDisableSDK ? [strongSelf performDisableSDKTask] : [strongSelf performEnableSDKTask];
    };
    
    [SARemoteConfigManager startWithRemoteConfigOptions:options];
}

- (void)performDisableSDKTask {
    [self stopFlushTimer];
    
    [self removeWebViewUserAgent];

    // 停止采集数据之后 flush 本地数据
    [self flush];
}

- (void)performEnableSDKTask {
    [self startFlushTimer];
    
    [self appendWebViewUserAgent];
}

- (void)removeWebViewUserAgent {
    if (!self.addWebViewUserAgent) {
        // 没有开启老版打通
        return;
    }
    
    NSString *currentUserAgent = [SACommonUtility currentUserAgent];
    if (![currentUserAgent containsString:self.addWebViewUserAgent]) {
        return;
    }
    
    NSString *newUserAgent = [currentUserAgent stringByReplacingOccurrencesOfString:self.addWebViewUserAgent withString:@""];
    self.userAgent = newUserAgent;
    [SACommonUtility saveUserAgent:self.userAgent];
}

- (void)appendWebViewUserAgent {
    if (!self.addWebViewUserAgent) {
        // 没有开启老版打通
        return;
    }
    
    NSString *currentUserAgent = [SACommonUtility currentUserAgent];
    if ([currentUserAgent containsString:self.addWebViewUserAgent]) {
        return;
    }
    
    NSMutableString *newUserAgent = [NSMutableString string];
    if (currentUserAgent) {
        [newUserAgent appendString:currentUserAgent];
    }
    [newUserAgent appendString:self.addWebViewUserAgent];
    self.userAgent = newUserAgent;
    [SACommonUtility saveUserAgent:self.userAgent];
}

@end

#pragma mark - $AppInstall
@implementation SensorsAnalyticsSDK (AppInstall)

- (void)trackAppInstall {
    [self trackAppInstallWithProperties:nil];
}

- (void)trackAppInstallWithProperties:(NSDictionary *)properties {
    [self trackAppInstallWithProperties:properties disableCallback:NO];
}

- (void)trackAppInstallWithProperties:(NSDictionary *)properties disableCallback:(BOOL)disableCallback {
    [SAModuleManager.sharedInstance trackAppInstall:kSAEventNameAppInstall properties:properties disableCallback:disableCallback];
}

- (void)trackInstallation:(NSString *)event {
    [self trackInstallation:event withProperties:nil disableCallback:NO];
}

- (void)trackInstallation:(NSString *)event withProperties:(NSDictionary *)propertyDict {
    [self trackInstallation:event withProperties:propertyDict disableCallback:NO];
}

- (void)trackInstallation:(NSString *)event withProperties:(NSDictionary *)properties disableCallback:(BOOL)disableCallback {
    [SAModuleManager.sharedInstance trackAppInstall:event properties:properties disableCallback:disableCallback];
}

@end

#pragma mark - Deeplink
@implementation SensorsAnalyticsSDK (Deeplink)

- (void)setDeeplinkCallback:(void(^)(NSString *_Nullable params, BOOL success, NSInteger appAwakePassedTime))callback {
    SAModuleManager.sharedInstance.linkHandlerCallback = callback;
}

@end

#pragma mark - JSCall

@implementation SensorsAnalyticsSDK (JSCall)

- (void)trackFromH5WithEvent:(NSString *)eventInfo {
    [self trackFromH5WithEvent:eventInfo enableVerify:NO];
}

- (void)trackFromH5WithEvent:(NSString *)eventInfo enableVerify:(BOOL)enableVerify {
    __block NSNumber *timeStamp = @([[self class] getCurrentTime]);
    
    dispatch_async(self.serialQueue, ^{
        @try {
            if (!eventInfo) {
                return;
            }

            NSData *jsonData = [eventInfo dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSMutableDictionary *eventDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                             options:NSJSONReadingMutableContainers
                                                                               error:&error];
            if(error || !eventDict) {
                return;
            }

            if (enableVerify) {
                NSString *serverUrl = eventDict[@"server_url"];
                if (![self.network isSameProjectWithURLString:serverUrl]) {
                    SALogError(@"Server_url verified faild, Web event lost! Web server_url = '%@'",serverUrl);
                    return;
                }
            }

            NSString *type = eventDict[kSAEventType];
            NSString *bestId = self.distinctId;

            if([type isEqualToString:kSAEventTypeSignup]) {
                eventDict[@"original_id"] = self.anonymousId;
            } else {
                eventDict[kSAEventDistinctId] = bestId;
            }
            eventDict[kSAEventTrackId] = @(arc4random());

            NSMutableDictionary *libMDic = eventDict[kSAEventLib];
            //update lib $app_version from super properties
            NSDictionary *superProperties = [self.superProperty currentSuperProperties];
            id appVersion = superProperties[kSAEventPresetPropertyAppVersion] ?: self.presetProperty.appVersion;
            if (appVersion) {
                libMDic[kSAEventPresetPropertyAppVersion] = appVersion;
            }

            NSMutableDictionary *automaticPropertiesCopy = [NSMutableDictionary dictionaryWithDictionary:self.presetProperty.automaticProperties];
            [automaticPropertiesCopy removeObjectForKey:kSAEventPresetPropertyLib];
            [automaticPropertiesCopy removeObjectForKey:kSAEventPresetPropertyLibVersion];

            NSMutableDictionary *propertiesDict = eventDict[kSAEventProperties];
            if([type isEqualToString:kSAEventTypeTrack] || [type isEqualToString:kSAEventTypeSignup]) {
                // track / track_signup 类型的请求，还是要加上各种公共property
                // 这里注意下顺序，按照优先级从低到高，依次是automaticProperties, superProperties,dynamicSuperPropertiesDict,propertieDict
                [propertiesDict addEntriesFromDictionary:automaticPropertiesCopy];

                NSDictionary *dynamicSuperPropertiesDict = [self.superProperty acquireDynamicSuperProperties];
                [propertiesDict addEntriesFromDictionary:self.superProperty.currentSuperProperties];
                [propertiesDict addEntriesFromDictionary:dynamicSuperPropertiesDict];

                // 每次 track 时手机网络状态
                [propertiesDict addEntriesFromDictionary:[self.presetProperty currentNetworkProperties]];

                //  是否首日访问
                if([type isEqualToString:kSAEventTypeTrack]) {
                    propertiesDict[kSAEventPresetPropertyIsFirstDay] = @([self.presetProperty isFirstDay]);
                }
                [propertiesDict removeObjectForKey:@"_nocache"];

                // 添加 DeepLink 来源渠道参数。优先级最高，覆盖 H5 传过来的同名字段
                [propertiesDict addEntriesFromDictionary:SAModuleManager.sharedInstance.latestUtmProperties];
            }

            [eventDict removeObjectForKey:@"_nocache"];
            [eventDict removeObjectForKey:@"server_url"];

            // $project & $token
            NSString *project = propertiesDict[kSAEventCommonOptionalPropertyProject];
            NSString *token = propertiesDict[kSAEventCommonOptionalPropertyToken];
            id timeNumber = propertiesDict[kSAEventCommonOptionalPropertyTime];

            if (project) {
                [propertiesDict removeObjectForKey:kSAEventCommonOptionalPropertyProject];
                eventDict[kSAEventProject] = project;
            }
            if (token) {
                [propertiesDict removeObjectForKey:kSAEventCommonOptionalPropertyToken];
                eventDict[kSAEventToken] = token;
            }
            if (timeNumber) { //包含 $time
                NSNumber *customTime = nil;
                if ([timeNumber isKindOfClass:[NSDate class]]) {
                    customTime = @([(NSDate *)timeNumber timeIntervalSince1970] * 1000);
                } else if ([timeNumber isKindOfClass:[NSNumber class]]) {
                    customTime = timeNumber;
                }

                if (!customTime) {
                    SALogError(@"H5 $time '%@' invalid，Please check the value", timeNumber);
                } else if ([customTime compare:@(kSAEventCommonOptionalPropertyTimeInt)] == NSOrderedAscending) {
                    SALogError(@"H5 $time error %@，Please check the value", timeNumber);
                } else {
                    timeStamp = @([customTime unsignedLongLongValue]);
                }
                [propertiesDict removeObjectForKey:kSAEventCommonOptionalPropertyTime];
            }

            eventDict[kSAEventTime] = timeStamp;

            //JS SDK Data add _hybrid_h5 flag
            eventDict[kSAEventHybridH5] = @(YES);

            NSMutableDictionary *enqueueEvent = [[self willEnqueueWithType:type andEvent:eventDict] mutableCopy];

            if (!enqueueEvent) {
                return;
            }
            // 只有当本地 loginId 不为空时才覆盖 H5 数据
            if (self.loginId) {
                enqueueEvent[kSAEventLoginId] = self.loginId;
            }
            enqueueEvent[kSAEventAnonymousId] = self.anonymousId;

            if([type isEqualToString:kSAEventTypeSignup]) {
                NSString *newLoginId = eventDict[kSAEventDistinctId];
                if ([self.identifier isValidLoginId:newLoginId]) {
                    [self.identifier login:newLoginId];
                    enqueueEvent[kSAEventLoginId] = newLoginId;
                    [[NSNotificationCenter defaultCenter] postNotificationName:SA_TRACK_EVENT_H5_NOTIFICATION object:nil userInfo:[enqueueEvent copy]];
                    [self.eventTracker trackEvent:enqueueEvent isSignUp:YES];
                    SALogDebug(@"\n【track event from H5】:\n%@", enqueueEvent);
                    [[NSNotificationCenter defaultCenter] postNotificationName:SA_TRACK_LOGIN_NOTIFICATION object:nil];
                }
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:SA_TRACK_EVENT_H5_NOTIFICATION object:nil userInfo:[enqueueEvent copy]];
                [self.eventTracker trackEvent:enqueueEvent];
                SALogDebug(@"\n【track event from H5】:\n%@", enqueueEvent);
            }
        } @catch (NSException *exception) {
            SALogError(@"%@: %@", self, exception);
        }
    });
}
@end


#pragma mark - People analytics

@implementation SensorsAnalyticsPeople

- (void)set:(NSDictionary *)profileDict {
    if (profileDict) {
        [[SensorsAnalyticsSDK sharedInstance] profile:SA_PROFILE_SET properties:profileDict];
    }
}

- (void)setOnce:(NSDictionary *)profileDict {
    if (profileDict) {
        [[SensorsAnalyticsSDK sharedInstance] profile:SA_PROFILE_SET_ONCE properties:profileDict];
    }
}

- (void)set:(NSString *) profile to:(id)content {
    if (profile && content) {
        [[SensorsAnalyticsSDK sharedInstance] profile:SA_PROFILE_SET properties:@{profile: content}];
    }
}

- (void)setOnce:(NSString *) profile to:(id)content {
    if (profile && content) {
        [[SensorsAnalyticsSDK sharedInstance] profile:SA_PROFILE_SET_ONCE properties:@{profile: content}];
    }
}

- (void)unset:(NSString *) profile {
    if (profile) {
        [[SensorsAnalyticsSDK sharedInstance] profile:SA_PROFILE_UNSET properties:@{profile: @""}];
    }
}

- (void)increment:(NSString *)profile by:(NSNumber *)amount {
    if (profile && amount) {
        SAProfileIncrementEventObject *object = [[SAProfileIncrementEventObject alloc] initWithType:SA_PROFILE_INCREMENT];
        [SensorsAnalyticsSDK.sharedInstance asyncTrackEventObject:object properties:@{profile: amount}];
    }
}

- (void)increment:(NSDictionary *)profileDict {
    if (profileDict) {
        SAProfileIncrementEventObject *object = [[SAProfileIncrementEventObject alloc] initWithType:SA_PROFILE_INCREMENT];
        [SensorsAnalyticsSDK.sharedInstance asyncTrackEventObject:object properties:profileDict];
    }
}

- (void)append:(NSString *)profile by:(NSObject<NSFastEnumeration> *)content {
    if (profile && content) {
        if ([content isKindOfClass:[NSSet class]] || [content isKindOfClass:[NSArray class]]) {
            SAProfileAppendEventObject *object = [[SAProfileAppendEventObject alloc] initWithType:SA_PROFILE_APPEND];
            [SensorsAnalyticsSDK.sharedInstance asyncTrackEventObject:object properties:@{profile: content}];
        }
    }
}

- (void)deleteUser {
    [[SensorsAnalyticsSDK sharedInstance] profile:SA_PROFILE_DELETE properties:@{}];
}

@end

#pragma mark - Deprecated
@implementation SensorsAnalyticsSDK (Deprecated)

+ (SensorsAnalyticsSDK *)sharedInstanceWithConfig:(nonnull SAConfigOptions *)configOptions {
    [self startWithConfigOptions:configOptions];
    return sharedInstance;
}

+ (SensorsAnalyticsSDK *)sharedInstanceWithServerURL:(NSString *)serverURL
                                        andDebugMode:(SensorsAnalyticsDebugMode)debugMode {
    return [SensorsAnalyticsSDK sharedInstanceWithServerURL:serverURL
                                           andLaunchOptions:nil andDebugMode:debugMode];
}

+ (SensorsAnalyticsSDK *)sharedInstanceWithServerURL:(NSString *)serverURL
                                    andLaunchOptions:(NSDictionary *)launchOptions
                                        andDebugMode:(SensorsAnalyticsDebugMode)debugMode {
    NSAssert(sensorsdata_is_same_queue(dispatch_get_main_queue()), @"神策 iOS SDK 必须在主线程里进行初始化，否则会引发无法预料的问题（比如丢失 $AppStart 事件）。");
    dispatch_once(&sdkInitializeOnceToken, ^{
        sharedInstance = [[self alloc] initWithServerURL:serverURL
                                        andLaunchOptions:launchOptions
                                            andDebugMode:debugMode];
        [SAModuleManager startWithConfigOptions:sharedInstance.configOptions debugMode:debugMode];
        [sharedInstance startRemoteConfig];
        [sharedInstance startAppLifecycle];
    });
    return sharedInstance;
}

+ (SensorsAnalyticsSDK *)sharedInstanceWithServerURL:(nonnull NSString *)serverURL
                                    andLaunchOptions:(NSDictionary * _Nullable)launchOptions {
    NSAssert(sensorsdata_is_same_queue(dispatch_get_main_queue()), @"神策 iOS SDK 必须在主线程里进行初始化，否则会引发无法预料的问题（比如丢失 $AppStart 事件）。");
    dispatch_once(&sdkInitializeOnceToken, ^{
        sharedInstance = [[self alloc] initWithServerURL:serverURL
                                        andLaunchOptions:launchOptions
                                            andDebugMode:SensorsAnalyticsDebugOff];
        [SAModuleManager startWithConfigOptions:sharedInstance.configOptions debugMode:SensorsAnalyticsDebugOff];
        [sharedInstance startRemoteConfig];
        [sharedInstance startAppLifecycle];
    });
    return sharedInstance;
}

- (UInt64)flushInterval {
    @synchronized(self) {
        return self.configOptions.flushInterval;
    }
}

- (void)setFlushInterval:(UInt64)interval {
    @synchronized(self) {
        if (interval < 5 * 1000) {
            interval = 5 * 1000;
        }
        self.configOptions.flushInterval = (NSInteger)interval;
    }
    [self flush];
    [self stopFlushTimer];
    [self startFlushTimer];
}

- (UInt64)flushBulkSize {
    @synchronized(self) {
        return self.configOptions.flushBulkSize;
    }
}

- (void)setFlushBulkSize:(UInt64)bulkSize {
    @synchronized(self) {
        //加上最小值保护，50
        NSInteger newBulkSize = (NSInteger)bulkSize;
        self.configOptions.flushBulkSize = newBulkSize >= 50 ? newBulkSize : 50;
    }
}

- (BOOL)flushBeforeEnterBackground {
    @synchronized(self) {
        return self.configOptions.flushBeforeEnterBackground;
    }
}

- (void)setFlushBeforeEnterBackground:(BOOL)flushBeforeEnterBackground {
    @synchronized(self) {
        self.configOptions.flushBeforeEnterBackground = flushBeforeEnterBackground;
    }
}

- (void)setDebugMode:(SensorsAnalyticsDebugMode)debugMode {
    SAModuleManager.sharedInstance.debugMode = debugMode;
}

- (BOOL)isViewControllerStringIgnored:(NSString *)viewControllerClassName {
    if (viewControllerClassName == nil) {
        return NO;
    }
    
    if (_ignoredViewControllers.count > 0 && [_ignoredViewControllers containsObject:viewControllerClassName]) {
        return YES;
    }
    return NO;
}

- (void)trackTimerBegin:(NSString *)event {
    [self trackTimerStart:event];
}

- (void)trackTimerBegin:(NSString *)event withTimeUnit:(SensorsAnalyticsTimeUnit)timeUnit {
    UInt64 currentSysUpTime = [self.class getSystemUpTime];
    dispatch_async(self.serialQueue, ^{
        [self.trackTimer trackTimerStart:event timeUnit:timeUnit currentSysUpTime:currentSysUpTime];
    });
}

- (void)trackTimer:(NSString *)event {
    [self trackTimer:event withTimeUnit:SensorsAnalyticsTimeUnitMilliseconds];
}

- (void)trackTimer:(NSString *)event withTimeUnit:(SensorsAnalyticsTimeUnit)timeUnit {
    UInt64 currentSysUpTime = [self.class getSystemUpTime];
    dispatch_async(self.serialQueue, ^{
        [self.trackTimer trackTimerStart:event timeUnit:timeUnit currentSysUpTime:currentSysUpTime];
    });
}

- (void)trackSignUp:(NSString *)newDistinctId withProperties:(NSDictionary *)propertieDict {
    [self identify:newDistinctId];
    SASignUpEventObject *object = [[SASignUpEventObject alloc] initWithEventId:kSAEventNameSignUp];
    [self asyncTrackEventObject:object properties:propertieDict];
}

- (void)trackSignUp:(NSString *)newDistinctId {
    [self trackSignUp:newDistinctId withProperties:nil];
}


- (void)trackViewScreen:(NSString *)url withProperties:(NSDictionary *)properties {
    NSDictionary *eventProperties = [_referrerManager propertiesWithURL:url eventProperties:properties serialQueue:self.serialQueue];
    SAPresetEventObject *object = [[SAPresetEventObject alloc] initWithEventId:kSAEventNameAppViewScreen];
    [self asyncTrackEventObject:object properties:eventProperties];
}

@end
