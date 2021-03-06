//
// SAEncryptManager.m
// SensorsAnalyticsSDK
//
// Created by å¼ æè¶ð on 2020/11/25.
// Copyright Â© 2020 Sensors Data Co., Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "SAEncryptManager.h"
#import "SAValidator.h"
#import "SAURLUtils.h"
#import "SAAlertController.h"
#import "SAFileStore.h"
#import "SAJSONUtil.h"
#import "SAGzipUtility.h"
#import "SALog.h"
#import "SARSAPluginEncryptor.h"
#import "SAECCPluginEncryptor.h"
#import "SAConfigOptions+Private.h"
#import "SASecretKeyFactory.h"

static NSString * const kSAEncryptSecretKey = @"SAEncryptSecretKey";

@interface SAEncryptManager ()

/// å½åä½¿ç¨çå å¯æä»¶
@property (nonatomic, strong) id<SAEncryptProtocol> encryptor;

/// å½åæ¯æçå å¯æä»¶åè¡¨
@property (nonatomic, copy) NSArray<id<SAEncryptProtocol>> *encryptors;

@property (nonatomic, copy) NSString *encryptedSymmetricKey;

/// éå¯¹ç§°å¯é¥å å¯å¨çå¬é¥ï¼RSA/ECC çå¬é¥ï¼
@property (nonatomic, strong) SASecretKey *secretKey;

@end

@implementation SAEncryptManager

#pragma mark - SAModuleProtocol

- (void)setConfigOptions:(SAConfigOptions *)configOptions {
    _configOptions = configOptions;
    self.encryptors = configOptions.encryptors;
    [self updateEncryptor];
}

#pragma mark - SAOpenURLProtocol

- (BOOL)canHandleURL:(nonnull NSURL *)url {
    return [url.host isEqualToString:@"encrypt"];
}

- (BOOL)handleURL:(nonnull NSURL *)url {
    NSString *message = @"å½å App æªå¼å¯å å¯ï¼è¯·å¼å¯å å¯ååè¯";

    if (self.enable) {
        NSDictionary *paramDic = [SAURLUtils queryItemsWithURL:url];
        NSString *urlVersion = paramDic[@"v"];
        NSString *urlKey = paramDic[@"key"];

        if ([SAValidator isValidString:urlVersion] && [SAValidator isValidString:urlKey]) {
            SASecretKey *secretKey = [self loadCurrentSecretKey];
            NSString *loadVersion = [@(secretKey.version) stringValue];
            // url ä¸­ç key ä¸º encode ä¹åç
            NSString *loadKey = [secretKey.key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];

            if ([loadVersion isEqualToString:urlVersion] && [loadKey isEqualToString:urlKey]) {
                message = @"å¯é¥éªè¯éè¿ï¼æéå¯é¥ä¸ App ç«¯å¯é¥ç¸å";
            } else if (![SAValidator isValidString:loadKey]) {
                message = @"å¯é¥éªè¯ä¸éè¿ï¼App ç«¯å¯é¥ä¸ºç©º";
            } else {
                message = [NSString stringWithFormat:@"å¯é¥éªè¯ä¸éè¿ï¼æéå¯é¥ä¸ App ç«¯å¯é¥ä¸ç¸åãæéå¯é¥çæ¬:%@ï¼App ç«¯å¯é¥çæ¬:%@", urlVersion, loadVersion];
            }
        } else {
            message = @"å¯é¥éªè¯ä¸éè¿ï¼æéå¯é¥æ æ";
        }
    }

    SAAlertController *alertController = [[SAAlertController alloc] initWithTitle:nil message:message preferredStyle:SAAlertControllerStyleAlert];
    [alertController addActionWithTitle:@"ç¡®è®¤" style:SAAlertActionStyleDefault handler:nil];
    [alertController show];
    return YES;
}

#pragma mark - SAEncryptModuleProtocol
- (BOOL)hasSecretKey {
    // å½å¯ä»¥è·åå°ç§é¥æ¶ï¼ä¸éè¦å¼ºå¶æ§è§¦åè¿ç¨éç½®è¯·æ±ç§é¥
    SASecretKey *sccretKey = [self loadCurrentSecretKey];
    return (sccretKey.key.length > 0);
}

