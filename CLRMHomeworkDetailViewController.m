//
//  CLRMHomeworkDetailViewController.m
//  Classroom
//
//  Created by Julio Rodríguez on 07/02/14.
//
//

#import "CLRMHomeworkDetailViewController.h"
#import "CLRMLocalNotificationAssistant.h"
#import "CLRMHomeworkStore.h"
#import "CLRMHomework.h"


@interface CLRMHomeworkDetailViewController ()

@end

@implementation CLRMHomeworkDetailViewController

#pragma mark - @synthesize declarations

@synthesize homeworkTextField = _homeworkTextField;
@synthesize courseTextField = _courseTextField;
@synthesize teacherTextField = _teacherTextField;

@synthesize prioritySegmentedControl = _prioritySegmentedControl;
@synthesize currentSelectedSegment = _currentSelectedSegment;

@synthesize alarmSwitch = _alarmSwitch;
@synthesize deadlineSwitch = _deadlineSwitch;
@synthesize repeatAlarmSwitch = _repeatAlarmSwitch;

@synthesize alarmAndDeadlineSegmentedControl = _alarmAndDeadlineSegmentedControl;

@synthesize datePickersView = _datePickersView;
@synthesize alarmDatePicker = _alarmDatePicker;
@synthesize deadlineDatePicker = _deadlineDatePicker;

@synthesize alarmDateLabel = _alarmDateLabel;
@synthesize deadlineLabel = _deadlineLabel;

@synthesize notesTextView = _notesTextView;

@synthesize scrollView = _scrollView;

// Pointer to the corresponding Homework
@synthesize correspondingHomework = _correspondingHomework;

// Used to check if the Homework is new or not
@synthesize homeworkIsNew = _homeworkIsNew;


#pragma mark - initializers

// If the user taps the "+" button, this method gets called
// More info: BNR book - page 267 & 268
- (id)initForNewHomework:(BOOL)isNew
{
    self = [super initWithNibName:@"CLRMHomeworkDetailViewController" bundle:nil];
    
    if (self) {
        
        if (isNew) {
            
            // Set the title of the New Homework window
            [[self navigationItem] setTitle:@"New Homework"];
            
            // Create a "Save" button and set it as the right bar button item of the navigation bar
            UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                      target:self
                                                                                      action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:saveItem];
            
            // Create a "Cancel" button and set it as the left bar button item of the navigation bar
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
            
            // Indicate this is a new homework
            [self setHomeworkIsNew:YES];
            
        } else {
            
            // If the Homework instance is not new, set the navigation bar title "Detail"
            [[self navigationItem] setTitle:@"Detail"];
            
            // Create a "Done" button and set it as the right bar button item of the navigation bar
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(done:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            // Indicate this homework in not new
            [self setHomeworkIsNew:NO];
        }
    }
    
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // Crash the app if this initializer is used
    @throw [NSException exceptionWithName:@"Wrong Initializer"
                                   reason:@"Use initForNewHomework: instead"
                                 userInfo:nil];
    
    return self;
}



