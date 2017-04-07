//
//  CLRMHomeworkDetailViewController.h
//  Classroom
//
//  Created by Julio Rodríguez on 07/02/14.
//
//

#import <UIKit/UIKit.h>

@class CLRMHomework;

@interface CLRMHomeworkDetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>


// <<< Details >>>
@property (nonatomic, weak) IBOutlet UITextField *homeworkTextField;
@property (nonatomic, weak) IBOutlet UITextField *courseTextField;
@property (nonatomic, weak) IBOutlet UITextField *teacherTextField;


// <<< Priority >>>
@property (nonatomic, weak) IBOutlet UISegmentedControl *prioritySegmentedControl;
@property (nonatomic) int currentSelectedSegment;
- (IBAction)priority:(id)sender;


// <<< Alarm and Deadline>>>
@property (nonatomic, weak) IBOutlet UISwitch *alarmSwitch;
- (IBAction)alarmToggle:(id)sender;

@property (nonatomic, weak) IBOutlet UISwitch *deadlineSwitch;
- (IBAction)deadlineToggle:(id)sender;

@property (nonatomic, weak) IBOutlet UISwitch *repeatAlarmSwitch;
- (IBAction)repeatToggle:(id)sender;

@property (nonatomic, weak) IBOutlet UISegmentedControl *alarmAndDeadlineSegmentedControl;
- (IBAction)swapToAlarmOrDeadline:(id)sender;

@property (nonatomic, weak) IBOutlet UIView *datePickersView;
@property (nonatomic, weak) IBOutlet UIDatePicker *alarmDatePicker;
- (IBAction)changeAlarmDate:(id)sender;

@property (nonatomic, weak) IBOutlet UIDatePicker *deadlineDatePicker;
- (IBAction)changeDeadlineDate:(id)sender;

@property (nonatomic, weak) IBOutlet UILabel *alarmDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *deadlineLabel;


// <<< Notes >>>
@property (nonatomic, weak) IBOutlet UITextView *notesTextView;


// <<< Scroll View >>>
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;


// Pointer to the corresponding Homework
@property (nonatomic, strong) CLRMHomework *correspondingHomework;


// Property used to check if a homework is new or it already existed
@property (nonatomic) BOOL homeworkIsNew;


// Designated initializer
// it checks if the homework is new or not (to adjust the UI)
- (id)initForNewHomework:(BOOL)isNew;


@end
