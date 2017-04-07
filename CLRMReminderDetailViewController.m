//
//  CLRMReminderDetailViewController.m
//  Classroom
//
//  Created by Julio Rodríguez on 13/05/14.
//
//

#import "CLRMReminderDetailViewController.h"
#import "CLRMLocalNotificationAssistant.h"

#import "CLRMReminderStore.h"
#import "CLRMReminder.h"

@implementation CLRMReminderDetailViewController

@synthesize reminderTextField = _reminderTextField;
@synthesize notesTextField = _notesTextField;

@synthesize alarmSwitch = _alarmSwitch;
@synthesize repeatAlarmSwitch = _repeatAlarmSwitch;
@synthesize alarmDatePicker = _alarmDatePicker;

@synthesize currentAlarmDateLabel = _currentAlarmDateLabel;
@synthesize scrollView = _scrollView;
@synthesize correspondingReminder = _correspondingReminder;

@synthesize reminderIsNew = _reminderIsNew;


#pragma mark - initializers

// Called when the user taps the "+" button
- (id)initForNewReminder:(BOOL)isNew
{
    self = [super initWithNibName:@"CLRMReminderDetailViewController" bundle:nil];
    
    if (self) {
        
        if (isNew) {
            
            // Set the title of the New Reminder window
            [[self navigationItem] setTitle:@"New Reminder"];
            
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
            
            // Indicate this is a new reminder
            [self setReminderIsNew:YES];
            
        } else {
            
            // If the Reminder instance is not new, set the navigation bar title as "Detail"
            [[self navigationItem] setTitle:@"Detail"];
            
            // Create a "Done" button and set it as the right bar button item of the navigation bar
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(done:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            // Indicate this is not a new reminder
            [self setReminderIsNew:NO];
            
        }
    }
    
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong Initializer"
                                   reason:@"Use initForNewReminder: instead"
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
    
    // Configure the scroll view
    [_scrollView setScrollEnabled:YES];
    [_scrollView setFrame:CGRectMake(0, 0, 320, 568)];
    [_scrollView setContentSize:CGSizeMake(320, 415)];
    
    // If the reminder is new...
    if (_reminderIsNew == YES) {
        
        [_reminderTextField becomeFirstResponder];
        
        // Set the UI
        _alarmSwitch.on = NO;
        _repeatAlarmSwitch.on = NO;
        _repeatAlarmSwitch.enabled = NO;
        _alarmDatePicker.userInteractionEnabled = NO;
        _alarmDatePicker.alpha = 0.4;
        _alarmDatePicker.date = [NSDate date];
        [_currentAlarmDateLabel setText:@"Alarm: no alarm date to display"];
    }
    
    
    // If the reminder is not new...
    if (_reminderIsNew == NO) {
        
        // Create a notification assistant object
        CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
        
        // If there is an existing notification for this reminder (notification with same UUID)
        if ([notificationAssistant findLocalNotificationWithUUID:self.correspondingReminder.reminderUUID] == YES) {
            
            // Get the local notification of this reminder
            UILocalNotification *homeworkLocalNotification =
            [notificationAssistant returnLocalNotificationWithUUID:self.correspondingReminder.reminderUUID];
            
            // Set a date object with the notification fire date
            NSDate *notificationDate = homeworkLocalNotification.fireDate;
            
            // Configure the UI to look like an alarm has been set
            _alarmSwitch.on = YES;
            
            // Configure the alarm date label with a good format
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [_currentAlarmDateLabel setText:[NSString stringWithFormat:@"Alarm: %@",
                                             [dateFormatter stringFromDate:notificationDate]]];
            
        } else {
            
            // Configure the UI to look like an alarm has not been set
            _alarmSwitch.on = NO;
            _alarmDatePicker.userInteractionEnabled = NO;
            _alarmDatePicker.alpha = 0.4;
            [_alarmDatePicker setDate:[NSDate dateWithTimeIntervalSinceNow:600]];
            [_currentAlarmDateLabel setText:@"Alarm: no alarm date to display"];
        }
        
        
        // If the reminder has an alarm that repeats...
        if (_correspondingReminder.reminderRepeatsAlarm == YES) {
            
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
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[self view] endEditing:YES];
    
    // Set the UI elements
    [_reminderTextField setText:[_correspondingReminder reminderTitle]];
    [_notesTextField setText:[_correspondingReminder reminderNotes]];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Save changes made in the Reminder Detail view to corresponding reminder
    [_correspondingReminder setReminderTitle:[_reminderTextField text]];
    [_correspondingReminder setReminderNotes:[_notesTextField text]];
    
    if (_alarmSwitch.on == YES) {
        
        [_correspondingReminder setReminderHasAlarm:YES];
    } else {
        
        [_correspondingReminder setReminderHasAlarm:NO];
    }
    if (_repeatAlarmSwitch.on == YES) {
        
        [_correspondingReminder setReminderHasAlarm:YES];
    } else {
        
        [_correspondingReminder setReminderHasAlarm:NO];
    }
}



#pragma mark - IBActions

- (IBAction)save:(id)sender
{
    // Check if the title text field has some text on it
    if ([_reminderTextField.text isEqualToString:@""]) {
        
        // If the text field is empty, don't allow the user to proceed
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You can't leave the title empty"
                                                        message:@"Please put a title to continue"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    // Save changes made in the Reminder Detail view to corresponding reminder
    [_correspondingReminder setReminderTitle:[_reminderTextField text]];
    [_correspondingReminder setReminderNotes:[_notesTextField text]];
    
    if (_alarmSwitch.on == YES) {
        
        [_correspondingReminder setReminderHasAlarm:YES];
    } else {
        
        [_correspondingReminder setReminderHasAlarm:NO];
    }
    if (_repeatAlarmSwitch.on == YES) {
        
        [_correspondingReminder setReminderHasAlarm:YES];
    } else {
        
        [_correspondingReminder setReminderHasAlarm:NO];
    }
    
    BOOL successSavingReminders = [[CLRMReminderStore sharedStore] saveChanges];
    
    if (successSavingReminders) {
        NSLog(@"Saved all the reminders");
    } else {
        NSLog(@"Could not save any of the reminders");
    }
    
    // When the save button is pressed, return to the Homework List
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:nil];
}


- (IBAction)done:(id)sender
{
    // If the user left the reminder title empty...
    if ([_reminderTextField.text isEqualToString:@""]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You can't leave the title empty"
                                                            message:@"Please put a title to continue"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    
    // Save changes made in the reminder detail view to corresponding reminder
    [_correspondingReminder setReminderTitle:[_reminderTextField text]];
    [_correspondingReminder setReminderNotes:[_notesTextField text]];
    
    if (_alarmSwitch.on == YES) {
        
        [_correspondingReminder setReminderHasAlarm:YES];
    } else {
        
        [_correspondingReminder setReminderHasAlarm:NO];
    }
    if (_repeatAlarmSwitch.on == YES) {
        
        [_correspondingReminder setReminderHasAlarm:YES];
    } else {
        
        [_correspondingReminder setReminderHasAlarm:NO];
    }
    
    BOOL successSavingReminders = [[CLRMReminderStore sharedStore] saveChanges];
    
    if (successSavingReminders) {
        NSLog(@"Saved all the reminders");
    } else {
        NSLog(@"Could not save any of the reminders");
    }
    
    // When the save button is pressed, return to the Homework List
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:nil];
}


- (IBAction)cancel:(id)sender
{
    // If the user cancelled, remove the CLRMHomework instance from the store
    [[CLRMReminderStore sharedStore] removeReminder:_correspondingReminder];
    
    // Dismiss the view controller
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:nil];
}


- (void)alarmToggle:(id)sender
{
    // If the homework title field is empty
    if ([_reminderTextField.text isEqualToString:@""]) {
        
        // Tell the user that he/she must put a title first to schedule a notification
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No title detected"
                                                            message:@"To add an alarm, set the title for this reminder first"
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
    
    
    if (_alarmSwitch.on == YES) {
        
        _repeatAlarmSwitch.enabled = YES;
        _alarmDatePicker.userInteractionEnabled = YES;
        _alarmDatePicker.alpha = 1.0;
        
        // Set the date of the alarm date picker to 10 minutes later
        [_alarmDatePicker setDate:[NSDate dateWithTimeIntervalSinceNow:600]];
        
        //Create a local notification object
        CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
        
        // Create a string with the homework UUID
        NSString *reminderUUID = self.correspondingReminder.reminderUUID;
        
        // Create a dictionary, to use it for the local notification userInfo
        NSDictionary *info = [NSDictionary dictionaryWithObjects:@[@"Reminder", reminderUUID] forKeys:@[@"Type", @"UUID"]];
        
        // Call the local notification assistant method to schedule the notification
        [notificationAssistant addLocalNotificationWithAlertBody:_reminderTextField.text
                                                        fireDate:_alarmDatePicker.date
                                                  repeatInterval:0
                                                        userInfo:info];
        
        // Configure the alarm date label with a good format
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_currentAlarmDateLabel setText:[NSString stringWithFormat:@"Alarm: %@",
                                         [dateFormatter stringFromDate:_alarmDatePicker.date]]];
    }
    
    
    if (_alarmSwitch.on == NO) {
        
        _repeatAlarmSwitch.enabled = NO;
        _repeatAlarmSwitch.on = NO;
        _alarmDatePicker.userInteractionEnabled = NO;
        _alarmDatePicker.alpha = 0.4;
        
        // Create a local notification object
        CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
        
        // Create a string with the homework UUID
        NSString *reminderUUID = self.correspondingReminder.reminderUUID;
        
        // Delete the local notification of this homework
        [notificationAssistant deleteLocalNotificationWithUUID:reminderUUID];
        
        [_currentAlarmDateLabel setText:@"Alarm: no alarm date to display"];
    }
}


- (void)repeatToggle:(id)sender
{
    // Create a notification assistant object
    CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
    
    // Make an NSCalendarUnit and get the corresponding homework UUID
    NSCalendarUnit dayRepeat = NSDayCalendarUnit;
    NSString *homeworkUUID = self.correspondingReminder.reminderUUID;
    
    // If the repeat alarm switch is on...
    if (_repeatAlarmSwitch.on == YES) {
        
        // Modify the notification to have the repeat every day behavior
        [notificationAssistant modifyLocalNotificationWithUUID:self.correspondingReminder.reminderUUID
                                              notificationType:@"Reminder"
                                                  newAlertBody:_reminderTextField.text
                                                   newFireDate:_alarmDatePicker.date
                                             newRepeatInterval:dayRepeat
                                                   newUserInfo:@{@"Type":@"Reminder", @"UUID":homeworkUUID}];
    }
    
    
    // If the repeat alarm switch is off...
    if (_repeatAlarmSwitch.on == NO) {
        
        // Modify the notification to stop it from repeating
        [notificationAssistant modifyLocalNotificationWithUUID:self.correspondingReminder.reminderUUID
                                              notificationType:@"Reminder"
                                                  newAlertBody:_reminderTextField.text
                                                   newFireDate:_alarmDatePicker.date
                                             newRepeatInterval:0
                                                   newUserInfo:@{@"Type":@"Reminder", @"UUID":homeworkUUID}];
    }
}


- (void)changeAlarmDate:(id)sender
{
    // Make a NSFormatter object to configure the alarm date label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [_currentAlarmDateLabel setText:[NSString stringWithFormat:@"Alarm: %@",
                              [dateFormatter stringFromDate:_alarmDatePicker.date]]];
    
    // Make some variables
    CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
    NSString *reminderUUID = self.correspondingReminder.reminderUUID;
    NSCalendarUnit dayRepeat = NSDayCalendarUnit;
    
    // If the repeat switch is on...
    if (_repeatAlarmSwitch.on == YES) {
        
        // Modify the notification with a new fire date and a repeat interval (every day)
        [notificationAssistant modifyLocalNotificationWithUUID:self.correspondingReminder.reminderUUID
                                              notificationType:@"Reminder"
                                                  newAlertBody:_reminderTextField.text
                                                   newFireDate:_alarmDatePicker.date
                                             newRepeatInterval:dayRepeat
                                                   newUserInfo:@{@"Type":@"Reminder", @"UUID":reminderUUID}];
    }
    
    
    // If the repeat switch is off...
    if (_repeatAlarmSwitch.on == NO) {
        
        // Modify the notification with a new date without a repeat interval
        [notificationAssistant modifyLocalNotificationWithUUID:self.correspondingReminder.reminderUUID
                                              notificationType:@"Reminder"
                                                  newAlertBody:_reminderTextField.text
                                                   newFireDate:_alarmDatePicker.date
                                             newRepeatInterval:0
                                                   newUserInfo:@{@"Type":@"Reminder", @"UUID":reminderUUID}];
    }
}