#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the translucency to NO, to avoid the navigation bar from covering the view
    self.navigationController.navigationBar.translucent = NO;
    
    // Set the color of the background to a light gray
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    // Set the scroll view enabled
    [_scrollView setScrollEnabled:YES];
    
    // Content should be bigger that the frame
    [_scrollView setScrollEnabled:YES];
    [_scrollView setFrame:CGRectMake(0, 0, 320, 568)];
    [_scrollView setContentSize:CGSizeMake(320, 886)];
    
    
    // Make the Notes text view be more like a UITextField
    [_notesTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.3] CGColor]];
    [_notesTextView.layer setBorderWidth:1];
    _notesTextView.layer.cornerRadius = 5;
    _notesTextView.clipsToBounds = YES;
    
    // If the Homework is new...
    if (_homeworkIsNew == YES) {
        
        // Set title text field to be the first responder
        [_homeworkTextField becomeFirstResponder];
        
        // Configure the UI to look like a new homework
        _alarmSwitch.on = NO;
        _deadlineSwitch.on = NO;
        _repeatAlarmSwitch.on = NO;
        _repeatAlarmSwitch.enabled = NO;
        [_alarmAndDeadlineSegmentedControl setEnabled:NO forSegmentAtIndex:0];
        [_alarmAndDeadlineSegmentedControl setEnabled:NO forSegmentAtIndex:1];
        [_alarmDateLabel setText:@"Alarm: no alarm date to display"];
        [_deadlineLabel setText:@"Deadline: no deadline to display"];
    }
    
    
    // If the homework is not new...
    if (_homeworkIsNew == NO) {
        
        // If there is an existing deadline for this homework...
        if (_correspondingHomework.homeworkHasDeadline == YES) {
            
            // Configure the UI to look like a deadline has been set
            _deadlineSwitch.on = YES;
            
            // If the deadline date is nil...
            if (_correspondingHomework.homeworkDeadline == nil) {
                
                // Set the deadline date picker to 1 day later from current date
                _deadlineDatePicker.date = [NSDate dateWithTimeIntervalSinceNow:86400];
            } else {
                
                // Set the deadline date picker to the saved date
                _deadlineDatePicker.date = [_correspondingHomework homeworkDeadline];
            }
            
            [_alarmAndDeadlineSegmentedControl setEnabled:YES forSegmentAtIndex:1];
            [_alarmAndDeadlineSegmentedControl setSelectedSegmentIndex:1];
            [_datePickersView setFrame:CGRectMake
             (-640, 401, _datePickersView.frame.size.width, _datePickersView.frame.size.height)];
            
            // Give a better deadline date format
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            [_deadlineLabel setText:[NSString stringWithFormat:@"Deadline: %@",
                                      [dateFormatter stringFromDate:_deadlineDatePicker.date]]];
            
        } else {
            
            // Configure the UI to look like no deadline has been set
            _deadlineSwitch.on = NO;
            _deadlineDatePicker.date = [NSDate dateWithTimeIntervalSinceNow:86400];
            [_alarmAndDeadlineSegmentedControl setEnabled:NO forSegmentAtIndex:1];
            [_deadlineLabel setText:@"Deadline: no deadline to display"];
        }
        
        
        // Create a notification assistant
        CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
        
        // If there is an existing notification for this homework (notification with same UUID)
        if ([notificationAssistant findLocalNotificationWithUUID:self.correspondingHomework.homeworkUUID] == YES) {
            
            // Get the local notification of this homework
            UILocalNotification *homeworkLocalNotification =
            [notificationAssistant returnLocalNotificationWithUUID:self.correspondingHomework.homeworkUUID];
            
            // Set a date object with the notification fire date
            NSDate *notificationDate = homeworkLocalNotification.fireDate;
            
            // Configure the UI to look like an alarm has been set
            _alarmSwitch.on = YES;
            [_alarmAndDeadlineSegmentedControl setEnabled:YES forSegmentAtIndex:0];
            [_alarmAndDeadlineSegmentedControl setSelectedSegmentIndex:0];
            [_alarmDatePicker setDate:notificationDate];
            [_datePickersView setFrame:CGRectMake
             (-320, 401, _datePickersView.frame.size.width, _datePickersView.frame.size.height)];
            
            // Configure the alarm date label with a good format
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [_alarmDateLabel setText:[NSString stringWithFormat:@"Alarm: %@",
                                      [dateFormatter stringFromDate:notificationDate]]];
            
        } else {
            
            // Configure the UI to look like an alarm has not been set
            _alarmSwitch.on = NO;
            [_alarmAndDeadlineSegmentedControl setEnabled:NO forSegmentAtIndex:0];
            [_alarmDatePicker setDate:[NSDate dateWithTimeIntervalSinceNow:600]];
            [_alarmDateLabel setText:@"Alarm: no alarm date to display"];
        }
        
        // If the homework has an alarm that repeats...
        if (_correspondingHomework.homeworkRepeatsAlarm == YES) {
            
            // Set the repeat switch on
            _repeatAlarmSwitch.on = YES;
        } else {
            
            // Set the repeat switch off and disable it
            _repeatAlarmSwitch.on = NO;
            _repeatAlarmSwitch.enabled = NO;
            
            // But if the alarm switch is on...
            if (_alarmSwitch.on == YES) {
                
                // Enable the repeat alarm switch
                _repeatAlarmSwitch.enabled = YES;
            }
        }
    }
    
    // Make this class register for a keyboard notifications
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self view] endEditing:YES];
    
    // Set the UI elements to match the corresponding CLRMHomework instance
    [_homeworkTextField setText:[_correspondingHomework homeworkTitle]];
    [_courseTextField setText:[_correspondingHomework homeworkCourse]];
    [_teacherTextField setText:[_correspondingHomework homeworkTeacher]];
    [_prioritySegmentedControl setSelectedSegmentIndex:[_correspondingHomework homeworkPriority]];
    [_notesTextView setText:[_correspondingHomework homeworkNotes]];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Save all the changes made in the Homework Detail view to corresponding homework
    [_correspondingHomework setHomeworkTitle:[_homeworkTextField text]];
    [_correspondingHomework setHomeworkCourse:[_courseTextField text]];
    [_correspondingHomework setHomeworkTeacher:[_teacherTextField text]];
    [_correspondingHomework setHomeworkPriority:[_prioritySegmentedControl selectedSegmentIndex]];
    
    if (_alarmSwitch.on == YES) {
        
        [_correspondingHomework setHomeworkHasAlarm:YES];
    } else {
        
        [_correspondingHomework setHomeworkHasAlarm:NO];
    }
    if (_repeatAlarmSwitch.on == YES) {
        
        [_correspondingHomework setHomeworkRepeatsAlarm:YES];
    } else {
        
        [_correspondingHomework setHomeworkRepeatsAlarm:NO];
    }
    if (_deadlineSwitch.on == YES) {
        
        [_correspondingHomework setHomeworkHasDeadline:YES];
        [_correspondingHomework setHomeworkDeadline:_deadlineDatePicker.date];
    } else {
        
        [_correspondingHomework setHomeworkHasDeadline:NO];
        [_correspondingHomework setHomeworkDeadline:nil];
    }
    
    [_correspondingHomework setHomeworkNotes:[_notesTextView text]];
}



