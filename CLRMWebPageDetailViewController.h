//
//  CLRMWebPageDetailViewController.h
//  Classroom
//
//  Created by Julio Rodríguez on 27/02/14.
//
//

#import <UIKit/UIKit.h>

@class CLRMWebPage;

@interface CLRMWebPageDetailViewController : UIViewController <UITextFieldDelegate>

// UI objects
@property (nonatomic, weak) IBOutlet UITextField *webPageTextField;
@property (nonatomic, weak) IBOutlet UITextField *urlTextField;

// Model objects
@property (nonatomic, strong) CLRMWebPage *correspondingWebPage;

// Designated initializer
- (id)initForNewWebPage:(BOOL)isNew;

@end