#pragma mark - UITextFieldDelegate methods and keyboard hide methods

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


// This methods is mostly for ensuring that the Reminder will have a name
// and if there is no name, the user can't set an alarm
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
    
    if (_alarmSwitch.on == YES) {
        
        // Create some variables
        NSString *reminderUUID = self.correspondingReminder.reminderUUID;
        NSCalendarUnit dayRepeat = NSDayCalendarUnit;
        
        // If the repeat switch is on...
        if (_repeatAlarmSwitch.on == YES) {
            
            // Modity the current notification
            [notificationAssistant modifyLocalNotificationWithUUID:self.correspondingReminder.reminderUUID
                                                  notificationType:@"Reminder"
                                                      newAlertBody:_reminderTextField.text
                                                       newFireDate:_alarmDatePicker.date
                                                 newRepeatInterval:dayRepeat
                                                       newUserInfo:@{@"Type":@"Reminder", @"UUID":reminderUUID}];
        }
        
        // If the alarm switch is off...
        if (_repeatAlarmSwitch.on == NO) {
            
            // Modity the current notification
            [notificationAssistant modifyLocalNotificationWithUUID:self.correspondingReminder.reminderUUID
                                                  notificationType:@"Reminder"
                                                      newAlertBody:_reminderTextField.text
                                                       newFireDate:_alarmDatePicker.date
                                                 newRepeatInterval:0
                                                       newUserInfo:@{@"Type":@"Reminder", @"UUID":reminderUUID}];
        }
    }
    
    return YES;
}

@end
