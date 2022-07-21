//
//  AddList.m
//  Sharecart
//
//  Created by Tariq Almawash on 7/20/22.
//

#import "AddListView.h"
#import "Sharecart-Swift.h"
#import "Parse/Parse.h"

@interface AddListView()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITextField *txtMain;
@end

@implementation AddListView

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
    [SwiftAdapter showProgressHUD];
    [SwiftAdapter dismissPopup];
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [PFCloud callFunctionInBackground:@"newList" withParameters:@{@"name": self.txtMain.text} block:^(id  _Nullable object, NSError * _Nullable error) {
            if (!error) {
                [SwiftAdapter showProgressSucceed];
                if (self.addListDelegate) {
                    [self.addListDelegate onListAdded:object];
                }
            }
            else {
                // TODO: Prompt user to check connection and try again
                [SwiftAdapter showProgressFailed];
            }
        }];
    }
    else {
        [PFCloud callFunctionInBackground:@"joinList" withParameters:@{@"code": self.txtMain.text} block:^(id  _Nullable object, NSError * _Nullable error) {
            if (!error) {
                [SwiftAdapter showProgressSucceed];
                if (self.addListDelegate) {
                    [self.addListDelegate onListJoined:object];
                }
            }
            else {
                // TODO: Prompt user to check connection and try again
                [SwiftAdapter showProgressFailed];
            }
        }];
    }
}
@end
