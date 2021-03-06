//
// SAEventFlush.m
// SensorsAnalyticsSDK
//
// Created by å¼ æè¶ð on 2020/6/18.
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

#import "SAEventFlush.h"
#import "NSString+HashCode.h"
#import "SAGzipUtility.h"
#import "SAModuleManager.h"
#import "SAObject+SAConfigOptions.h"
#import "SANetwork.h"
#import "SALog.h"

@interface SAEventFlush ()

@property (nonatomic, strong) dispatch_semaphore_t flushSemaphore;

@end

@implementation SAEventFlush

- (dispatch_semaphore_t)flushSemaphore {
    if (!_flushSemaphore) {
        _flushSemaphore = dispatch_semaphore_create(0);
    }
    return _flushSemaphore;
}

#pragma mark - build

// 1. åå®æè¿ä¸ç³»å Json å­ç¬¦ä¸²çæ¼æ¥
- (NSString *)buildFlushJSONStringWithEventRecords:(NSArray<SAEventRecord *> *)records {
    NSMutableArray *contents = [NSMutableArray arrayWithCapacity:records.count];
    for (SAEventRecord *record in records) {
        if ([record isValid]) {
            // éè¦åæ·»å  flush timeï¼åè¿è¡ json æ¼æ¥
            [record addFlushTime];
            [contents addObject:record.content];
        }
    }
    return [NSString stringWithFormat:@"[%@]", [contents componentsJoinedByString:@","]];
}

- (NSString *)buildFlushEncryptJSONStringWithEventRecords:(NSArray<SAEventRecord *> *)records {
    // åå§åç¨äºä¿å­åå¹¶åçäºä»¶æ°æ®
    NSMutableArray *encryptRecords = [NSMutableArray arrayWithCapacity:records.count];
    // ç¨äºä¿å­å½åå­å¨çææ ekey
    NSMutableArray *ekeys = [NSMutableArray arrayWithCapacity:records.count];
    for (SAEventRecord *record in records) {
        NSInteger index = [ekeys indexOfObject:record.ekey];
        if (index == NSNotFound) {
            [record removePayload];
            [encryptRecords addObject:record];

            [ekeys addObject:record.ekey];
        } else {
            [encryptRecords[index] mergeSameEKeyRecord:record];
        }
    }
    return [self buildFlushJSONStringWithEventRecords:encryptRecords];
}

