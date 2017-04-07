//
//  CLRMWebPageStore.m
//  Classroom
//
//  Created by Julio Rodríguez on 26/02/14.
//
//

#import "CLRMWebPageStore.h"

@implementation CLRMWebPageStore

@synthesize allWebPages = _allWebPages;


#pragma mark - Singleton methods

+ (CLRMWebPageStore *)sharedStore
{
    // static variable does not get destroyed when method returns
    static CLRMWebPageStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}


+ (id)allocWithZone:(NSZone *)zone
{
    // To enforce a singleton, return the single HWHomeworkStore instance
    return [self sharedStore];
}



#pragma mark - Homework store management methods

- (CLRMWebPage *)createWebPage
{
    // Create a new CLRMWebPage instance
    CLRMWebPage *newWebPage = [[CLRMWebPage alloc] init];
    
    // Add the new instance to the array
    [_allWebPages addObject:newWebPage];
    
    NSLog(@"New Web Page created in the store");
    
    return newWebPage;
}


- (void)removeWebPage:(CLRMWebPage *)webPage
{
    // remove the web page from the mutable array
    [_allWebPages removeObjectIdenticalTo:webPage];
}


- (void)moveItemAtIndex:(int)from
                toIndex:(int)to
{
    // If cell moving ends in same place...
    if (from == to) {
        return;
    }
    
    // Get a pointer to object so it can be re-inserted
    CLRMWebPage *webPageMoving = [_allWebPages objectAtIndex:from];
    
    // Remove webPageMoving from the array
    [_allWebPages removeObjectAtIndex:from];
    
    // Insert webPageMoving in the array at new index
    [_allWebPages insertObject:webPageMoving atIndex:to];
}


- (NSArray *)allCreatedWebPages
{
    // return the web pages that already exist in the mutable array
    return _allWebPages;
}


- (NSString *)webPageArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"webpages.archive"];
}


- (BOOL)saveChanges
{
    // return success of failure
    NSString *path = [self webPageArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:_allWebPages
                                       toFile:path];
}


#pragma mark - initializers

- (id)init
{
    self = [super init];
    
    if (self) {
        
        // Unarchive all web pages
        NSString *path = [self webPageArchivePath];
        _allWebPages = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new one
        if (!_allWebPages) {
            _allWebPages = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

@end