#pragma mark - IBActions

- (IBAction)save:(id)sender
{
    // Check if the title text field has some text on it
    if ([_homeworkTextField.text isEqualToString:@""]) {
        
        // If the text field is empty, don't allow the user to proceed
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You can't leave the title empty"
                                                        message:@"Please put a title to continue"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    // Save changes made in the Homework Detail view to corresponding homework
    [_correspondingHomework setHomeworkTitle:[_homeworkTextField text]];
    [_correspondingHomework setHomeworkCourse:[_courseTextField text]];
    [_correspondingHomework setHomeworkTeacher:[_teacherTextField text]];
    [_correspondingHomework setHomeworkPriority:[_prioritySegmentedControl selectedSegmentIndex]];
    
    if (_alarmSwitch.on == YES) {
        
        [_correspondingHomework setHomeworkHasAlarm:YES];
    } else {
        
        [_correspondingHomework setHomeworkHasAlarm:NO];
    }
    if (_repeatAlarmSwitch.on == YES) {
        
        [_correspondingHomework setHomeworkRepeatsAlarm:YES];
    } else {
        
        [_correspondingHomework setHomeworkRepeatsAlarm:NO];
    }
    if (_deadlineSwitch.on == YES) {
        
        [_correspondingHomework setHomeworkHasDeadline:YES];
        [_correspondingHomework setHomeworkDeadline:_deadlineDatePicker.date];
    } else {
        
        [_correspondingHomework setHomeworkHasDeadline:NO];
        [_correspondingHomework setHomeworkDeadline:nil];
    }
    
    [_correspondingHomework setHomeworkNotes:[_notesTextView text]];
    
    // Save all changes made in the homework store
    BOOL successSavingHomework = [[CLRMHomeworkStore sharedStore] saveChanges];
    
    if (successSavingHomework) {
        NSLog(@"Saved all the Homework");
    } else {
        NSLog(@"Could not save any of the Homework");
    }
    
    // When the save button is pressed, return to the Homework List
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:nil];
}


