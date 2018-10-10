#import "CDVXinge.h"

NSString *XG_ACCESS_ID = @"xg_access_id";
NSString *XG_ACCESS_KEY = @"xg_access_key";

@implementation CDVXinge

- (void)pluginInitialize {
    NSString *xgAccessID = [[self.commandDelegate settings] objectForKey:XG_ACCESS_ID];
    self.xgAccessID = xgAccessID;
    NSString *xgAccessKey = [[self.commandDelegate settings] objectForKey:XG_ACCESS_KEY];
    self.xgAccessKey = xgAccessKey;
}

- (void)registerDevice:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:(true)];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)bindAccount:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:(true)];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)unbindAccount:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:(true)];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
