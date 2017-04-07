//
//  CLRMWebPageListViewController.m
//  Classroom
//
//  Created by Julio Rodríguez on 27/02/14.
//
//

#import "CLRMWebPageListViewController.h"
#import "CLRMWebPageStore.h"
#import "CLRMWebPage.h"

#import "CLRMWebPageDetailViewController.h"

@interface CLRMWebPageListViewController ()

@end

@implementation CLRMWebPageListViewController


#pragma mark - Table View Data Source methods

// This method tells how many rows to display
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"The favorites store has %d", [[[CLRMWebPageStore sharedStore] allCreatedWebPages] count]);
    
    if ([[[CLRMWebPageStore sharedStore] allCreatedWebPages] count] == 0) {
        
        // Maybe disable edit button
        
    }
    
    return [[[CLRMWebPageStore sharedStore] allCreatedWebPages] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check for a reusable cell first, use it if exist
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    // Set the text of the cell
    CLRMWebPage *webPage = [[[CLRMWebPageStore sharedStore] allCreatedWebPages] objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[webPage nameDescription]];
    
    [[cell detailTextLabel] setText:[webPage urlDescription]];
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
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
        CLRMWebPageStore *webPageStore = [CLRMWebPageStore sharedStore];
        
        // Get the mutable array (allWebPages), not the array (allCreatedWebPages)
        // and get the index path of a particular homework...
        NSArray *webPages = [webPageStore allWebPages];
        CLRMWebPage *webPagesIndexPath = [webPages objectAtIndex:[indexPath row]];
        
        // Delete that homework from the sharedStore
        [webPageStore removeWebPage:webPagesIndexPath];
        
        // Also remove that row from the table view, with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


// This method manages the row ordering
- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[CLRMWebPageStore sharedStore] moveItemAtIndex:[sourceIndexPath row]
                                             toIndex:[destinationIndexPath row]];
}


#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Load URL");
    
    NSArray *webPages = [[CLRMWebPageStore sharedStore] allCreatedWebPages];
    CLRMWebPage *selectedWebPage = [webPages objectAtIndex:[indexPath row]];
    
    NSString *urlStringToLoad = selectedWebPage.urlDescription;
    
    // Save the URL string in the User Defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:urlStringToLoad forKey:@"Browser Current Web Page"];
    
    
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // Create instance of WebPageDetail
    CLRMWebPageDetailViewController *webPageDetail = [[CLRMWebPageDetailViewController alloc] initForNewWebPage:NO];
    
    // Give WebPageDetail a reference to the row that was tapped
    // (the homework instance that WebPageDetail will show)
    NSArray *webPages = [[CLRMWebPageStore sharedStore] allCreatedWebPages];
    CLRMWebPage *selectedWebPage = [webPages objectAtIndex:[indexPath row]];
    
    // Give CLRMWebPageDetailViewController a pointer to the item object in the row
    [webPageDetail setCorrespondingWebPage:selectedWebPage];
    
    // Push it into the top of the navigation controller stack
    [[self navigationController] pushViewController:webPageDetail animated:YES];
}


#pragma mark - Target-Action methods

- (IBAction)dismissFavorites:(id)sender
{
    // Make the WebPageList disappear
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Reload data of the table view
    [[self tableView] reloadData];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Save all changes made in the Homework
    BOOL successSavingHomework = [[CLRMWebPageStore sharedStore] saveChanges];
    
    if (successSavingHomework) {
        NSLog(@"Saved all the Web Pages");
    } else {
        NSLog(@"Could not save any of the Web Pages");
    }
}



#pragma mark - initializers

- (id)init
{
    // Call the superclass designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        // --------------------Navigation Bar customization--------------------
        
        // Set the Tab Bar title to "Favorites"
        UINavigationItem *navigationItem = [self navigationItem];
        [navigationItem setTitle:@"Favorites"];
        
        // Create bar button item that will send dismiss the Favorites view
        UIBarButtonItem *okButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(dismissFavorites:)];
        
        
        // Set okButton as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:okButton];
        
        // Set the addButton and editButtonItem as the left items in the navigationItem
        [[self navigationItem] setLeftBarButtonItems:[NSArray arrayWithObjects: [self editButtonItem], nil]];
    }
    
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    // Ensure that the style is plain
    return [self init];
}



#pragma mark - Memory warning method

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
