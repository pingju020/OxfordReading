//
//  BookPlayViewController.m
//  OxfordReading
//
//  Created by yangjuanping on 2018/12/9.
//  Copyright © 2018 yangjuanping. All rights reserved.
//

#import "BookPlayViewController.h"
#import "FXBlurView.h"
#import "PlayControllView.h"


@interface BookPlayViewController ()
@property (weak, nonatomic) IBOutlet FXBlurView *bookIcon;
@property (weak, nonatomic) IBOutlet PlayControllView *playControll;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@end

@implementation BookPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