- (IBAction)done:(id)sender
{
    // If the user left the homework title empty...
    if ([_homeworkTextField.text isEqualToString:@""]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You can't leave the title empty"
                                                            message:@"Please put a title to continue"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    
    // Save changes made in the Homework Detail view to corresponding homework
    [_correspondingHomework setHomeworkTitle:[_homeworkTextField text]];
    [_correspondingHomework setHomeworkCourse:[_courseTextField text]];
    [_correspondingHomework setHomeworkTeacher:[_teacherTextField text]];
    [_correspondingHomework setHomeworkPriority:[_prioritySegmentedControl selectedSegmentIndex]];
    
    if (_alarmSwitch.on == YES) {
        
        [_correspondingHomework setHomeworkHasAlarm:YES];
    } else {
        
        [_correspondingHomework setHomeworkHasAlarm:NO];
    }
    if (_repeatAlarmSwitch.on == YES) {
        
        [_correspondingHomework setHomeworkRepeatsAlarm:YES];
    } else {
        
        [_correspondingHomework setHomeworkRepeatsAlarm:NO];
    }
    if (_deadlineSwitch.on == YES) {
        
        [_correspondingHomework setHomeworkHasDeadline:YES];
        [_correspondingHomework setHomeworkDeadline:_deadlineDatePicker.date];
    } else {
        
        [_correspondingHomework setHomeworkHasDeadline:NO];
        [_correspondingHomework setHomeworkDeadline:nil];
    }
    
    [_correspondingHomework setHomeworkNotes:[_notesTextView text]];
    
    // Save all changes made in the homework store
    BOOL successSavingHomework = [[CLRMHomeworkStore sharedStore] saveChanges];
    
    if (successSavingHomework) {
        NSLog(@"Saved all the Homework");
    } else {
        NSLog(@"Could not save any of the Homework");
    }
    
    // Dismiss the view controller
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:nil];
}


- (IBAction)cancel:(id)sender
{
    // If the user cancelled, remove the CLRMHomework instance from the store
    [[CLRMHomeworkStore sharedStore] removeHomework:_correspondingHomework];
    
    // Dismiss the view controller
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:nil];
}


- (IBAction)priority:(id)sender
{
    // Check every time the segmented control is pressed
    
    // If the priority is Low...
    if (_prioritySegmentedControl.selectedSegmentIndex == 0) {
        
        _currentSelectedSegment = 0;
    }
    
    // If the priority is Medium...
    if (_prioritySegmentedControl.selectedSegmentIndex == 1) {
        
        _currentSelectedSegment = 1;
    }
    
    // If the priority is High...
    if (_prioritySegmentedControl.selectedSegmentIndex == 2) {
        
        _currentSelectedSegment = 2;
    }
}


- (IBAction)alarmToggle:(id)sender
{
    // If the homework title field is empty
    if ([_homeworkTextField.text isEqualToString:@""]) {
        
        // Tell the user that he/she must put a title first to schedule a notification
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No title detected"
                                                            message:@"To add an alarm, set the title for this homework first"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        // If the switch is on...
        if (_alarmSwitch.on == YES) {
            
            // Set it off again
            [_alarmSwitch setOn:NO animated:YES];
        }
        
        return;
    }
    
    // Call this method to configure the UI correctly
    [self alarmAndDeadlineDelegate:_alarmSwitch];
}


- (IBAction)deadlineToggle:(id)sender
{
    // Call this method to configure the UI correctly
    [self alarmAndDeadlineDelegate:_deadlineSwitch];
}


- (IBAction)repeatToggle:(id)sender
{
    // Create a notification assistant object
    CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
    
    // Make an NSCalendarUnit and get the corresponding homework UUID
    NSCalendarUnit dayRepeat = NSDayCalendarUnit;
    NSString *homeworkUUID = self.correspondingHomework.homeworkUUID;
    
    // If the repeat alarm switch is on...
    if (_repeatAlarmSwitch.on == YES) {
        
        // Modify the notification to have the repeat every day behavior
        [notificationAssistant modifyLocalNotificationWithUUID:self.correspondingHomework.homeworkUUID
                                              notificationType:@"Homework"
                                                  newAlertBody:_homeworkTextField.text
                                                   newFireDate:_alarmDatePicker.date
                                             newRepeatInterval:dayRepeat
                                                   newUserInfo:@{@"Type":@"Homework", @"UUID":homeworkUUID}];
    }
    
    
    // If the repeat alarm switch is off...
    if (_repeatAlarmSwitch.on == NO) {
        
        // Modify the notification to stop it from repeating
        [notificationAssistant modifyLocalNotificationWithUUID:self.correspondingHomework.homeworkUUID
                                              notificationType:@"Homework"
                                                  newAlertBody:_homeworkTextField.text
                                                   newFireDate:_alarmDatePicker.date
                                             newRepeatInterval:0
                                                   newUserInfo:@{@"Type":@"Homework", @"UUID":homeworkUUID}];
    }
}


