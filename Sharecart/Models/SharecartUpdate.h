//
//  SharecartUpdate.h
//  Sharecart
//
//  Created by Tariq Almawash on 7/15/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface SharecartUpdate : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) PFObject *before;
@property (nonatomic, strong) PFObject *after;

@end

NS_ASSUME_NONNULL_END
