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
@property (strong, nonatomic) NSArray *items;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    [self loadItems];
}

- (void) loadItems {
    // TODO: live query to check for changes
    PFRelation *relationToItems = self.list.items;
    PFQuery *itemsQuery = [relationToItems query];
    [itemsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
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

           SharecartItem *newItem = [SharecartItem new];
           newItem.name = alertController.textFields[0].text;
           newItem.list = self.list;
           [newItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
               if (!error) {
                   // TODO: Instead of making too many requests write cloud function that adds the item
                   [self.list fetch]; // Ensure up to date item data
                   [self.list.items addObject:newItem]; // Add locally
                   [self.list save]; // Send update
                   [self.list fetch]; // Fetch after adding to the databawse
                   [self loadItems];
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