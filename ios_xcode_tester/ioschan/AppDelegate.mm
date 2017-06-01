#import "AppDelegate.h"

#import <libmewutil/libmewutil.h>

#import <libmewchan/libmewchan.h>

#import "FakeMewchan.h"

@interface AppDelegate() {

    FakeMewchan *_mewchan;

}

@end

@implementation AppDelegate


#pragma mark - Application lifecycle


- (BOOL)               application: (UIApplication *)application
    willFinishLaunchingWithOptions: (NSDictionary *)launchOptions {
    
    self->_mewchan = [[FakeMewchan alloc] init];
    
    [MCMewchanHelper registerDelegate: self->_mewchan];
    
    [self->_mewchan start];
    
    [self->_mewchan dispatchEvent: @{
                                     @"event": @"ios.application.willFinishLaunching",
                                     @"application": application,
                                     @"launchOptions": MCNoNil(launchOptions)
                                     }];

    return YES;
    
}


- (BOOL)              application: (UIApplication *)application
    didFinishLaunchingWithOptions: (NSDictionary *)launchOptions {
    
    [MCMewchanHelper executeAction: @{@"usage": @"ios.application.didFinishLaunching",
                                      @"application": application,
                                      @"launchOptions": MCNoNil(launchOptions)
                                      }];
    
    return YES;

}

- (void)                                 application: (UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken: (NSData *)deviceToken
{
    [MCMewchanHelper executeAction: @{@"usage": @"ios.application.didRegisterForRemoteNotifications",
                                      @"application": application,
                                      @"deviceToken": MCNoNil(deviceToken)
                                      }];
}

- (void)                                 application: (UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError: (NSError *)error
{
    [MCMewchanHelper executeAction: @{@"usage": @"ios.application.didFailToRegisterForRemoteNotifications",
                                      @"application": application,
                                      @"error": error
                                      }];
}

- (void)             application: (UIApplication *)application
    didReceiveRemoteNotification: (NSDictionary *)userInfo
{
    [MCMewchanHelper executeAction: @{@"usage": @"ios.application.didReceiveRemoteNotification",
                                      @"application": application,
                                      @"userInfo": MCNoNil(userInfo)
                                      }];
}

- (void)             application: (UIApplication *)application
    didReceiveRemoteNotification: (NSDictionary *)userInfo
          fetchCompletionHandler: (void (^)(UIBackgroundFetchResult result))handler
{
    
    [self application: application didReceiveRemoteNotification: userInfo];
    
    handler(UIBackgroundFetchResultNoData);
    
}

@end
