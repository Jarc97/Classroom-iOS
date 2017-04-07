//
//  CLRMRemindersViewController.m
//  Classroom
//
//  Created by Julio Rodríguez on 07/02/14.
//
//

#import "CLRMRemindersViewController.h"

#import "CLRMReminderStore.h"
#import "CLRMReminder.h"

#import "CLRMReminderDetailViewController.h"

#import "CLRMLocalNotificationAssistant.h"

@interface CLRMRemindersViewController ()

@end

@implementation CLRMRemindersViewController


#pragma mark - UITableView Data Source methods

// This method tells how many rows to display
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // Log in the console the number of Reminder Instances
    NSLog(@"The reminder store has %d", [[[CLRMReminderStore sharedStore] allCreatedReminders] count]);
    
    if ([[[CLRMReminderStore sharedStore] allCreatedReminders] count] == 0) {
        
        // Maybe disable edit button
    }
    
    return [[[CLRMReminderStore sharedStore] allCreatedReminders] count];
}


// This method fills the cells
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLRMReminder *reminder = [[[CLRMReminderStore sharedStore] allReminders] objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Reminder Cell"];
    
    // Configure the cell title
    [[cell textLabel] setText:[reminder reminderTitle]];
    [[cell detailTextLabel] setText:[reminder reminderNotes]];
    
    // Set a disclosure indicatior for every cell
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}


// This method manages the deleting process
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view asks to delete a cell from the table...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Get the sharedStore
        CLRMReminderStore *reminderStore = [CLRMReminderStore sharedStore];
        
        // Get the mutable array of reminders, and get the
        // index path of a particular reminder...
        NSArray *reminderInstances = [reminderStore allReminders];
        CLRMReminder *reminderToDelete = [reminderInstances objectAtIndex:[indexPath row]];
        
        // Create a local notification assistant and delete a notification with the same UUID as this homework
        CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
        [notificationAssistant deleteLocalNotificationWithUUID:reminderToDelete.reminderUUID];
        
        // Delete that reminder from the sharedStore
        [reminderStore removeReminder:reminderToDelete];
        
        // Also remove that row from the table view, with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


// This method manages the row ordering
- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[CLRMReminderStore sharedStore] moveReminderAtIndex:[sourceIndexPath row]
                                                 toIndex:[destinationIndexPath row]];
}



#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create instance of ReminderDetailViewController (not for a new homework)
    CLRMReminderDetailViewController *reminderDetail = [[CLRMReminderDetailViewController alloc] initForNewReminder:NO];
    
    // Give ReminderDetail a reference to the row that was tapped
    // (the reminder instance that ReminderDetail will show)
    NSArray *reminders = [[CLRMReminderStore sharedStore] allCreatedReminders];
    CLRMReminder *selectedReminder = [reminders objectAtIndex:[indexPath row]];
    
    // Give CLRMReminderDetailViewController a pointer to the item object in the row
    [reminderDetail setCorrespondingReminder:selectedReminder];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:reminderDetail];
    
    // Set the color of the navigation bar
    [[navigationController navigationBar] setBarTintColor:[UIColor colorWithRed:0.5 green:1.0 blue:0.3 alpha:1.0]];
    
    // Push it into the top of the navigation controller stack
    [self presentViewController:navigationController animated:YES completion:nil];
}



#pragma mark - Target-Action methods

- (IBAction)addNewReminder:(id)sender
{
    // Create a new instance of a reminder
    CLRMReminder *newReminder = [[CLRMReminderStore sharedStore] createReminder];
    
    // Create the instace of reminderDetail and specify it is a new item
    CLRMReminderDetailViewController *detailViewController = [[CLRMReminderDetailViewController alloc] initForNewReminder:YES];
    
    // Set the detailViewController to the corresponding reminder
    [detailViewController setCorrespondingReminder:newReminder];
    
    // Set the rootViewController of the Navigation Controller
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:detailViewController];
    
    // Set the color of the navigation bar
    [[navigationController navigationBar] setBarTintColor:[UIColor colorWithRed:0.5 green:1.0 blue:0.3 alpha:1.0]];
    
    // Present view controller
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (IBAction)showMenu:(id)sender
{
    // Dismiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // Reload data of the table view
    [[self tableView] reloadData];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Save all changes made in the Reminders
    BOOL successSavingHomework = [[CLRMReminderStore sharedStore] saveChanges];
    
    if (successSavingHomework) {
        NSLog(@"Saved all the Reminders");
    } else {
        NSLog(@"Could not save any of the Reminders");
    }
}


#pragma mark - initializers

- (id)init
{
    // Call the superclass designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        // --------------------Navigation Bar customization--------------------
        
        // Set the Tab Bar title to "Reminders"
        [[self navigationItem] setTitle:@"Reminders"];
        
        UIImage *menuIcon = [UIImage imageNamed:@"Menu_Icon"];
        
        // Create the bar button item that will send showMenu: to CLRMHomeworkViewController
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                                       initWithImage:menuIcon
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(showMenu:)];
        
        // Set menuButton as the left item in the navigationItem
        [[self navigationItem] setLeftBarButtonItem:menuButton];
        
        // Create bar button item that will send, addNewReminder: to CLRMReminderViewController
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self
                                      action:@selector(addNewReminder:)];
        
        // Set the addNewReminder and editButton as the right items in the navigationItem
        [[self navigationItem] setRightBarButtonItems:[NSArray arrayWithObjects:addButton, [self editButtonItem], nil]];
        
        // Set the height of the rows in the table view
        self.tableView.rowHeight = 55;
    }
    
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    // Ensure that the style is plain
    return [self init];
}


@end
