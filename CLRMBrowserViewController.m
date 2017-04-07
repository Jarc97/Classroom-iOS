//
//  CLRMBrowserViewController.m
//  Classroom
//
//  Created by Julio Rodríguez on 16/02/14.
//
//

#import "CLRMBrowserViewController.h"
#import "CLRMWebPageListViewController.h"
#import "CLRMWebPageDetailViewController.h"
#import "CLRMWebPageStore.h"
#import "CLRMWebPage.h"

@interface CLRMBrowserViewController ()

@end

@implementation CLRMBrowserViewController

#pragma mark - @synthesize declarations

@synthesize browserWebView = _browserWebView;
@synthesize activityIndicator = _activityIndicator;


#pragma mark - initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        
        // ----------Customization of the Navigation Bar-----------
        
        // Get the navigationItem and create UISearchBar instance
        UINavigationItem *navigationItem = [self navigationItem];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
        
        // init the navigationItem with searchBar inside it (left), and set its placeholder
        searchBar.backgroundImage = [[UIImage alloc] init];
        navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
        [searchBar setPlaceholder:@"Search"];
        [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [searchBar setKeyboardType:UIKeyboardTypeDefault];
        
        // Create the activity indicator and place it in the Navigation Bar (right), and make it hidden
        _activityIndicator = [[UIActivityIndicatorView alloc] init];
        navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicator];
        _activityIndicator.hidden = YES;
        
        // set the searchBar delete to self
        [searchBar setDelegate:self];
    }
    
    return self;
}


- (id)init
{
    // If init is called when creating and instance of this class,
    // use initWithNibName:bundle: instead
    return [self initWithNibName:@"CLRMBrowserViewController" bundle:nil];
}



#pragma mark - IBActions

// Triggered when user taps Favorites on the toolbar (XIB)
- (IBAction)showFavorites:(id)sender
{
    // Create the instace of WebPageList
    CLRMWebPageListViewController *webPageList = [[CLRMWebPageListViewController alloc] init];
    
    // Make a Navigation Controller for the view and set its rootViewController
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:webPageList];
    
    // Set the color of the navigation bar
    [[navigationController navigationBar] setBarTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:1.0 alpha:1.0]];
    
    // Present view controller
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (IBAction)addNewWebPage:(id)sender
{
    // Create a Web Page Detail view
    CLRMWebPageDetailViewController *detailView = [[CLRMWebPageDetailViewController alloc] initForNewWebPage:YES];
    
    // Get the current URL string that the web view is displaying
    NSString *currentURL = _browserWebView.request.URL.absoluteString;
    
    CLRMWebPage *webPageToAdd = [[CLRMWebPageStore sharedStore] createWebPage];
    
    [webPageToAdd setWebPageName:@""];
    [webPageToAdd setWebPageURL:currentURL];
    
    [detailView setCorrespondingWebPage:webPageToAdd];
    
    // Create a navigation controller
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:detailView];
    
    // Set the color of the navigation bar
    [[navigationController navigationBar] setBarTintColor:[UIColor colorWithRed:0.0 green:0.7 blue:1.0 alpha:1.0]];
    
    // Present the view controller
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (IBAction)showMenu:(id)sender
{
    // Dismiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Search Bar Delegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Hide the keyboard
    [searchBar resignFirstResponder];
    
    // Get the text in the search field
    NSMutableString *searchFieldString = [[NSMutableString alloc] initWithFormat:@"%@", searchBar.text];
    
    // Create a new string without spaces (replaced by the "+" symbol)
    NSString * newString = [searchFieldString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    // Load the web page entered in the search bar
    [_browserWebView loadRequest:[NSURLRequest requestWithURL:
                                  [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/search?q=%@", newString]]]];
}



#pragma mark - View Controller Lifecycle

// This method is called when the browser tab is selected
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // This timer will make the loadingWebPage method run with no stop
    _timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(loadingWebPage) userInfo:nil repeats:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Access the User Defaults and get the saved URL
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *savedURL = [userDefaults objectForKey:@"Browser Current Web Page"];
    
    // If the savedURL doesn't exist...
    if (!savedURL) {
        
        // Load google search
        [_browserWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
        
        return;
    }
    
    // Create an URL from a string
    NSURL *urlToLoad = [NSURL URLWithString:savedURL];
    
    // Load the URL
    [_browserWebView loadRequest:[NSURLRequest requestWithURL:urlToLoad]];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Get the current URL string that the web view is displaying
    NSString *currentURL = _browserWebView.request.URL.absoluteString;
    
    // If there is an URL
    if (currentURL) {
        
        // Save the URL string in the User Defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:currentURL forKey:@"Browser Current Web Page"];
        
    }
}



#pragma mark - Web View management methods

// This method gets called infinitely by "_timer"
// to check if the UIWebView is loading a new web page
- (void)loadingWebPage
{
    // If web view is loading, start animating the activity indicator, otherwise no
    if (_browserWebView.loading) {
        
        [_activityIndicator startAnimating];
        
    } else {
        
        [_activityIndicator stopAnimating];
    }
}



#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"Memory Warning in Browser");
}

@end
