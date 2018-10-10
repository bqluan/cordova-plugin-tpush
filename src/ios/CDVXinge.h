#import <Cordova/CDVPlugin.h>
#import <XGPush.h>

@interface CDVXinge : CDVPlugin

@property (nonatomic, copy) NSString *xgAccessID;
@property (nonatomic, copy) NSString *xgAccessKey;

- (void)registerDevice:(CDVInvokedUrlCommand *)command;

- (void)bindAccount:(CDVInvokedUrlCommand *)command;

- (void)unbindAccount:(CDVInvokedUrlCommand *)command;

@end
