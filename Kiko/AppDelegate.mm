//
//  AppDelegate.m
//  Kiko
//
//  Created by Garrett Davidson on 12/7/15.
//  Copyright © 2015 G&R. All rights reserved.
//

#import "AppDelegate.h"
#import "KikoAnimator.h"
#import "KikoFaceTracker.h"
#import <Parse/Parse.h>

#import "User.h"
#import "KikoCustomizations.h"

//#define AddingNewCustomizations

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupParse];
    [self setupNotificationsForApplication:application];
    [self refreshData];
    [self setupTracking];
    
    return YES;
}

void (^updatedBlock)(PFObject * _Nullable object, NSError * _Nullable error) = ^(PFObject * _Nullable object, NSError * _Nullable error){
    NSLog(@"%@ updated", object.objectId);
};

#ifdef AddingNewCustomizations
- (void) addNewEyes: (KikoCustomizations *)k {
    KikoEyes *eyes = [[KikoEyes alloc] initWithName:@"BeerEyes" leftEyeFileName:@"BeerEye.png" rightEyeFileName:@"BeerEye.png"];
    [k addObject:eyes forKey:@"eyes"];
    
    eyes = [[KikoEyes alloc] initWithName:@"FuckBoiiEyes" leftEyeFileName:@"FuckEye.png" rightEyeFileName:@"BoiiEye.png"];
    [k addObject:eyes forKey:@"eyes"];
}

- (void) addNewHair: (KikoCustomizations *)k {
    KikoHair *hair = [[KikoHair alloc] initWithName:@"Hair-1" fileName:@"Hair-1.png"];
    [k addObject:hair forKey:@"hair"];

    hair = [[KikoHair alloc] initWithName:@"Hair-2" fileName:@"Hair-2.png"];
    [k addObject:hair forKey:@"hair"];

    hair = [[KikoHair alloc] initWithName:@"Hair-3" fileName:@"Hair-3.png"];
    [k addObject:hair forKey:@"hair"];
}

#endif

- (UIBezierPath *)bezierPathWithFile:(NSString *)file {
    UIBezierPath *path = [UIBezierPath new];
    NSError *error;
    
    NSString *fileText = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    if (error) NSLog(@"%@", error);
    
    NSRegularExpression *pointRegex = [NSRegularExpression regularExpressionWithPattern:@"\\d+.?\\d*,\\d+.?\\d*" options:0 error:&error];
    if (error) NSLog(@"%@", error);
    
    NSArray *matches = [pointRegex matchesInString:fileText options:0 range:NSMakeRange(0, fileText.length)];
    
    for (int i = 0; i < matches.count; i++) {
        
        NSTextCheckingResult *match = matches[i];
        
        NSArray *components = [[fileText substringWithRange:match.range] componentsSeparatedByString:@","];
        
        float x = [components[0] floatValue];
        float y = [components[1] floatValue];
        
        if (i == 0)
            [path moveToPoint:CGPointMake(x, y)];
        
        else
            [path addLineToPoint:CGPointMake(x, y)];
    }
     
    return path;
}

- (void) refreshData {
    [self refreshCurrentUser];
    [self refreshAvailableCustomizations];
}

- (void) refreshCurrentUser {
    User *currentUser = [User currentUser];
    [currentUser fetchInBackgroundWithBlock:updatedBlock];
    [[currentUser.face fetchIfNeeded].eyes fetchIfNeeded];
    [currentUser.face.hair fetchIfNeeded];
    [currentUser pinInBackground];
}

- (void) refreshAvailableCustomizations {
    PFQuery *customizationsQuery = [PFQuery queryWithClassName:@"KikoCustomizations"];
    [customizationsQuery includeKey:@"hair"];
    [customizationsQuery includeKey:@"eyes"];
    [customizationsQuery getObjectInBackgroundWithId:@"zaV9sxvDHn" block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        KikoCustomizations *k = (KikoCustomizations *)object;
        
#ifdef AddingNewCustomizations
//        [self addNewEyes:k];
        [self addNewHair:k];
        [k save];
#endif
        [k pinInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                for (KikoEyes *eyes in k.eyes) {
                    [eyes.leftEyeFile getDataInBackground];
                    [eyes.rightEyeFile getDataInBackground];
                }
                NSLog(@"Customizations saved");
            });
        }];
    }];
}

- (void) setupParse {
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"ftnLt0eateNi2Cl1SNPeKiIjBJlGrPVFqbCIJLAT" clientKey:@"iZoYKBjyqkrqSDq1sS8VPrvooeAWxktTvRmzGKok"];
}

- (void) setupTracking {
    KikoAnimator *animator = [KikoAnimator sharedAnimator];
    KikoFaceTracker *tracker = [KikoFaceTracker sharedTracker];
    tracker.animator = animator;
}

- (void) setupNotificationsForApplication:(UIApplication *)application {
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
    NSLog(@"Registered for notificaitons");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
