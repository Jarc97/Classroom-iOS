//
//  CLRMReminderStore.m
//  Classroom
//
//  Created by Julio Rodríguez on 13/05/14.
//
//

#import "CLRMReminderStore.h"

@implementation CLRMReminderStore

#pragma mark - @synthesize declarations

@synthesize allReminders = _allReminders;



#pragma mark - Singleton methods

+ (CLRMReminderStore *)sharedStore
{
    // static variable does not get destroyed when method returns
    static CLRMReminderStore *sharedStore = nil;
    
    if (!sharedStore) {
        
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}


+ (id)allocWithZone:(NSZone *)zone
{
    // To enforce a singleton, return the single CLRMReminderStore instance
    return [self sharedStore];
}



#pragma mark - Reminder store management methods

- (CLRMReminder *)createReminder
{
    CLRMReminder *newReminder = [[CLRMReminder alloc] init];
    
    [_allReminders addObject:newReminder];
    NSLog(@"New reminder created in the store");
    
    return newReminder;
}


- (void)removeReminder:(CLRMReminder *)reminder
{
    // Remove the reminder from the mutable array
    [_allReminders removeObjectIdenticalTo:reminder];
}


- (void)moveReminderAtIndex:(int)from
                    toIndex:(int)to
{
    // If cell moving ends in same place...
    if (from == to) {
        
        return;
    }
    
    // Get pointer to object so it can be re-inserted
    CLRMReminder *reminderMoving = [_allReminders objectAtIndex:from];
    
    // Remove reminderMoving from the array
    [_allReminders removeObjectAtIndex:from];
    
    // Insert reminderMoving in the array at new index
    [_allReminders insertObject:reminderMoving atIndex:to];
}


- (NSArray *)allCreatedReminders
{
    // return the Homework that already exist in the mutable array
    return _allReminders;
}



#pragma mark - Archiving path method

- (BOOL)saveChanges
{
    // return success or failure
    NSString *path = [self remindersArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:_allReminders toFile:path];
}


- (NSString *)remindersArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"reminders.archive"];
}



#pragma mark - initializers

- (id)init
{
    self = [super init];
    
    if (self) {
        
        // Unarchive all homework
        NSString *path = [self remindersArchivePath];
        _allReminders = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new one
        if (!_allReminders) {
            
            _allReminders = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}




@end
