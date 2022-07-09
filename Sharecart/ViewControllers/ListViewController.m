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

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
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
