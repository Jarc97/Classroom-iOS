//
//  CLRMLocalNotificationAssistant.m
//  Classroom
//
//  Created by Julio Rodríguez on 09/08/14.
//
//

#import "CLRMLocalNotificationAssistant.h"

@implementation CLRMLocalNotificationAssistant


- (void)addLocalNotificationWithAlertBody:(NSString *)name
                                 fireDate:(NSDate *)date
                           repeatInterval:(NSCalendarUnit)repeat
                                 userInfo:(NSDictionary *)info
{
    // Create a local notification instance
    UILocalNotification *newLocalNotification = [[UILocalNotification alloc] init];
    
    newLocalNotification.alertBody = name;
    newLocalNotification.fireDate = date;
    newLocalNotification.repeatInterval = repeat;   // The repeat interval is set by another method
    newLocalNotification.userInfo = info;
    newLocalNotification.soundName = UILocalNotificationDefaultSoundName;
    newLocalNotification.applicationIconBadgeNumber =
    [[UIApplication sharedApplication] applicationIconBadgeNumber] +1;
    
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:newLocalNotification];
}


- (void)deleteLocalNotificationWithUUID:(NSString *)uuid
{
    // Iterate in the array of scheduled local notifications
    for (UILocalNotification *localNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        // If the notification userInfo contains the value (UUID)
        if ([[localNotification.userInfo allValues] containsObject:uuid]) {
            
            // Cancel this notification
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
}


- (void)modifyLocalNotificationWithUUID:(NSString *)uuid
                       notificationType:(NSString *)type
                           newAlertBody:(NSString *)alertBody
                            newFireDate:(NSDate *)fireDate
                      newRepeatInterval:(NSCalendarUnit)repeatInterval
                            newUserInfo:(NSDictionary *)userInfo;
{
    // First, delete the current notification
    [self deleteLocalNotificationWithUUID:uuid];
    
    // If the notification to modify is a homework...
    if ([type isEqualToString:@"Homework"]) {
        
        // Then add a new notification depending on the repeat interval
        if (repeatInterval == 0) {
            
            [self addLocalNotificationWithAlertBody:alertBody
                                           fireDate:fireDate
                                     repeatInterval:0
                                           userInfo:@{@"Type":@"Homework" , @"UUID":uuid}];
        } else {
            
            [self addLocalNotificationWithAlertBody:alertBody
                                           fireDate:fireDate
                                     repeatInterval:NSDayCalendarUnit
                                           userInfo:@{@"Type":@"Homework" , @"UUID":uuid}];
        }
    }
    
    
    // If the notification to modify is a reminder...
    if ([type isEqualToString:@"Reminder"]) {
        
        // Add a notification depending on the repeat interval
        if (repeatInterval == 0) {
            
            [self addLocalNotificationWithAlertBody:alertBody
                                           fireDate:fireDate
                                     repeatInterval:0
                                           userInfo:@{@"Type":@"Reminder" , @"UUID":uuid}];
        } else {
            
            [self addLocalNotificationWithAlertBody:alertBody
                                           fireDate:fireDate
                                     repeatInterval:NSDayCalendarUnit
                                           userInfo:@{@"Type":@"Reminder" , @"UUID":uuid}];
        }
    }
}


- (BOOL)findLocalNotificationWithUUID:(NSString *)uuid
{
    // Iterate in the array of local notifications
    for (UILocalNotification *localNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        // If the notification exists...
        if ([[[localNotification userInfo] allValues] containsObject:uuid]) {
            
            // Return YES
            return YES;
        }
    }
    
    // If no notification was found, return NO
    return NO;
}


- (UILocalNotification *)returnLocalNotificationWithUUID:(NSString *)uuid
{
    // Create a local notification object
    UILocalNotification *returnValue;
    
    // Iterate in the scheduled local notification array
    for (UILocalNotification *localNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        // If there is a notification with the provided UUID...
        if ([[[localNotification userInfo] allValues] containsObject:uuid]) {
            
            returnValue = localNotification;
        }
    }
    
    return returnValue;
}


@end
