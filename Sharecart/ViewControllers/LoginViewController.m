//
//  LoginViewController.m
//  Sharecart
//
//  Created by Tariq Almawash on 7/6/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginUser:(id)sender {
    NSString *username = self.txtUsername.text;
    NSString *password = self.txtPassword.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
        } else {
            [self performSegueWithIdentifier:@"firstSegue" sender:nil];
        }
    }];
}

- (IBAction)registerUser:(id)sender {
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.txtUsername.text;
    newUser.password = self.txtPassword.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
        } else {
            [self performSegueWithIdentifier:@"firstSegue" sender:nil];
        }
    }];
}



@end
