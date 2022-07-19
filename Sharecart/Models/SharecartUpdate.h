//
//  SharecartUpdate.h
//  Sharecart
//
//  Created by Tariq Almawash on 7/15/22.
//

#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface SharecartUpdate : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) PFObject *before;
@property (nonatomic, strong) PFObject *after;
@property (nonatomic) NSInteger *number; // This number is unique to its context, e.g. each list will have update no. 2 regarding it or its time and each user will have update no. 2 regarding his own data.

@end

NS_ASSUME_NONNULL_END
