//
//  ListViewController.h
//  Sharecart
//
//  Created by Tariq Almawash on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "SharecartList.h"
#import "SharecartItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListViewController : UIViewController<UITableViewDataSource>

@property (weak, nonatomic) SharecartList *list;

- (void)itemAddUpdate:(SharecartItem*) item;

@end

NS_ASSUME_NONNULL_END
