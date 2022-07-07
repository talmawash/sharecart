//
//  MainViewController.m
//  Sharecart
//
//  Created by Tariq Almawash on 7/7/22.
//

#import "MainViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)signoutTap:(id)sender {
    [PFUser logOut];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SceneDelegate *sd = self.view.window.windowScene.delegate;
    if ([sd.window.rootViewController isKindOfClass:[UINavigationController class]]) // Case 1: User was logged in when the app started, so we need a LoginViewController
    {
        sd.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    }
    else { // Case 2: A LoginViewController already exists, so dismiss this view to get to it.
        [self dismissViewControllerAnimated:YES completion:^{
            // TODO: Post sign out UI clean up?
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
