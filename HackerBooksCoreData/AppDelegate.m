//
//  AppDelegate.m
//  HackerBooksCoreData
//
//  Created by Jose Manuel Franco on 7/7/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "AppDelegate.h"
#import "CRODataHandler.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Tag.h"

NSString *const JSON_DOWNLOADED_AND_PARSED = @"jsonDownloadedAndParsed";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
     if(![[NSUserDefaults standardUserDefaults]boolForKey:JSON_DOWNLOADED_AND_PARSED]){
         CRODataHandler *dataHandler=[CRODataHandler new];
         RLMRealm *realm = [RLMRealm defaultRealm];
    
         NSArray *json=[dataHandler getJsonArray];
         [dataHandler addJsonArray:json
               toRealmContext:realm];
         [[NSUserDefaults standardUserDefaults]setBool:YES forKey:JSON_DOWNLOADED_AND_PARSED];
     }
    [self refreshRecentTag];
    return YES;
}

-(void) refreshRecentTag{
    RLMResults *tagResult = [Tag objectsWhere:@"tagName = 'Recent' "];
    Tag *recentTag=[tagResult objectAtIndex:0];
    NSDate *now=[NSDate date];
    int index=0;
    RLMRealm *context = [RLMRealm defaultRealm];
    [context beginWriteTransaction];
    for(Book *book in recentTag.books){
        int days=[self daysBetweenFromDate:book.lastOpened toDate:now];
        if(days>7){
            for(Tag *tag in book.tags){
                if([tag.tagName isEqualToString:@"Recent"]){
                    break;
                }
                index++;
            }
            [book.tags removeObjectAtIndex:index];
        }
    }
    [context commitWriteTransaction];
}
           
-(int) daysBetweenFromDate:(NSDate*)fromDateTime toDate:(NSDate*)toDateTime {
    NSDate *fromDate;
    NSDate *toDate;
    
    //initialize the calender
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //Returns by reference the starting time and duration of a given calendar unit that contains a given date.
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    //Returns, as an NSDateComponents object using specified components, the difference between two supplied dates.
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
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
