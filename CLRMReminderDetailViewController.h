//
//  CLRMReminderDetailViewController.h
//  Classroom
//
//  Created by Julio Rodríguez on 13/05/14.
//
//

#import <Foundation/Foundation.h>

@class CLRMReminder;

@interface CLRMReminderDetailViewController : UIViewController <UITextFieldDelegate>

// <<< Details >>>
@property (nonatomic, weak) IBOutlet UITextField *reminderTextField;
@property (nonatomic, weak) IBOutlet UITextField *notesTextField;


// <<< Alarm >>>
@property (nonatomic, weak) IBOutlet UISwitch *alarmSwitch;
- (IBAction)alarmToggle:(id)sender;
@property (nonatomic, weak) IBOutlet UISwitch *repeatAlarmSwitch;
- (IBAction)repeatToggle:(id)sender;
@property (nonatomic, weak) IBOutlet UIDatePicker *alarmDatePicker;
- (IBAction)changeAlarmDate:(id)sender;
@property (nonatomic, weak) IBOutlet UILabel *currentAlarmDateLabel;


// <<< Scroll View >>>
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;


// Pointer to the corresponding Reminder
@property (nonatomic, strong) CLRMReminder *correspondingReminder;


// Property used to check if a reminder is new or it already existed
@property (nonatomic) BOOL reminderIsNew;


// Designated initializer
// it checks if the homework is new or not (to adjust the UI)
- (id)initForNewReminder:(BOOL)isNew;


@end
