//
//  CLRMHomeworkStore.h
//  Classroom
//
//  Created by Julio Rodríguez on 03/02/14.
//
//

#import <Foundation/Foundation.h>
#import "CLRMHomework.h"

@interface CLRMHomeworkStore : NSObject

@property (nonatomic, strong) NSMutableArray *allHomework;

// Singleton
+ (CLRMHomeworkStore *)sharedStore;

- (CLRMHomework *)createHomework;
- (void)removeHomework:(CLRMHomework *)hmwk;
- (void)moveHomeworkAtIndex:(int)from
                    toIndex:(int)to;

- (NSArray *)allCreatedHomework;

// Archiving path method
- (NSString *)homeworkArchivePath;
- (BOOL)saveChanges;

@end
