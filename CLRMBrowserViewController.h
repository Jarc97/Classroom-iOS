//
//  CLRMBrowserViewController.h
//  Classroom
//
//  Created by Julio Rodríguez on 16/02/14.
//
//

#import <UIKit/UIKit.h>

@interface CLRMBrowserViewController : UIViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *browserWebView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSTimer *timer;

- (IBAction)showFavorites:(id)sender;
- (IBAction)addNewWebPage:(id)sender;

@end
