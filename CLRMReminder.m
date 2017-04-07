//
//  CLRMReminder.m
//  Classroom
//
//  Created by Julio Rodríguez on 13/05/14.
//
//

#import "CLRMReminder.h"

@implementation CLRMReminder

#pragma mark - synthesize declarations

@synthesize reminderTitle = _reminderTitle;
@synthesize reminderNotes = _reminderNotes;
@synthesize reminderHasAlarm = _reminderHasAlarm;
@synthesize reminderRepeatsAlarm = _reminderRepeatsAlarm;

@synthesize reminderUUID = _reminderUUID;


#pragma mark - Archiving methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_reminderTitle forKey:@"Reminder Title"];
    [aCoder encodeObject:_reminderNotes forKey:@"Reminder Notes"];
    [aCoder encodeBool:_reminderHasAlarm forKey:@"Reminder Has Alarm"];
    [aCoder encodeBool:_reminderRepeatsAlarm forKey:@"Reminder Repeats Alarm"];
    [aCoder encodeObject:_reminderUUID forKey:@"Reminder UUID"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        
        [self setReminderTitle:[aDecoder decodeObjectForKey:@"Reminder Title"]];
        [self setReminderNotes:[aDecoder decodeObjectForKey:@"Reminder Notes"]];
        [self setReminderHasAlarm:[aDecoder decodeBoolForKey:@"Reminder Has Alarm"]];
        [self setReminderRepeatsAlarm:[aDecoder decodeBoolForKey:@"Reminder Repeats Alarm"]];
        [self setReminderUUID:[aDecoder decodeObjectForKey:@"Reminder UUID"]];
    }
    
    return self;
}



#pragma mark - description methods

// This description methods are used to fill
// the Homework List cells, with the homework ivars

// returns the title of the homework instance
- (NSString *)titleDescription
{
    // Get the _reminderTitle of this instance
    NSString *reminderTitleString = [[NSString alloc] initWithFormat:@"%@", _reminderTitle];
    
    return reminderTitleString;
}


- (NSString *)notesDescription
{
    NSString *reminderNotesString = [[NSString alloc] initWithFormat:@"%@", _reminderNotes];
    
    return reminderNotesString;
}



#pragma mark - initializers

- (id)initWithReminderTitle:(NSString *)title
{
    self = [super init];
    
    if (self) {
        
        // Set the reminder title
        [self setReminderTitle:title];
        
        // Create a CFUUIDRef object, it also creates the UUID
        CFUUIDRef newUUID = CFUUIDCreate(kCFAllocatorDefault);
        
        // Create a string from that UUID
        CFStringRef newUUIDstring = CFUUIDCreateString(kCFAllocatorDefault, newUUID);
        
        // Set the reminder with the UUID
        NSString *reminderUUIDstring = (__bridge NSString *)newUUIDstring;
        [self setReminderUUID:reminderUUIDstring];
        
        NSLog(@"Reminder UUID: %@", reminderUUIDstring);
        
        // Release the Core Foundation objects
        CFRelease(newUUIDstring);
        CFRelease(newUUID);
    }
    
    return self;
}


- (id)init
{
    return [self initWithReminderTitle:@""];
}


@end
