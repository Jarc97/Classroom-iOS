//
//  CLRMReminderStore.h
//  Classroom
//
//  Created by Julio Rodríguez on 13/05/14.
//
//

#import <Foundation/Foundation.h>
#import "CLRMReminder.h"

@interface CLRMReminderStore : NSObject

@property (nonatomic, strong) NSMutableArray *allReminders;

// Singleton
+ (CLRMReminderStore *)sharedStore;

- (CLRMReminder *)createReminder;
- (void)removeReminder:(CLRMReminder *)reminder;
- (void)moveReminderAtIndex:(int)from
                    toIndex:(int)to;

- (NSArray *)allCreatedReminders;

// Archiving path method
- (NSString *)remindersArchivePath;
- (BOOL)saveChanges;

@end
