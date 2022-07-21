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
#import "SharecartUpdate.h"
#import "SharecartItem.h"
#import "ParseLiveQuery/ParseLiveQuery-umbrella.h"
#import "Sharecart-Swift.h"
@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ListViewController *selectedView;
@property (strong, nonatomic) NSMutableArray *lists;
@property (strong, nonatomic) PFLiveQueryClient *liveQueryClient;
@property (strong, nonatomic) PFLiveQuerySubscription *liveQuerySubscription;
@property (strong, nonatomic) PFQuery *liveQuery;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // Should we cache?
    [PFCloud callFunctionInBackground:@"getLists" withParameters:@{} block:^(id  _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.lists = objects;
            for (SharecartList *curr in objects) {
                NSString *key = [@"lastUpdate_" stringByAppendingString:curr.objectId];
                NSInteger lastUpdate = [prefs integerForKey:key];
                if (lastUpdate == 0) { // Not present in settings
                    [prefs setInteger:curr.lastUpdate forKey:key];
                }
            }
            [self.tableView reloadData];
            [self setupLiveQuery];
        }
        else {
            // TODO: Prompt user to check connection and try again
        }
    }];
}

- (void)setupLiveQuery {
    self.liveQueryClient = [[PFLiveQueryClient alloc] init];
    self.liveQuery = [SharecartUpdate query]; // TODO: Only load new updates (keep track of last loaded)
    [self.liveQuery orderByAscending:@"createdAt"];

    [self.liveQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (SharecartUpdate *curr in objects) {
            // NSLog(@"Had an update of type %@\nChanged from %@\n\nto\n\n%@", curr.type, curr.before, curr.after);
            [self handleMissedUpdate:curr];
        }
    }];

    self.liveQuerySubscription = [[self.liveQueryClient subscribeToQuery:self.liveQuery] addCreateHandler:^(PFQuery<PFObject *> * _Nonnull query, PFObject * _Nonnull object) {
        SharecartUpdate *update = (SharecartUpdate*)object;
        // NSLog(@"Had an update of type %@\nChanged from %@\n\nto\n\n%@", update.type, update.before, update.after);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleNewUpdate: update];
        });
    }];
}

- (void) handleMissedUpdate:(SharecartUpdate *)update {
    if ([update.type isEqualToString:@"itemAdded"]) {
        SharecartItem* updatedItem = [[SharecartItem alloc] init];
        updatedItem.objectId = update.after[@"objectId"];
        updatedItem.list = update.after[@"list"];
        updatedItem.name = update.after[@"name"];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *key = [@"lastUpdate_" stringByAppendingString:updatedItem.list.objectId];
        NSInteger lastUpdate = [prefs integerForKey:key];
        if (lastUpdate < update.number) {
            [prefs setInteger:update.number forKey:key];
            NSString *listName = @"";
            for (SharecartList *curr in self.lists) {
                if ([curr.objectId isEqualToString:updatedItem.list.objectId]) {
                    listName = curr.name;
                }
            }
            NSString *msg = [NSString stringWithFormat:@"Item \"%@\" was added to the list %@ while you were off the app", updatedItem.name, listName];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Updates"
                                           message:msg
                                           preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {}];

            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void) handleNewUpdate:(SharecartUpdate *)update {
    if ([update.type isEqualToString:@"itemAdded"]) {
        SharecartItem* item = [[SharecartItem alloc] init];
        item.objectId = update.after[@"objectId"];
        item.list = update.after[@"list"];
        item.name = update.after[@"name"];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *key = [@"lastUpdate_" stringByAppendingString:item.list.objectId];
        NSInteger lastUpdate = [prefs integerForKey:key];
        if (lastUpdate < update.number) {
            [prefs setInteger:update.number forKey:key];
        }
        if (self.selectedView && self.selectedView.parentViewController /* sometimes the view is not set to null after being dimissed, but parentViewController will be null if the view was dimissed and not garbage collected */) {
            if ([self.selectedView.list.objectId isEqualToString:item.list.objectId]) {
                [self.selectedView itemAddUpdate: item];
            }
        }
    }
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
            // TODO: Post sign out UI clean up? Close live query client
        }];
    }
}
- (IBAction)addListTap:(id)sender {
    [SwiftAdapter displayAddListWithDelegate:self];
}

#pragma mark - Add List View Delegate

- (void)onListAdded:(SharecartList *)list {
    [self.lists insertObject:list atIndex:0];
    NSString *key = [@"lastUpdate_" stringByAppendingString:list.objectId];
    [[NSUserDefaults standardUserDefaults] setInteger:list.lastUpdate forKey:key];
    [self.tableView reloadData];
}

- (void)onListJoined:(SharecartList *)list {
    [self.lists insertObject:list atIndex:0];
    NSString *key = [@"lastUpdate_" stringByAppendingString:list.objectId];
    [[NSUserDefaults standardUserDefaults] setInteger:list.lastUpdate forKey:key];
    [self.tableView reloadData];
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
    UIViewController *nextController = [segue destinationViewController];

    if ([nextController isKindOfClass:[ListViewController class]]) {
        ListViewController *dvc = (ListViewController*)nextController;
        self.selectedView = dvc;
        dvc.list = self.lists[self.tableView.indexPathForSelectedRow.row];
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:TRUE];
    }
}


@end