// 2. å®æ HTTP è¯·æ±æ¼æ¥
- (NSData *)buildBodyWithJSONString:(NSString *)jsonString isEncrypted:(BOOL)isEncrypted {
    int gzip = 1; // gzip = 9 è¡¨ç¤ºå å¯ç¼ç 
    if (isEncrypted) {
        // å å¯æ°æ®å·²{ç»åè¿ gzip åç¼©å base64 å¤çäºï¼å°±ä¸éè¦åå¤çã
        gzip = 9;
    } else {
        // ä½¿ç¨gzipè¿è¡åç¼©
        NSData *zippedData = [SAGzipUtility gzipData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        // base64
        jsonString = [zippedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    }
    int hashCode = [jsonString sensorsdata_hashCode];
    jsonString = [jsonString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString *bodyString = [NSString stringWithFormat:@"crc=%d&gzip=%d&data_list=%@", hashCode, gzip, jsonString];
    return [bodyString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSURLRequest *)buildFlushRequestWithServerURL:(NSURL *)serverURL HTTPBody:(NSData *)HTTPBody {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL];
    request.timeoutInterval = 30;
    request.HTTPMethod = @"POST";
    request.HTTPBody = HTTPBody;
    // æ®éäºä»¶è¯·æ±ï¼ä½¿ç¨æ å UserAgent
    [request setValue:@"SensorsAnalytics iOS SDK" forHTTPHeaderField:@"User-Agent"];
    if (SAModuleManager.sharedInstance.debugMode == SensorsAnalyticsDebugOnly) {
        [request setValue:@"true" forHTTPHeaderField:@"Dry-Run"];
    }

    //Cookie
    [request setValue:self.cookie forHTTPHeaderField:@"Cookie"];

    return request;
}

- (void)requestWithRecords:(NSArray<SAEventRecord *> *)records completion:(void (^)(BOOL success))completion {
    [SAHTTPSession.sharedInstance.delegateQueue addOperationWithBlock:^{
        // å¤æ­æ¯å¦å å¯æ°æ®
        BOOL isEncrypted = self.enableEncrypt && records.firstObject.isEncrypted;
        // æ¼æ¥ json æ°æ®
        NSString *jsonString = isEncrypted ? [self buildFlushEncryptJSONStringWithEventRecords:records] : [self buildFlushJSONStringWithEventRecords:records];

        // ç½ç»è¯·æ±åè°å¤ç
        SAURLSessionTaskCompletionHandler handler = ^(NSData * _Nullable data, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error || ![response isKindOfClass:[NSHTTPURLResponse class]]) {
                SALogError(@"%@ network failure: %@", self, error ? error : @"Unknown error");
                return completion(NO);
            }

            NSInteger statusCode = response.statusCode;

            NSString *urlResponseContent = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *messageDesc = nil;
            if (statusCode >= 200 && statusCode < 300) {
                messageDesc = @"\nãvalid messageã\n";
            } else {
                messageDesc = @"\nãinvalid messageã\n";
                if (statusCode >= 300 && self.isDebugMode) {
                    NSString *errMsg = [NSString stringWithFormat:@"%@ flush failure with response '%@'.", self, urlResponseContent];
                    [SAModuleManager.sharedInstance showDebugModeWarning:errMsg];
                }
            }

            SALogDebug(@"==========================================================================");
            @try {
                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                SALogDebug(@"%@ %@: %@", self, messageDesc, dict);
            } @catch (NSException *exception) {
                SALogError(@"%@: %@", self, exception);
            }

            if (statusCode != 200) {
                SALogError(@"%@ ret_code: %ld, ret_content: %@", self, statusCode, urlResponseContent);
            }

            // 1ãå¼å¯ debug æ¨¡å¼ï¼é½å é¤ï¼
            // 2ãdebugOff æ¨¡å¼ä¸ï¼åªæ 5xx & 404 & 403 ä¸å ï¼å¶ä½åå ï¼
            BOOL successCode = (statusCode < 500 || statusCode >= 600) && statusCode != 404 && statusCode != 403;
            BOOL flushSuccess = self.isDebugMode || successCode;
            completion(flushSuccess);
        };

        // è½¬æ¢æåéç http ç body
        NSData *HTTPBody = [self buildBodyWithJSONString:jsonString isEncrypted:isEncrypted];
        NSURLRequest *request = [self buildFlushRequestWithServerURL:self.serverURL HTTPBody:HTTPBody];
        NSURLSessionDataTask *task = [SAHTTPSession.sharedInstance dataTaskWithRequest:request completionHandler:handler];
        [task resume];
    }];
}

- (void)flushEventRecords:(NSArray<SAEventRecord *> *)records completion:(void (^)(BOOL success))completion {
    __block BOOL flushSuccess = NO;
    // å½å¨ç¨åºç»æ­¢æ debug æ¨¡å¼ä¸ï¼ä½¿ç¨çº¿ç¨é
    BOOL isWait = self.flushBeforeEnterBackground || self.isDebugMode;
    [self requestWithRecords:records completion:^(BOOL success) {
        if (isWait) {
            flushSuccess = success;
            dispatch_semaphore_signal(self.flushSemaphore);
        } else {
            completion(success);
        }
    }];
    if (isWait) {
        dispatch_semaphore_wait(self.flushSemaphore, DISPATCH_TIME_FOREVER);
        completion(flushSuccess);
    }
}

@end
