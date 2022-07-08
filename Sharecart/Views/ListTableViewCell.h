//
//  ListTableViewCell.h
//  Sharecart
//
//  Created by Tariq Almawash on 7/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListTableViewCell : UITableViewCell

@property (weak, nonatomic) NSString *listName;

- (void)loadView;

@end

NS_ASSUME_NONNULL_END
