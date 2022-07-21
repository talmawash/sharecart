//
//  AddList.h
//  Sharecart
//
//  Created by Tariq Almawash on 7/20/22.
//

#import <UIKit/UIKit.h>
#import "SharecartList.h"
NS_ASSUME_NONNULL_BEGIN

@protocol AddListViewDelegate;
@interface AddListViewDelegate
- (void) onListAdded:(SharecartList*)list;
- (void) onListJoined:(SharecartList*)list;
@end

@interface AddList : UIScrollView

@property (weak, nonatomic) AddListViewDelegate* addListDelegate;

@end

NS_ASSUME_NONNULL_END