- (NSDictionary *)encryptJSONObject:(id)obj {
    @try {
        if (!obj) {
            SALogDebug(@"Enable encryption but the input obj is invalid!");
            return nil;
        }

        if (!self.encryptor) {
            SALogDebug(@"Enable encryption but the secret key is invalid!");
            return nil;
        }

        if (![self encryptSymmetricKey]) {
            SALogDebug(@"Enable encryption but encrypt symmetric key is failed!");
            return nil;
        }

        // ä½¿ç¨ gzip è¿è¡åç¼©
        NSData *jsonData = [SAJSONUtil JSONSerializeObject:obj];
        NSString *encodingString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSData *encodingData = [encodingString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *zippedData = [SAGzipUtility gzipData:encodingData];

        // å å¯æ°æ®
        NSString *encryptedString =  [self.encryptor encryptEvent:zippedData];
        if (![SAValidator isValidString:encryptedString]) {
            return nil;
        }

        // å°è£å å¯çæ°æ®ç»æ
        NSMutableDictionary *secretObj = [NSMutableDictionary dictionary];
        secretObj[@"pkv"] = @(self.secretKey.version);
        secretObj[@"ekey"] = self.encryptedSymmetricKey;
        secretObj[@"payload"] = encryptedString;
        return [NSDictionary dictionaryWithDictionary:secretObj];
    } @catch (NSException *exception) {
        SALogError(@"%@ error: %@", self, exception);
        return nil;
    }
}

- (BOOL)encryptSymmetricKey {
    if (self.encryptedSymmetricKey) {
        return YES;
    }
    NSString *publicKey = self.secretKey.key;
    self.encryptedSymmetricKey = [self.encryptor encryptSymmetricKeyWithPublicKey:publicKey];
    return self.encryptedSymmetricKey != nil;
}

#pragma mark - handle remote config for secret key
- (void)handleEncryptWithConfig:(NSDictionary *)encryptConfig {
    if (!encryptConfig) {
        return;
    }
    SASecretKey *secretKey = [SASecretKeyFactory generateSecretKeyWithRemoteConfig:encryptConfig];
    if (![self encryptorWithSecretKey:secretKey]) {
        //å½åç§é¥æ²¡æå¯¹åºçå å¯å¨
        return;
    }
    // å­å¨è¯·æ±çå¬é¥
    [self saveRequestSecretKey:secretKey];
    // æ´æ°å å¯æé å¨
    [self updateEncryptor];
}

- (void)updateEncryptor {
    @try {
        SASecretKey *secretKey = [self loadCurrentSecretKey];
        if (![SAValidator isValidString:secretKey.key]) {
            return;
        }

        if (secretKey.version <= 0) {
            return;
        }

        // è¿åçå¯é¥ä¸å·²æçå¯é¥ä¸æ ·åä¸éè¦æ´æ°
        if ([self isSameSecretKey:self.secretKey newSecretKey:secretKey]) {
            return;
        }

        id<SAEncryptProtocol> encryptor = [self filterEncrptor:secretKey];
        if (!encryptor) {
            return;
        }

        NSString *encryptedSymmetricKey = [encryptor encryptSymmetricKeyWithPublicKey:secretKey.key];
        if ([SAValidator isValidString:encryptedSymmetricKey]) {
            // æ´æ°å¯é¥
            self.secretKey = secretKey;
            // æ´æ°å å¯æä»¶
            self.encryptor = encryptor;
            // éæ°çæå å¯æä»¶çå¯¹ç§°å¯é¥
            self.encryptedSymmetricKey = encryptedSymmetricKey;
        }
    } @catch (NSException *exception) {
        SALogError(@"%@ error: %@", self, exception);
    }
}

- (BOOL)isSameSecretKey:(SASecretKey *)currentSecretKey newSecretKey:(SASecretKey *)newSecretKey {
    if (currentSecretKey.version != newSecretKey.version) {
        return NO;
    }
    if (![currentSecretKey.key isEqualToString:newSecretKey.key]) {
        return NO;
    }
    if (![currentSecretKey.symmetricEncryptType isEqualToString:newSecretKey.symmetricEncryptType]) {
        return NO;
    }
    if (![currentSecretKey.asymmetricEncryptType isEqualToString:newSecretKey.asymmetricEncryptType]) {
        return NO;
    }
    return YES;
}

- (id<SAEncryptProtocol>)filterEncrptor:(SASecretKey *)secretKey {
    id<SAEncryptProtocol> encryptor = [self encryptorWithSecretKey:secretKey];
    // ç¹æ®å¤çï¼å½ç§é¥ç±»åä¸º ECC ä¸æªéæ ECC å å¯åºæ¶ï¼è¿è¡æ­è¨æç¤º
    if ((!NSClassFromString(kSAEncryptECCClassName) && [encryptor isKindOfClass:SAECCPluginEncryptor.class])) {
        NSAssert(NO, @"\næ¨ä½¿ç¨äº ECC å¯é¥ï¼ä½æ¯å¹¶æ²¡æéæ ECC å å¯åºã\n â¢ å¦æä½¿ç¨æºç éæ ECC å å¯åºï¼è¯·æ£æ¥æ¯å¦åå«åä¸º SAECCEncrypt çæä»¶? \n â¢ å¦æä½¿ç¨ CocoaPods éæ SDKï¼è¯·ä¿®æ¹ Podfile æä»¶å¹¶å¢å  ECC æ¨¡åï¼ä¾å¦ï¼pod 'SensorsAnalyticsEncrypt'ã\n");
        return nil;
    }
    return encryptor;
}

- (id<SAEncryptProtocol>)encryptorWithSecretKey:(SASecretKey *)secretKey {
    if (!secretKey) {
        return nil;
    }
    __block id<SAEncryptProtocol> encryptor;
    [self.encryptors enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<SAEncryptProtocol> obj, NSUInteger idx, BOOL *stop) {
        if ([self checkEncryptType:obj secretKey:secretKey]) {
            encryptor = obj;
            *stop = YES;
        }
    }];
    return encryptor;
}

