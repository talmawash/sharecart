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
        if (error == nil) {
            [self performSegueWithIdentifier:@"firstSegue" sender:nil];
        } else {
            // TODO: Handle sign in error
        }
    }];
}

- (IBAction)registerUser:(id)sender {
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.txtUsername.text;
    newUser.password = self.txtPassword.text;
    
    // Parse requires public database write permissions to sign up users but not for signing in, which Parse *probably* manages well
    [PFCloud callFunctionInBackground:@"signup" withParameters:@{@"username": newUser.username, @"password": newUser.password} block:^(id  _Nullable object, NSError * _Nullable error) {
        if (error == nil) {
            [self loginUser:sender]; // Calling the sign in function to generate a session token
        } else {
            // TODO: Handle sign out error
        }
    }];
}



@end
