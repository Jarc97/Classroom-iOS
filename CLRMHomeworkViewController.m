//
//  CLRMHomeworksViewController.m
//  Classroom
//
//  Created by Julio Rodríguez on 03/02/14.
//
//

#import "CLRMHomeworkViewController.h"

#import "CLRMHomeworkStore.h"
#import "CLRMHomework.h"
#import "CLRMHomeworkDetailViewController.h"
#import "CLRMLocalNotificationAssistant.h"

@interface CLRMHomeworkViewController ()

@end

@implementation CLRMHomeworkViewController


#pragma mark - UITableView Data Source methods

// This method tells how many rows to display
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // Log in the console the number of Homework Instances
    NSLog(@"The homework store has %lu", (unsigned long)[[[CLRMHomeworkStore sharedStore] allCreatedHomework] count]);
    
    return [[[CLRMHomeworkStore sharedStore] allCreatedHomework] count];
}


// This method fills the cells
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLRMHomework *homework = [[[CLRMHomeworkStore sharedStore] allHomework] objectAtIndex:[indexPath row]];
    
    CLRMHomeworkCell *homeworkCell = [tableView dequeueReusableCellWithIdentifier:@"Homework Cell"];
    
    // Configure the cell title
    [[homeworkCell cellTitleLabel] setText:[homework homeworkTitle]];
    
    
    // Configure the cell priority
    if (homework.priorityDescription == 0) {
        
        [[homeworkCell cellPriorityLabel] setText:@"Low"];
        [[homeworkCell cellPriorityLabel] setTextColor:[UIColor greenColor]];
        
    } else if (homework.priorityDescription == 1) {
        
        [[homeworkCell cellPriorityLabel] setText:@"Medium"];
        [[homeworkCell cellPriorityLabel] setTextColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.1 alpha:1.0]];
        
    } else if (homework.priorityDescription) {
        
        [[homeworkCell cellPriorityLabel] setText:@"High"];
        [[homeworkCell cellPriorityLabel] setTextColor:[UIColor redColor]];
    }
    
    
    // Configure the cell Alarm Icon
    CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
    
    // If there is a notification scheduled for a particular homework...
    if ([notificationAssistant findLocalNotificationWithUUID:homework.homeworkUUID] == YES) {
        
        // Show a bell icon in the table view
        UIImage *bellImage = [UIImage imageNamed:@"Alarm_Set_Icon"];
        [[homeworkCell cellAlarmIcon] setImage:bellImage];
        
    } else {
        
        // Don't show the bell icon
        [[homeworkCell cellAlarmIcon] setImage:nil];
    }
    
    
    // Configure other details
    [[homeworkCell cellCourseLabel] setText:[homework homeworkCourse]];
    [[homeworkCell cellTeacherLabel] setText:[homework homeworkTeacher]];
    [[homeworkCell cellNotesLabel] setText:[homework homeworkNotes]];
    
    
    return homeworkCell;
}


// This method manages the deleting process
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view asks to delete a cell from the table...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Get the sharedStore
        CLRMHomeworkStore *homeworkStore = [CLRMHomeworkStore sharedStore];
        
        // Get the mutable array (allHomework), not the array (allCreatedHomework)
        // and get the index path of a particular homework...
        NSArray *homeworkInstances = [homeworkStore allHomework];
        CLRMHomework *homeworkToDelete = [homeworkInstances objectAtIndex:[indexPath row]];
        
        // Create a local notification assistant and delete a notification with the same UUID as this homework
        CLRMLocalNotificationAssistant *notificationAssistant = [[CLRMLocalNotificationAssistant alloc] init];
        [notificationAssistant deleteLocalNotificationWithUUID:homeworkToDelete.homeworkUUID];
        
        // Delete that homework from the sharedStore
        [homeworkStore removeHomework:homeworkToDelete];
        
        // Also remove that row from the table view, with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        
    }
}


// This method manages the row ordering
- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
           toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[CLRMHomeworkStore sharedStore] moveHomeworkAtIndex:[sourceIndexPath row]
                                                 toIndex:[destinationIndexPath row]];
}



