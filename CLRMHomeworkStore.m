//
//  CLRMHomeworkStore.m
//  Classroom
//
//  Created by Julio Rodríguez on 03/02/14.
//
//

#import "CLRMHomeworkStore.h"

@implementation CLRMHomeworkStore

#pragma mark - @synthesize declarations

@synthesize allHomework = _allHomework;



#pragma mark - Singleton methods

+ (CLRMHomeworkStore *)sharedStore
{
    // static variable does not get destroyed when method returns
    static CLRMHomeworkStore *sharedStore = nil;
    
    if (!sharedStore) {
        
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}


+ (id)allocWithZone:(NSZone *)zone
{
    // To enforce a singleton, return the single CLRMHomeworkStore instance
    return [self sharedStore];
}



#pragma mark - Homework store management methods

- (CLRMHomework *)createHomework
{
    // Create a new CLRMHomework instance
    CLRMHomework *newHomework = [[CLRMHomework alloc] init]; // BNR pages.196 & 286
    
    // Add the instance to the array
    [_allHomework addObject:newHomework];
    NSLog(@"New homework created in the store");
    
    return newHomework;
}


- (void)removeHomework:(CLRMHomework *)hmwk
{
    // remove the homework from the mutable array
    [_allHomework removeObjectIdenticalTo:hmwk];
}


- (void)moveHomeworkAtIndex:(int)from
                toIndex:(int)to
{
    // If cell moving ends in same place...
    if (from == to) {
        
        return;
    }
    
    // Get pointer to object so it can be re-inseted
    CLRMHomework *homeworkMoving = [_allHomework objectAtIndex:from];
    
    // Remove homeworkMoving from the array
    [_allHomework removeObjectAtIndex:from];
    
    // Insert homeworkMoving in the array at new index
    [_allHomework insertObject:homeworkMoving atIndex:to];
}


- (NSArray *)allCreatedHomework
{
    // return the Homework that already exist in the mutable array
    return _allHomework;
}



#pragma mark - Archiving path method

- (BOOL)saveChanges
{
    // return success or failure
    NSString *path = [self homeworkArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:_allHomework
                                       toFile:path];
}


- (NSString *)homeworkArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"homework.archive"];
}



#pragma mark - initializers

- (id)init
{
    self = [super init];
    
    if (self) {
        
        // Unarchive all homework
        NSString *path = [self homeworkArchivePath];
        _allHomework = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new one
        if (!_allHomework) {
            
            _allHomework = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

@end
