#import "AppDelegate+CDVXinge.h"

@implementation AppDelegate (CDVXinge)

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    NSLog(@"[AppDelegate+CDVXinge] receive remote notification");
    [[NSNotificationCenter defaultCenter] postNotificationName: @"receivenotification" object:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"[AppDelegate+CDVXinge] register APNS fail.\n[AppDelegate+CDVXinge] reason : %@", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"registerDeviceFailed" object:nil];
}

/**
 收到通知消息的回调，通常此消息意味着有新数据可以读取（iOS 7.0+）

 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"[AppDelegate+CDVXinge] receive slient Notification");
    NSLog(@"[AppDelegate+CDVXinge] userinfo %@", userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName: @"receivenotification" object:userInfo];
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
