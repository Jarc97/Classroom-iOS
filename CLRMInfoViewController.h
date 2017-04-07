//
//  CLRMInfoViewController.h
//  Classroom
//
//  Created by Julio Rodríguez on 07/06/14.
//
//

#import <Foundation/Foundation.h>

@interface CLRMInfoViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *userGuideButton;
@property (nonatomic, weak) IBOutlet UIButton *newsAndUpdatesButton;

- (IBAction)showUserGuide:(id)sender;
- (IBAction)showNewsAndUpdates:(id)sender;

@end