#pragma mark - UITableView Delegate methods

// This method is called when any cell is tapped
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create instance of HomeworkDetailViewController (not for a new homework)
    CLRMHomeworkDetailViewController *homeworkDetail = [[CLRMHomeworkDetailViewController alloc] initForNewHomework:NO];
    
    // Give HomeworkDetail a reference to the row that was tapped
    // (the homework instance that HomeworkDetail will show)
    NSArray *allHomework = [[CLRMHomeworkStore sharedStore] allCreatedHomework];
    CLRMHomework *selectedHomework = [allHomework objectAtIndex:[indexPath row]];
    
    // Give CLRMHomeworkDetailViewController a pointer to the item object in the row
    [homeworkDetail setCorrespondingHomework:selectedHomework];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeworkDetail];
    
    [[navigationController navigationBar] setBarTintColor:[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]];
    
    // Push it into the top of the navigation controller stack
    [self presentViewController:navigationController animated:YES completion:nil];
}



#pragma mark - Target-Action methods

// This method is called when a plus (+) button is pressed
- (IBAction)addNewHomework:(id)sender
{
    // Create a new instance of homework
    CLRMHomework *newHomework = [[CLRMHomeworkStore sharedStore] createHomework];
    
    // Create the instace of HomeworkDetail and specify it is a new item
    CLRMHomeworkDetailViewController *detailViewController = [[CLRMHomeworkDetailViewController alloc] initForNewHomework:YES];
    
    // Set the detailViewController to the corresponding homework
    [detailViewController setCorrespondingHomework:newHomework];
    
    // Set the rootViewController of the Navigation Controller
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:detailViewController];
    
    // Set the color of the navigation bar
    [[navigationController navigationBar] setBarTintColor:[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]];
    
    // Present view controller
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (IBAction)showMenu:(id)sender
{
    // Save all changes made in the Homework
    BOOL successSavingHomework = [[CLRMHomeworkStore sharedStore] saveChanges];
    
    if (successSavingHomework) {
        NSLog(@"Saved all the Homework");
    } else {
        NSLog(@"Could not save any of the Homework");
    }
    
    // Dismiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - View Controller Lifecycle

// Called when the view loads (called after init)
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Load the Homework cell nib file
    UINib *nib = [UINib nibWithNibName:@"CLRMHomeworkCell" bundle:nil];
    
    // Register this nib, which contains the cell
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"Homework Cell"];
}


// Called when the Homework list is about to appear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Reload data of the table view
    [[self tableView] reloadData];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



#pragma mark - initializers

// Called when the CLRMHomeworkViewController object is initialized
- (id)init
{
    // Call the superclass designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        // --------------------Navigation Bar customization--------------------
        
        // Set the Tab Bar title to "Homeworks"
        UINavigationItem *navigationItem = [self navigationItem];
        [navigationItem setTitle:@"Homework"];
        
        // Make an image with Menu_Icon
        UIImage *menuIcon = [UIImage imageNamed:@"Menu_Icon"];
        
        // Create the bar button item that will send showMenu: to CLRMHomeworkViewController
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                                       initWithImage:menuIcon
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(showMenu:)];
        
        // Set menuButton as the left item in the navigationItem
        [[self navigationItem] setLeftBarButtonItem:menuButton];
        
        // Create bar button item that will send, addNewHomework: to CLRMHomeworkViewController
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self
                                      action:@selector(addNewHomework:)];
        
        // Set the addButton and editButton as the right items in the navigationItem
        [[self navigationItem] setRightBarButtonItems:[NSArray arrayWithObjects:addButton, [self editButtonItem], nil]];
        
        // Set the row height of the Table View
        [[self tableView] setRowHeight:100];
    }
    
    return self;
}


// In case this class is initialized with "initWithStyle",
// the method only returns init, so init will be executed instead
- (id)initWithStyle:(UITableViewStyle)style
{
    // Ensure that the style is plain
    return [self init];
}


@end
