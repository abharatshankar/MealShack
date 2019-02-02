//
//  AppDelegate.m
//  MealShack
//
//  Created by Prasad on 20/07/17.
//  Copyright © 2017 Possibillion. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "Utilities.h"
#import "SignUpViewController.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "RestaurantsViewController.h"
#import "LoginViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "SingleTon.h"
#import "LcnManager.h"
#import <UserNotifications/UserNotifications.h>

@import Firebase;
@import FirebaseMessaging;

@interface AppDelegate ()<ServiceHandlerDelegate,FIRMessagingDelegate>
{
    SingleTon *     singleToninstance;
}

//@property (nonatomic,retain)NSMutableArray *featuredMarchentArr;

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    
    NSString *str = [NSString stringWithFormat:@"%f",[[LcnManager sharedManager]locationManager].location.coordinate.latitude];
    NSString *strlong = [NSString stringWithFormat:@"%f", [[LcnManager sharedManager]locationManager].location.coordinate.longitude];
    [self loginChecking];
    
    
    
    
    [FIRApp configure];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    
    
    center.delegate = self;
    
    
    
    
    
    
    
    UNNotificationAction *ActionBtn1 = [UNNotificationAction actionWithIdentifier:@"actions_Id" title:@"Allow" options:UNNotificationActionOptionForeground];
    
    
    
    UNNotificationAction *ActionBtn2 = [UNNotificationAction actionWithIdentifier:@"actions_Id" title:@"Denny" options:UNNotificationActionOptionDestructive];
    
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"actions_Id" actions:@[ActionBtn1,ActionBtn2] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];

    
    NSSet *categories = [NSSet setWithObject:category];
    
    
    
    [center setNotificationCategories:categories];
    
    
    UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound
    
    
    | UNAuthorizationOptionBadge;
    
    
    
    
    [center requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        

        
        
        
    }];
    
    
    
    [FIRMessaging messaging].remoteMessageDelegate = self;
    
    [FIRMessaging messaging].delegate = self;
    
    
    
    [application registerForRemoteNotifications];
    
    
    
    [FIRMessaging messaging];
    
    
    
    NSString *fcmToken = [[FIRInstanceID instanceID] token];
    
    
    
    NSLog(@"the FCM Token %@",fcmToken);
    
    
    
    
    
    
    

    
    
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    
    
    
    return YES;
}














-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    
    
    
    
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    
    
    
    
    
    
    
    //NSLog(@"when app is active ");
    
    //  completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    
    
    
    
    
    
    
    if( [UIApplication sharedApplication].applicationState == UIApplicationStateInactive )
        
    {
        
        NSLog( @"INACTIVE" );
        
        completionHandler(UNNotificationPresentationOptionAlert);
        
    }
    
    else if( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground )
        
    {
        
        NSLog( @"BACKGROUND" );
        
        completionHandler( UNNotificationPresentationOptionAlert );
        
    }
    
    else
        
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DataUpdated"
         
                                                            object:self];
        
        NSLog( @"FOREGROUND" );
        
        
        
    }
    
    
    
    
    
    
    
}



//Called to let your app know which action was selected by the user for a given notification.

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    
    completionHandler();
    
}









- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    
    
    
    NSLog(@"FCM registration token: %@", fcmToken);
    
    
    
    NSLog(@"FCM registration token: %@", fcmToken);
    
    
    
}







- (void)application:(UIApplication *)application


didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    
    
    
    
    
    NSString *tokenString = [deviceToken description];
    
    
    
    NSLog(@"Push Notification deviceToken is %@",deviceToken);
    
    
    
    
    
    tokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    
    
    
    
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    
    
    
    NSLog(@"Push Notification tokenstring is %@",tokenString);
    
    
    
    
    
    
    
    [[NSUserDefaults standardUserDefaults]setObject:tokenString forKey:@"DeviceTokenFinal"];
    
    
    
    
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    
    
    
    
    
}




















