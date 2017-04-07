//
//  CLRMHomework.h
//  Classroom
//
//  Created by Julio Rodríguez on 03/02/14.
//
//

#import <Foundation/Foundation.h>

@interface CLRMHomework : NSObject <NSCoding>

@property (nonatomic, strong) NSString *homeworkTitle;
@property (nonatomic, strong) NSString *homeworkCourse;
@property (nonatomic, strong) NSString *homeworkTeacher;

@property (nonatomic) int homeworkPriority;

@property (nonatomic) BOOL homeworkHasAlarm;
@property (nonatomic) BOOL homeworkRepeatsAlarm;
@property (nonatomic) BOOL homeworkHasDeadline;
@property (nonatomic) NSDate *homeworkDeadline;

@property (nonatomic, strong) NSString *homeworkNotes;

@property (nonatomic) NSString *homeworkUUID;

+ (id)randomHomework;

// Designated Initializer
- (id)initWithHomeworkTitle:(NSString *)title;

// These descriptions are used to fill
// the Homework List cells
- (NSString *)titleDescription;
- (NSString *)courseDescription;
- (NSString *)teacherDescription;
- (int)priorityDescription;
- (NSString *)notesDescription;

@end
