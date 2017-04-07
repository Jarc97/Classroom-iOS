//
//  CLRMHomework.m
//  Classroom
//
//  Created by Julio Rodríguez on 03/02/14.
//
//

#import "CLRMHomework.h"
#import "CLRMLocalNotificationAssistant.h"

@implementation CLRMHomework

#pragma mark - @synthesize declarations

@synthesize homeworkTitle = _homeworkTitle;
@synthesize homeworkCourse = _homeworkCourse;
@synthesize homeworkTeacher = _homeworkTeacher;
@synthesize homeworkPriority = _homeworkPriority;

@synthesize homeworkHasAlarm = _homeworkHasAlarm;
@synthesize homeworkRepeatsAlarm = _homeworkRepeatsAlarm;
@synthesize homeworkHasDeadline = _homeworkHasDeadline;
@synthesize homeworkDeadline = _homeworkDeadline;

@synthesize homeworkNotes = _homeworkNotes;
@synthesize homeworkUUID = _homeworkUUID;


#pragma mark - Test randomHomeworks

// This method is for testing only
+ (id)randomHomework
{
    // Array of three homework
    NSArray *homeworkArray = [NSArray arrayWithObjects:@"Math", @"Science", @"English", nil];
    
    // Get the index of a random homework
    NSInteger randomHomeworkIndex = arc4random() % [homeworkArray count];
    
    // Make the random name
    NSString *homeworkName = [NSString stringWithFormat:@"%@", [homeworkArray objectAtIndex:randomHomeworkIndex]];
    
    CLRMHomework *newHomework = [[self alloc] initWithHomeworkTitle:homeworkName];
    NSLog(@"New random homework created");
    return  newHomework;
}

#pragma mark - Archiving methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_homeworkTitle forKey:@"Homework Title"];
    [aCoder encodeObject:_homeworkCourse forKey:@"Homework Course"];
    [aCoder encodeObject:_homeworkTeacher forKey:@"Homework Teacher"];
    [aCoder encodeInt:_homeworkPriority forKey:@"Homework Priority"];  // Int
    
    [aCoder encodeBool:_homeworkHasAlarm forKey:@"Homework Has Alarm"];
    [aCoder encodeBool:_homeworkRepeatsAlarm forKey:@"Homework Repeats Alarm"];
    [aCoder encodeBool:_homeworkHasDeadline forKey:@"Homework Has Deadline"];
    [aCoder encodeObject:_homeworkDeadline forKey:@"Homework Deadline"];
    
    [aCoder encodeObject:_homeworkNotes forKey:@"Homework Notes"];
    [aCoder encodeObject:_homeworkUUID forKey:@"Homework UUID"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        
        [self setHomeworkTitle:[aDecoder decodeObjectForKey:@"Homework Title"]];
        [self setHomeworkCourse:[aDecoder decodeObjectForKey:@"Homework Course"]];
        [self setHomeworkTeacher:[aDecoder decodeObjectForKey:@"Homework Teacher"]];
        [self setHomeworkPriority:[aDecoder decodeIntForKey:@"Homework Priority"]];  // Int
        
        [self setHomeworkHasAlarm:[aDecoder decodeBoolForKey:@"Homework Has Alarm"]];
        [self setHomeworkRepeatsAlarm:[aDecoder decodeBoolForKey:@"Homework Repeats Alarm"]];
        [self setHomeworkHasDeadline:[aDecoder decodeBoolForKey:@"Homework Has Deadline"]];
        [self setHomeworkDeadline:[aDecoder decodeObjectForKey:@"Homework Deadline"]];
        
        [self setHomeworkNotes:[aDecoder decodeObjectForKey:@"Homework Notes"]];
        [self setHomeworkUUID:[aDecoder decodeObjectForKey:@"Homework UUID"]];
    }
    
    return self;
}



#pragma mark - description methods

// This description methods are used to fill
// the Homework List cells, with the homework ivars

// returns the title of the homework instance
- (NSString *)titleDescription
{
    // Get the _homeworkTitle of this instance
    NSString *homeworkTitleString = [[NSString alloc] initWithFormat:@"%@", _homeworkTitle];
    
    return homeworkTitleString;
}


- (NSString *)courseDescription
{
    NSString *homeworkCourseString = [[NSString alloc] initWithFormat:@"%@", _homeworkCourse];
    
    return homeworkCourseString;
}



- (NSString *)teacherDescription
{
    NSString *homeworkTeacherString = [[NSString alloc] initWithFormat:@"%@", _homeworkTeacher];
    
    return homeworkTeacherString;
}


- (int)priorityDescription
{
    int homeworkPriorityInt = _homeworkPriority;
    
    return homeworkPriorityInt;
}


- (NSString *)notesDescription
{
    NSString *homeworkNotesString = [[NSString alloc] initWithFormat:@"%@", _homeworkNotes];
    
    return homeworkNotesString;
}




#pragma mark - initializers

- (id)initWithHomeworkTitle:(NSString *)title
{
    self = [super init];
    
    if (self) {
        
        // Set the homework title
        [self setHomeworkTitle:title];
        
        // Create a CFUUIDRef object, it also creates the UUID
        CFUUIDRef newUUID = CFUUIDCreate(kCFAllocatorDefault);
        
        // Create a string from that UUID
        CFStringRef newUUIDstring = CFUUIDCreateString(kCFAllocatorDefault, newUUID);
        
        // Set the homework with the UUID
        NSString *homeworkUUIDstring = (__bridge NSString *)newUUIDstring;
        [self setHomeworkUUID:homeworkUUIDstring];
        
        NSLog(@"Homework UUID: %@", homeworkUUIDstring);
        
        // Release the Core Foundation objects
        CFRelease(newUUIDstring);
        CFRelease(newUUID);
    }
    
    return self;
}


- (id)init
{
    return [self initWithHomeworkTitle:@""];
}

@end
