//
//  SharecartItem.h
//  Sharecart
//
//  Created by Tariq Almawash on 7/8/22.
//

#import <Parse/Parse.h>
#import "SharecartList.h"

NS_ASSUME_NONNULL_BEGIN

@interface SharecartItem : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) SharecartList *list;

@end

NS_ASSUME_NONNULL_END
