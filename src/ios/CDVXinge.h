#import <Cordova/CDVPlugin.h>
#import <XGPush.h>

@interface CDVXinge : CDVPlugin

@property (nonatomic) uint32_t xgAccessID;
@property (nonatomic, copy) NSString *xgAccessKey;
@property NSMutableArray* callbackIDs;

- (void) didReceiveRemoteNotification:(NSNotification*)notification;

- (void)onMessage:(CDVInvokedUrlCommand *)command;
- (void)registerDevice:(CDVInvokedUrlCommand *)command;
- (void)bindAccount:(CDVInvokedUrlCommand *)command;
- (void)unbindAccount:(CDVInvokedUrlCommand *)command;

@end
