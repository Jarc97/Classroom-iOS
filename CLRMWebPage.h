//
//  CLRMWebPage.h
//  Classroom
//
//  Created by Julio Rodríguez on 26/02/14.
//
//

#import <Foundation/Foundation.h>

@interface CLRMWebPage : NSObject <NSCoding>

@property (nonatomic, strong) NSString *webPageName;
@property (nonatomic, strong) NSString *webPageURL;

// Designated initializer
- (id)initWithWebPageName:(NSString *)name
               webPageURL:(NSString *)url;

- (NSString *)nameDescription;
- (NSString *)urlDescription;

@end