// This method is mainly used to configure the UI when
// handling alarms and deadlines
- (void)alarmAndDeadlineDelegate:(UISwitch *)switchMoved
{
    // ---------------------------------------------------------------
    // ---------------------- ALARM CONFIGURATION --------------------
    // ---------------------------------------------------------------
    
    // If the user turned on the alarm switch...
    if (_alarmSwitch.on == YES && switchMoved == _alarmSwitch) {
        
        // --------------------- SET UP THE USER INTERFACE -----------------------
        
        // Enable the repeat alarm switch
        [_repeatAlarmSwitch setEnabled:YES];
        
        // If the deadline segment is enabled...
        if ([_alarmAndDeadlineSegmentedControl isEnabledForSegmentAtIndex:1]) {
            
            // Just enable the alarm segment
            [_alarmAndDeadlineSegmentedControl setEnabled:YES forSegmentAtIndex:0];
            
            // If the deadline segment is not enabled...
        } else if (![_alarmAndDeadlineSegmentedControl isEnabledForSegmentAtIndex:1]) {
            
            // Enable and select the alarm segment
            [_alarmAndDeadlineSegmentedControl setEnabled:YES forSegmentAtIndex:0];
            [_alarmAndDeadlineSegmentedControl setSelectedSegmentIndex:0];
            
            // Show the alarm date picker with an animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [_datePickersView setFrame:CGRectMake
             (-320, 401, _datePickersView.frame.size.width, _datePickersView.frame.size.height)];
            [UIView commitAnimations];
        }
        
        // Configure the local notification fire date with a Date Formatter
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_alarmDateLabel setText:[NSString stringWithFormat:@"Alarm: %@",
                                  [dateFormatter stringFromDate:_alarmDatePicker.date]]];
        
        
        // --------------------- SET UP THE OBJECTS ---------------------
        
        // Set the date of the alarm date picker to 10 minutes later
        [_alarmDatePicker setDate:[NSDate dateWithTimeIntervalSinceNow:600]];
        
        //Create a local notification object
        CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
        
        // Create a string with the homework UUID
        NSString *hmwkUUID = self.correspondingHomework.homeworkUUID;
        
        // Create a dictionary, to use it for the local notification userInfo
        NSDictionary *info = [NSDictionary dictionaryWithObjects:@[@"Homework", hmwkUUID] forKeys:@[@"Type", @"UUID"]];
        
        // Call the local notification assistant method to schedule the notification
        [notificationAssistant addLocalNotificationWithAlertBody:_homeworkTextField.text
                                                        fireDate:_alarmDatePicker.date
                                                  repeatInterval:0
                                                        userInfo:info];
    }
    
    
    if (_alarmSwitch.on == NO && switchMoved == _alarmSwitch) {
        
        // --------------------- SET UP THE USER INTERFACE -----------------------
        
        // Disable the repeat alarm switch and set if off
        [_repeatAlarmSwitch setEnabled:NO];
        [_repeatAlarmSwitch setOn:NO animated:YES];
        
        // If the deadline segment is enabled...
        if ([_alarmAndDeadlineSegmentedControl isEnabledForSegmentAtIndex:1]) {
            
            // Swap to the deadline segment
            [_alarmAndDeadlineSegmentedControl setSelectedSegmentIndex:1];
            
            // Disable the alarm segment
            [_alarmAndDeadlineSegmentedControl setEnabled:NO forSegmentAtIndex:0];
            
            // Show the deadline date picker with an animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [_datePickersView setFrame:CGRectMake
             (-640, 401, _datePickersView.frame.size.width, _datePickersView.frame.size.height)];
            [UIView commitAnimations];
            
            
            // If the deadline segment is not enabled...
        } else if (![_alarmAndDeadlineSegmentedControl isEnabledForSegmentAtIndex:1]) {
            
            // Just disable the alarm segment
            [_alarmAndDeadlineSegmentedControl setEnabled:NO forSegmentAtIndex:0];
            
            // Show the no alarm message
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [_datePickersView setFrame:CGRectMake
             (0, 401, _datePickersView.frame.size.width, _datePickersView.frame.size.height)];
            [UIView commitAnimations];
        }
        
        [_alarmDateLabel setText:@"Alarm: no alarm date to display"];
        
        // --------------------- SET UP THE OBJECTS ---------------------
        
        // Create a local notification object
        CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
        
        // Create a string with the homework UUID
        NSString *hmwkUUID = self.correspondingHomework.homeworkUUID;
        
        // Delete the local notification of this homework
        [notificationAssistant deleteLocalNotificationWithUUID:hmwkUUID];
    }
    
    // ---------------------------------------------------------------
    // -------------------- DEADLINE CONFIGURATION -------------------
    // ---------------------------------------------------------------
    
    if (_deadlineSwitch.on == YES && switchMoved == _deadlineSwitch) {
        
        // --------------------- SET UP THE USER INTERFACE -----------------------
        
        // If the alarm segment is enabled...
        if ([_alarmAndDeadlineSegmentedControl isEnabledForSegmentAtIndex:0]) {
            
            // Just enable the deadline segment
            [_alarmAndDeadlineSegmentedControl setEnabled:YES forSegmentAtIndex:1];
            
            // If the alarm segment is not enabled...
        } else if (![_alarmAndDeadlineSegmentedControl isEnabledForSegmentAtIndex:0]) {
            
            // Enable and select the deadline segment
            [_alarmAndDeadlineSegmentedControl setEnabled:YES forSegmentAtIndex:1];
            [_alarmAndDeadlineSegmentedControl setSelectedSegmentIndex:1];
            
            // Show the deadline date picker with an animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [_datePickersView setFrame:CGRectMake
             (-640, 401, _datePickersView.frame.size.width, _datePickersView.frame.size.height)];
            [UIView commitAnimations];
        }
        
        // Configure the local notification fire date with a Date Formatter
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        //[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_deadlineLabel setText:[NSString stringWithFormat:@"Deadline: %@",
                                  [dateFormatter stringFromDate:_deadlineDatePicker.date]]];
        
        // --------------------- SET UP THE OBJECTS ---------------------
        
        // Set the date of the alarm date picker to 1 hour later
        [_deadlineDatePicker setDate:[NSDate dateWithTimeIntervalSinceNow:86400]];
    }
    
    
    if (_deadlineSwitch.on == NO && switchMoved == _deadlineSwitch) {
        
        // If the alarm segment is enabled...
        if ([_alarmAndDeadlineSegmentedControl isEnabledForSegmentAtIndex:0]) {
            
            // Swap to the alarm segment
            [_alarmAndDeadlineSegmentedControl setSelectedSegmentIndex:0];
            
            // Disable the deadline segment
            [_alarmAndDeadlineSegmentedControl setEnabled:NO forSegmentAtIndex:1];
            
            // Show the alarm date picker with an animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [_datePickersView setFrame:CGRectMake
             (-320, 401, _datePickersView.frame.size.width, _datePickersView.frame.size.height)];
            [UIView commitAnimations];
            
            
            // If the alarm segment is not enabled...
        } else if (![_alarmAndDeadlineSegmentedControl isEnabledForSegmentAtIndex:0]) {
            
            // Just disable the deadline segment
            [_alarmAndDeadlineSegmentedControl setEnabled:NO forSegmentAtIndex:1];
            
            // Show the no alarm message
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [_datePickersView setFrame:CGRectMake
             (0, 401, _datePickersView.frame.size.width, _datePickersView.frame.size.height)];
            [UIView commitAnimations];
        }
        
        [_deadlineLabel setText:@"Deadline: no deadline to display"];
    }
}


