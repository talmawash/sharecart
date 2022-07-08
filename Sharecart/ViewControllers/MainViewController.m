//
//  MainViewController.m
//  Sharecart
//
//  Created by Tariq Almawash on 7/7/22.
//

#import "MainViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "SharecartList.h"

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
- (IBAction)addListTap:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                                     message: @"Create New List"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
       [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
           textField.placeholder = @"List Name";
       }];
       [alertController addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
           UITextField * listNameField = alertController.textFields[0];

           SharecartList *newList = [SharecartList new];
           newList.name = listNameField.text;
           newList.creator = [PFUser currentUser];
           [newList saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
               if (!error) {
                   NSLog(@"Created \"%@\" successfully", newList.name);
               }
               else {
                   NSLog(@"Error with list creation: %@", error);
               }
           }];
       }]];
       [self presentViewController:alertController animated:YES completion:nil];
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