-(void)loginChecking
{
    
    if ([USERDEFAULTS boolForKey:@"UserSignedIn"])  //loggedin
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RestaurantsViewController *campVC;
        campVC = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantsViewController"];
        UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:campVC];
        mainNavigationController.navigationBar.barTintColor = WHITECOLOR;
        mainNavigationController.navigationBar.tintColor = WHITECOLOR;
        [mainNavigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName :WHITECOLOR}];
        mainNavigationController.navigationBar.translucent = YES;
        mainNavigationController.navigationBarHidden = NO;
        
        
        
        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:nil frontViewController:mainNavigationController];
        revealController.delegate = self;
        
        SideMenuViewController *leftViewController = [[SideMenuViewController alloc] init];
        UINavigationController *leftNavigationController = [[UINavigationController alloc] initWithRootViewController:leftViewController];
        revealController.rearViewController = leftNavigationController;
        
        self.window.rootViewController = revealController;
        [self.window makeKeyAndVisible];
    }
    else
    {
        
        UIStoryboard *storyboard1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
       LoginViewController *loginUpObj;
        loginUpObj = [storyboard1 instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:loginUpObj];
        mainNavigationController.navigationBar.barTintColor = WHITECOLOR;
        mainNavigationController.navigationBar.tintColor = WHITECOLOR;
        [mainNavigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName :WHITECOLOR}];
        mainNavigationController.navigationBar.translucent = YES;
        mainNavigationController.navigationBarHidden = YES;
        
        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:nil frontViewController:mainNavigationController];
        revealController.delegate = self;
        
        SideMenuViewController *leftViewController = [[SideMenuViewController alloc] init];
        UINavigationController *leftNavigationController = [[UINavigationController alloc] initWithRootViewController:leftViewController];
        revealController.rearViewController = leftNavigationController;
        
        
        self.window.rootViewController = revealController;
        [self.window makeKeyAndVisible];
        
        
        
        
    }

}

-(void)loginPage
{
    
    UIStoryboard *storyboard1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LoginViewController *loginUpObj;
    loginUpObj = [storyboard1 instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:loginUpObj];
    mainNavigationController.navigationBar.barTintColor = WHITECOLOR;
    mainNavigationController.navigationBar.tintColor = WHITECOLOR;
    [mainNavigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName :WHITECOLOR}];
    mainNavigationController.navigationBar.translucent = YES;
    mainNavigationController.navigationBarHidden = YES;
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:nil frontViewController:mainNavigationController];
    revealController.delegate = self;
    
    SideMenuViewController *leftViewController = [[SideMenuViewController alloc] init];
    UINavigationController *leftNavigationController = [[UINavigationController alloc] initWithRootViewController:leftViewController];
    revealController.rearViewController = leftNavigationController;
    
    
    self.window.rootViewController = revealController;
    [self.window makeKeyAndVisible];
    
}


/*!
 @abstract      reachabilityChanged
 @param         NSNotification
 @discussion    reachabilityChanged method used to change network
 @return        nill
 */

/*!
 @abstract      Net work Reachability
 @param         Reachability
 @discussion    updateInterfaceWithReachability method used to change network
 @return        nill
 */



-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//@synthesize persistentContainer = _persistentContainer;


- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.jobaapjob.jobaap" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MealShack" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


//- (NSPersistentContainer *)persistentContainer {
//    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
//    @synchronized (self) {
//        if (_persistentContainer == nil) {
//            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"MealShack"];
//            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
//                if (error != nil) {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    
//                    /*
//                     Typical reasons for an error here include:
//                     * The parent directory does not exist, cannot be created, or disallows writing.
//                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                     * The device is out of space.
//                     * The store could not be migrated to the current model version.
//                     Check the error message to determine what the actual problem was.
//                    */
//                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                    abort();
//                }
//            }];
//        }
//    }
//    
//    return _persistentContainer;
//    
//}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    if (![NSThread currentThread].isMainThread) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            (void)[self persistentStoreCoordinator];
        });
        return _persistentStoreCoordinator;
    }
    
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MealShack.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"MealShack" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}





#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
