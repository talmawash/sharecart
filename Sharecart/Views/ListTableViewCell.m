//
//  ListTableViewCell.m
//  Sharecart
//
//  Created by Tariq Almawash on 7/8/22.
//

#import "ListTableViewCell.h"

@interface ListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblListName;

@end

@implementation ListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadView {
    self.lblListName.text = self.listName;
}

@end
