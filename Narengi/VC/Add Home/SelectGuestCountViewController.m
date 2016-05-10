//
//  SelectGuestCountViewController.m
//  Narengi
//
//  Created by Morteza Hosseinizade on 5/9/16.
//  Copyright © 2016 Morteza Hosseinizade. All rights reserved.
//

#import "SelectGuestCountViewController.h"
#import "SelectFacilityViewController.h"

@interface SelectGuestCountViewController ()

@property (nonatomic) NSInteger  roomCount;
@property (nonatomic) NSInteger  bedCount;
@property (nonatomic) NSInteger  guestCount;
@property (nonatomic) NSInteger  maxGuestCount;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *roomCountLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *bedCountLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *guestCountLabel;
@property (weak, nonatomic) IBOutlet CustomFaRegularLabel *maxGuestCountLabel;
@end

@implementation SelectGuestCountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self changeLeftIcontoBack];
    [self changeRightButtonToClose];

    
    self.title = @"تعداد‌ها";
    self.maxGuestCount = 1;
    self.guestCount    = 1;
    self.bedCount      = 0;
    self.roomCount     = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - buttons

- (IBAction)roomIncreaseButtonclicked:(UIButton *)sender {
    
    self.roomCount = self.roomCount +1;
    [self updateLabels];
}
- (IBAction)roomDecreaseButtonclicked:(UIButton *)sender {
    
    self.roomCount = self.roomCount-1;
    
    if (self.roomCount < 0) {
        self.roomCount = 0;
    }
    [self updateLabels];
}

- (IBAction)bedIncreaseButtonclicked:(UIButton *)sender {
    
    self.bedCount = self.bedCount+1;
    [self updateLabels];
}
- (IBAction)bedDecreaseButtonclicked:(UIButton *)sender {
    
    self.bedCount = self.bedCount-1;
    
    if (self.bedCount < 0) {
        self.bedCount = 0;
    }
    
    [self updateLabels];
}
- (IBAction)guestIncreaseButtonclicked:(UIButton *)sender {
    
    self.guestCount = self.guestCount +1;
    self.maxGuestCount  = self.guestCount;
    

    [self updateLabels];
}
- (IBAction)guestDecreaseButtonclicked:(UIButton *)sender {
    
    self.guestCount = self.guestCount-1;
    
    if (self.guestCount == 0) {
        self.guestCount = 1;
    }
    self.maxGuestCount  = self.guestCount;
    
    [self updateLabels];
}
- (IBAction)maxGuestIncreaseButtonclicked:(UIButton *)sender {
    
    self.maxGuestCount = self.maxGuestCount +1;
    [self updateLabels];
    
}
- (IBAction)maxGuestDecreaseButtonclicked:(UIButton *)sender {
    
    self.maxGuestCount = self.maxGuestCount -1;
    if (self.maxGuestCount < self.guestCount) {
        self.maxGuestCount  = self.guestCount;
    }
    [self updateLabels];
}

-(void)updateLabels{

    self.guestCountLabel.text    = [NSString stringWithFormat:@"%ld",(long)self.guestCount ];
    self.maxGuestCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.maxGuestCount ];
    self.bedCountLabel.text      = [NSString stringWithFormat:@"%ld",(long)self.bedCount ];
    self.roomCountLabel.text     = [NSString stringWithFormat:@"%ld",(long)self.roomCount ];
    
    self.houseObj.maxGuestCount = self.maxGuestCount;
    self.houseObj.guestCount    = [NSString stringWithFormat:@"%ld",(long)self.guestCount ];
    self.houseObj.bedCount      = [NSString stringWithFormat:@"%ld",(long)self.bedCount ];
    self.houseObj.bedroomCount  = [NSString stringWithFormat:@"%ld",(long)self.roomCount ];
    
}


- (IBAction)nextButtonClicked:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"goToSelectFacility" sender:nil];

}

- (IBAction)preButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    SelectFacilityViewController *vc  = segue.destinationViewController;
    vc.houseObj = self.houseObj;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