// Called when the user taps the segmented control
- (IBAction)swapToAlarmOrDeadline:(id)sender
{
    if (_alarmAndDeadlineSegmentedControl.selectedSegmentIndex == 0) {
        
        // Show the no alarm message
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [_datePickersView setFrame:CGRectMake
         (-320, 401, _datePickersView.frame.size.width, _datePickersView.frame.size.height)];
        [UIView commitAnimations];
    }
    
    
    if (_alarmAndDeadlineSegmentedControl.selectedSegmentIndex == 1) {
        
        // Show the no alarm message
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [_datePickersView setFrame:CGRectMake
         (-640, 401, _datePickersView.frame.size.width, _datePickersView.frame.size.height)];
        [UIView commitAnimations];
    }
}


// This method gets called every time the user changed the alarm date with the date picker
- (void)changeAlarmDate:(id)sender
{
    NSLog(@"%@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
    // Make a NSFormatter object to configure the alarm date label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [_alarmDateLabel setText:[NSString stringWithFormat:@"Alarm: %@",
                             [dateFormatter stringFromDate:_alarmDatePicker.date]]];
    
    // Make some variables
    CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
    NSString *hmwkUUID = self.correspondingHomework.homeworkUUID;
    NSCalendarUnit dayRepeat = NSDayCalendarUnit;
    
    // If the repeat switch is on...
    if (_repeatAlarmSwitch.on == YES) {
        
        // Modify the notification with a new fire date and a repeat interval (every day)
        [notificationAssistant modifyLocalNotificationWithUUID:self.correspondingHomework.homeworkUUID
                                              notificationType:@"Homework"
                                                  newAlertBody:_homeworkTextField.text
                                                   newFireDate:_alarmDatePicker.date
                                             newRepeatInterval:dayRepeat
                                                   newUserInfo:@{@"Type":@"Homework", @"UUID":hmwkUUID}];
    }
    
    
    // If the repeat switch is off...
    if (_repeatAlarmSwitch.on == NO) {
        
        // Modify the notification with a new date without a repeat interval
        [notificationAssistant modifyLocalNotificationWithUUID:self.correspondingHomework.homeworkUUID
                                              notificationType:@"Homework"
                                                  newAlertBody:_homeworkTextField.text
                                                   newFireDate:_alarmDatePicker.date
                                             newRepeatInterval:0
                                                   newUserInfo:@{@"Type":@"Homework", @"UUID":hmwkUUID}];
    }
}


