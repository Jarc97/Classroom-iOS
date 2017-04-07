//
//  CLRMWebPageStore.h
//  Classroom
//
//  Created by Julio Rodríguez on 26/02/14.
//
//

#import <Foundation/Foundation.h>
#import "CLRMWebPage.h"

@interface CLRMWebPageStore : NSObject

@property (nonatomic, strong) NSMutableArray *allWebPages;

// Singleton
+ (CLRMWebPageStore *)sharedStore;

- (CLRMWebPage *)createWebPage;
- (void)removeWebPage:(CLRMWebPage *)webPage;
- (void)moveItemAtIndex:(int)from
                toIndex:(int)to;

- (NSArray *)allCreatedWebPages;

// Archiving path methods
- (NSString *)webPageArchivePath;
- (BOOL)saveChanges;


@end
