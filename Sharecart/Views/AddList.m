//
//  AddList.m
//  Sharecart
//
//  Created by Tariq Almawash on 7/20/22.
//

#import "AddList.h"
#import "Sharecart-Swift.h"

@interface AddList()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITextField *txtMain;
@end

@implementation AddList

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self segmentChange:self];
}

- (IBAction)segmentChange:(id)sender {
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [self.btnSubmit.titleLabel setText:@"Create"];
        self.txtMain.placeholder = @"New list name";
        self.txtMain.text = @"";
    }
    else {
        [self.btnSubmit.titleLabel setText:@"Join"];
        self.txtMain.placeholder = @"Invitation code";
        self.txtMain.text = @"";
    }
}

- (IBAction)buttonTap:(id)sender {
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [self.btnSubmit.titleLabel setText:@"Create"];
        self.txtMain.placeholder = @"New list name";
        self.txtMain.text = @"";
    }
    else {
        [self.btnSubmit.titleLabel setText:@"Join"];
        self.txtMain.placeholder = @"Invitation code";
        self.txtMain.text = @"";
    }
}
@end
