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
#import "ListTableViewCell.h"
#import "ListViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *lists;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    //TODO: Make this a LIVE query that detects when changes occur
    [PFCloud callFunctionInBackground:@"getLists" withParameters:@{} block:^(id  _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.lists = objects;
            [self.tableView reloadData];
        }
        else {
            // TODO: Prompt user to check connection and try again
        }
    }];
}

#pragma mark - Taps

- (IBAction)signoutTap:(id)sender {
    [PFUser logOut];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SceneDelegate *sd = (SceneDelegate*)self.view.window.windowScene.delegate;
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

           [PFCloud callFunctionInBackground:@"newList" withParameters:@{@"name": listNameField.text} block:^(id  _Nullable object, NSError * _Nullable error) {
               if (!error) {
                   [self.lists addObject:object];
                   [self.tableView reloadData];
               }
               else {
                   // TODO: Prompt user to check connection and try again
               }
           }];
       }]];
       [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    cell.listName = ((SharecartList*)self.lists[indexPath.row]).name;
    [cell loadView];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];

    if ([navigationController.topViewController isKindOfClass:[ListViewController class]]) {
        ListViewController *dvc = (ListViewController*)navigationController.topViewController;
        dvc.list = self.lists[self.tableView.indexPathForSelectedRow.row];
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:TRUE];
    }
}


@end
