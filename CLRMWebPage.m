//
//  CLRMWebPage.m
//  Classroom
//
//  Created by Julio Rodríguez on 26/02/14.
//
//

#import "CLRMWebPage.h"

@implementation CLRMWebPage

@synthesize webPageName = _webPageName;
@synthesize webPageURL = _webPageURL;






#pragma mark - Archiving methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Encode the web page ivars with a key
    [aCoder encodeObject:_webPageName forKey:@"Web Page Name"];
    [aCoder encodeObject:_webPageURL forKey:@"Web Page URL"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        
        [self setWebPageName:[aDecoder decodeObjectForKey:@"Web Page Name"]];
        [self setWebPageURL:[aDecoder decodeObjectForKey:@"Web Page URL"]];
    }
    
    return self;
}


#pragma mark - description methods

- (NSString *)nameDescription
{
    // Get the _webPageName of this instance
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@", _webPageName];
    
    return descriptionString;
}


- (NSString *)urlDescription
{
    // Get the _webPageURL of this instance
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@", _webPageURL];
    
    return descriptionString;
}




#pragma mark - initializers

- (id)initWithWebPageName:(NSString *)name
               webPageURL:(NSString *)url
{
    self = [super init];
    
    if (self) {
        
        [self setWebPageName:name];
        [self setWebPageURL:url];
    }
    
    return self;
}


- (id)init
{
    return [self initWithWebPageName:@"New web page" webPageURL:@"URL"];
}


@end