// This method gets called every time the user changed the deadline date with the date picker
- (void)changeDeadlineDate:(id)sender
{
    // Configure the local notification fire date with a Date Formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [_deadlineLabel setText:[NSString stringWithFormat:@"Deadline: %@",
                             [dateFormatter stringFromDate:_deadlineDatePicker.date]]];
}



#pragma mark - UITextFieldDelegate methods

// This method dismisses the keyboard if "Return" is tapped on the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


// This method is used to update the notification alert body
// in case that the user changes the homework title
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
    
    if (_alarmSwitch.on == YES) {
        
        // Create some variables
        NSString *hmwkUUID = self.correspondingHomework.homeworkUUID;
        NSCalendarUnit dayRepeat = NSDayCalendarUnit;
        
        // If the repeat switch is on...
        if (_repeatAlarmSwitch.on == YES) {
            
            // Modity the current notification
            [notificationAssistant modifyLocalNotificationWithUUID:self.correspondingHomework.homeworkUUID
                                                  notificationType:@"Homework"
                                                      newAlertBody:_homeworkTextField.text
                                                       newFireDate:_alarmDatePicker.date
                                                 newRepeatInterval:dayRepeat
                                                       newUserInfo:@{@"Type":@"Homework", @"UUID":hmwkUUID}];
        }
        
        // If the alarm switch is off...
        if (_repeatAlarmSwitch.on == NO) {
            
            // Modity the current notification
            [notificationAssistant modifyLocalNotificationWithUUID:self.correspondingHomework.homeworkUUID
                                                  notificationType:@"Homework"
                                                      newAlertBody:_homeworkTextField.text
                                                       newFireDate:_alarmDatePicker.date
                                                 newRepeatInterval:0
                                                       newUserInfo:@{@"Type":@"Homework", @"UUID":hmwkUUID}];
        }
    }
    
    return YES;
}



#pragma mark - UITextViewDelegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == _notesTextView) {
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            
            [_scrollView setContentOffset:CGPointMake(0, 380) animated:YES];
            
        }
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            
            [_scrollView setContentOffset:CGPointMake(0, 455) animated:YES];
        }
    }
    
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}



#pragma mark - Text View and keyboard management methods

// Called when the user starts editing the notes text view
- (void)showKeyboard:(NSNotification *)notification
{
    if (_notesTextView.isFirstResponder == YES) {
        
        NSDictionary *info = [notification userInfo];
        
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        CGRect keyboardFrame;
        
        [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
        
        [UIView beginAnimations:nil context:nil];
        
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                       self.view.frame.origin.y - keyboardFrame.size.height,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height)];
        
        [UIView commitAnimations];
    }
}


// Called when the user stops editing the notes text view
- (void)hideKeyboard:(NSNotification *)notification
{
    if (_notesTextView.isFirstResponder == YES) {
        
        NSDictionary *info = [notification userInfo];
        
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        CGRect keyboardFrame;
        
        [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
        
        [UIView beginAnimations:nil context:nil];
        
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                       self.view.frame.origin.y + keyboardFrame.size.height,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height)];
        
        [UIView commitAnimations];
    }
}

@end