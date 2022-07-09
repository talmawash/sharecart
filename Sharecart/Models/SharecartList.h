//
//  List.h
//  Sharecart
//
//  Created by Tariq Almawash on 7/8/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface SharecartList : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFUser *creator;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) PFRelation *items;

@end

NS_ASSUME_NONNULL_END
