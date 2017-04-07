//
//  CLRMLocalNotificationAssistant.h
//  Classroom
//
//  Created by Julio Rodríguez on 09/08/14.
//
//

#import <Foundation/Foundation.h>

@class CLRMHomework;

@interface CLRMLocalNotificationAssistant : NSObject

// This method takes parameters to schedule local notifications
// with the provided data
- (void)addLocalNotificationWithAlertBody:(NSString *)name
                                 fireDate:(NSDate *)date
                           repeatInterval:(NSCalendarUnit)repeat
                                 userInfo:(NSDictionary *)info;

// This method finds a notification with a UUID and deletes it
- (void)deleteLocalNotificationWithUUID:(NSString *)uuid;

// This method is used to delete and re-schedule a notification
- (void)modifyLocalNotificationWithUUID:(NSString *)uuid
                       notificationType:(NSString *)type
                           newAlertBody:(NSString *)alertBody
                            newFireDate:(NSDate *)fireDate
                      newRepeatInterval:(NSCalendarUnit)repeatInterval
                            newUserInfo:(NSDictionary *)userInfo;

// This method tries to find a specific notification and confirms it exists
- (BOOL)findLocalNotificationWithUUID:(NSString *)uuid;

// This method returns a specific notification
- (UILocalNotification *)returnLocalNotificationWithUUID:(NSString *)uuid;

@end
