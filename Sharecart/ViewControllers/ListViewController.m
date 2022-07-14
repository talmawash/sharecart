//
//  ListViewController.m
//  Sharecart
//
//  Created by Tariq Almawash on 7/8/22.
//

#import "ListViewController.h"
#import "SharecartItem.h"

@interface ListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    [self loadItems];
}

- (void) loadItems {
    // TODO: live query to check for changes
    [PFCloud callFunctionInBackground:@"getItems" withParameters:@{@"listId": self.list.objectId} block:^(id  _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.items = objects;
            [self.tableView reloadData];
        }
        else {
            // TODO: Prompt user to check connection and try again
        }
    }];
}

#pragma mark - Taps

- (IBAction)dismissTap:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)addItemTap:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                                     message: @"Add New Item"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
       [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
           textField.placeholder = @"Item Name";
       }];
       [alertController addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

           [PFCloud callFunctionInBackground:@"newItem" withParameters:@{@"name": alertController.textFields[0].text, @"listId": self.list.objectId} block:^(id  _Nullable object, NSError * _Nullable error) {
               if (!error) {
                   [self.items addObject:object];
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
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    cell.textLabel.text = ((SharecartItem*)self.items[indexPath.row]).name;
    return cell;
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
