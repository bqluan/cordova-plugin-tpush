#import "CDVXinge.h"

NSString *XG_ACCESS_ID = @"xg_access_id";
NSString *XG_ACCESS_KEY = @"xg_access_key";

@interface CDVXinge ()<XGPushDelegate, XGPushTokenManagerDelegate>
@end

@implementation CDVXinge

- (void)pluginInitialize {
    // 注册接收回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRemoteNotification:) name:@"receivenotification" object:nil];

    self.xgAccessID = [[[self.commandDelegate settings] objectForKey:XG_ACCESS_ID] unsignedIntValue];
    self.xgAccessKey = [[self.commandDelegate settings] objectForKey:XG_ACCESS_KEY];
    self.callbackIDs = [[NSMutableArray alloc] init];

    [[XGPush defaultManager] startXGWithAppID:self.xgAccessID appKey:self.xgAccessKey delegate:self];
    [[XGPush defaultManager] setXgApplicationBadgeNumber:0];
    [[XGPush defaultManager] setBadge:0];
}

- (void) didReceiveRemoteNotification:(NSNotification*)notification {
    NSLog(@"[CDVXinge] receive notification: %@", notification);
    [self.callbackIDs enumerateObjectsUsingBlock:^(id callbackId, NSUInteger idx, BOOL *stop) {
        NSLog(@"[CDVXinge] callbackId: %@", callbackId);
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:notification.object];
        [result setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }];
}

- (void)onMessage:(CDVInvokedUrlCommand *)command {
    NSLog(@"[CDVXinge] onMessage()");
    [self.callbackIDs addObject:command.callbackId];
}

- (void)registerDevice:(CDVInvokedUrlCommand *)command {
    NSLog(@"[CDVXinge] registerDevice()");
}

- (void)bindAccount:(CDVInvokedUrlCommand *)command {
    NSString* account = [command.arguments objectAtIndex:0];
    NSLog(@"[CDVXinge] bindAccount(%@)", account);
    [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:account type:XGPushTokenBindTypeAccount];
}

- (void)unbindAccount:(CDVInvokedUrlCommand *)command {
    NSString* account = [command.arguments objectAtIndex:0];
    NSLog(@"[CDVXinge] unbindAccount(%@)", account);
    [[XGPushTokenManager defaultTokenManager] unbindWithIdentifer:account type:XGPushTokenBindTypeAccount];
}

#pragma mark - XGPushDelegate
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(NSError *)error {
    NSLog(@"[CDVXinge] 启动信鸽服务%@", (isSuccess?@"成功":@"失败"));
}

- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(NSError *)error {
    NSLog(@"[CDVXinge] 注销信鸽服务%@", (isSuccess?@"成功":@"失败"));
}

- (void)xgPushDidRegisteredDeviceToken:(NSString *)deviceToken error:(NSError *)error {
    NSLog(@"[CDVXinge] 注册信鸽%@, token %@, error %@", (error?@"失败":@"成功"), deviceToken, error);
}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知
// App 用户选择通知中的行为
// App 用户在通知中心清除消息
// 无论本地推送还是远程推送都会走这个回调
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"[CDVXinge] click notification：%@", response.notification.request.content.userInfo);

    [self.callbackIDs enumerateObjectsUsingBlock:^(id callbackId, NSUInteger idx, BOOL *stop) {
        NSLog(@"[CDVXinge] callbackId: %@", callbackId);
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response.notification.request.content.userInfo];
        [result setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }];

    NSInteger number = [[XGPush defaultManager] xgApplicationBadgeNumber];
    [[XGPush defaultManager] setXgApplicationBadgeNumber:number - 1];
    [[XGPush defaultManager] setBadge:number - 1];
    [[XGPush defaultManager] reportXGNotificationResponse:response];

    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [[XGPush defaultManager] reportXGNotificationInfo:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif

- (void)xgPushDidReceiveRemoteNotification:(id)notification withCompletionHandler:(void (^)(NSUInteger))completionHandler {
    NSLog(@"[CDVXinge] xgPushDidReceiveRemoteNotification");
    if ([notification isKindOfClass:[NSDictionary class]]) {
        [[XGPush defaultManager] reportXGNotificationInfo:(NSDictionary *)notification];
        completionHandler(UIBackgroundFetchResultNewData);
    } else if ([notification isKindOfClass:[UNNotification class]]) {
        [[XGPush defaultManager] reportXGNotificationInfo:((UNNotification *)notification).request.content.userInfo];
        completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    }
}

- (void)xgPushDidSetBadge:(BOOL)isSuccess error:(NSError *)error {
    NSLog(@"[CDVXinge] 设置应用角标%@, error %@", (isSuccess?@"成功":@"失败"), error);
}

#pragma mark - XGPushTokenManagerDelegate
- (void)xgPushDidBindWithIdentifier:(NSString *)identifier type:(XGPushTokenBindType)type error:(NSError *)error {
    NSLog(@"绑定%@%@%@, error %@", ((type == XGPushTokenBindTypeAccount)?@"账号":@"标签"), identifier, ((error == nil)?@"成功":@"失败"), error);
}

- (void)xgPushDidUnbindWithIdentifier:(NSString *)identifier type:(XGPushTokenBindType)type error:(NSError *)error {
    NSLog(@"解绑%@%@%@, error %@", ((type == XGPushTokenBindTypeAccount)?@"账号":@"标签"), identifier, ((error == nil)?@"成功":@"失败"), error);
}

- (void)xgPushDidBindWithIdentifiers:(NSArray<NSString *> *)identifiers type:(XGPushTokenBindType)type error:(NSError *)error {
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifiers, error);
}

- (void)xgPushDidUnbindWithIdentifiers:(NSArray<NSString *> *)identifiers type:(XGPushTokenBindType)type error:(NSError *)error {
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifiers, error);
}

- (void)xgPushDidUpdatedBindedIdentifiers:(NSArray<NSString *> *)identifiers bindType:(XGPushTokenBindType)type error:(NSError *)error {
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifiers, error);
}

- (void)xgPushDidClearAllIdentifiers:(XGPushTokenBindType)type error:(NSError *)error {
    NSLog(@"%s, type is %lu, error %@", __FUNCTION__, (unsigned long)type, error);
}

@end
