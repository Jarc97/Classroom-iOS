//
//  CLRMReminder.h
//  Classroom
//
//  Created by Julio Rodríguez on 13/05/14.
//
//

#import <Foundation/Foundation.h>

@interface CLRMReminder : NSObject <NSCoding>

// Reminder ivars
@property (nonatomic, strong) NSString *reminderTitle;
@property (nonatomic, strong) NSString *reminderNotes;

@property (nonatomic) BOOL reminderHasAlarm;
@property (nonatomic) BOOL reminderRepeatsAlarm;

@property (nonatomic) NSString *reminderUUID;


// Designated Initializer
- (id)initWithReminderTitle:(NSString *)title;


// These descriptions are used to fill the Reminder List cells
- (NSString *)titleDescription;
- (NSString *)notesDescription;

@end