- (BOOL)checkEncryptType:(id<SAEncryptProtocol>)encryptor secretKey:(SASecretKey *)secretKey {
    if (![[encryptor symmetricEncryptType] isEqualToString:secretKey.symmetricEncryptType]) {
        return NO;
    }
    if (![[encryptor asymmetricEncryptType] isEqualToString:secretKey.asymmetricEncryptType]) {
        return NO;
    }
    return YES;
}

#pragma mark - archive/unarchive secretKey
- (void)saveRequestSecretKey:(SASecretKey *)secretKey {
    if (!secretKey) {
        return;
    }

    void (^saveSecretKey)(SASecretKey *) = self.configOptions.saveSecretKey;
    if (saveSecretKey) {
        // éè¿ç¨æ·çåè°ä¿å­å¬é¥
        saveSecretKey(secretKey);

        [SAFileStore archiveWithFileName:kSAEncryptSecretKey value:nil];

        SALogDebug(@"Save secret key by saveSecretKey callback, pkv : %ld, public_key : %@", (long)secretKey.version, secretKey.key);
    } else {
        // å­å¨å°æ¬å°
        NSData *secretKeyData = [NSKeyedArchiver archivedDataWithRootObject:secretKey];
        [SAFileStore archiveWithFileName:kSAEncryptSecretKey value:secretKeyData];

        SALogDebug(@"Save secret key by localSecretKey, pkv : %ld, public_key : %@", (long)secretKey.version, secretKey.key);
    }
}

- (SASecretKey *)loadCurrentSecretKey {
    SASecretKey *secretKey = nil;

    SASecretKey *(^loadSecretKey)(void) = self.configOptions.loadSecretKey;
    if (loadSecretKey) {
        // éè¿ç¨æ·çåè°è·åå¬é¥
        secretKey = loadSecretKey();

        if (secretKey) {
            SALogDebug(@"Load secret key from loadSecretKey callback, pkv : %ld, public_key : %@", (long)secretKey.version, secretKey.key);
        } else {
            SALogDebug(@"Load secret key from loadSecretKey callback failed!");
        }
    } else {
        // éè¿æ¬å°è·åå¬é¥
        id secretKeyData = [SAFileStore unarchiveWithFileName:kSAEncryptSecretKey];
        if ([SAValidator isValidData:secretKeyData]) {
            secretKey = [NSKeyedUnarchiver unarchiveObjectWithData:secretKeyData];
        }

        if (secretKey) {
            SALogDebug(@"Load secret key from localSecretKey, pkv : %ld, public_key : %@", (long)secretKey.version, secretKey.key);
        } else {
            SALogDebug(@"Load secret key from localSecretKey failed!");
        }
    }

    // å¼å®¹èçæ¬ä¿å­çç§é¥
    if (!secretKey.symmetricEncryptType) {
        secretKey.symmetricEncryptType = kSAAlgorithmTypeAES;
    }
    if (!secretKey.asymmetricEncryptType) {
        BOOL isECC = [secretKey.key hasPrefix:kSAAlgorithmTypeECC];
        secretKey.asymmetricEncryptType = isECC ? kSAAlgorithmTypeECC : kSAAlgorithmTypeRSA;
    }
    return secretKey;
}

@end
