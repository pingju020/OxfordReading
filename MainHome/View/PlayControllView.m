//
//  PlayControllView.m
//  OxfordReading
//
//  Created by yangjuanping on 2018/12/9.
//  Copyright © 2018 yangjuanping. All rights reserved.
//

#import "PlayControllView.h"

@implementation PlayControllView

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        //获取用xib自定义的view
        UIView *containerView = [[NSBundle mainBundle] loadNibNamed:@"PlayControllView" owner:self options:nil].lastObject;
        [self addSubview:containerView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)playAction:(id)sender {
}
- (IBAction)preAction:(id)sender {
}
- (IBAction)nextAction:(id)sender {
}
- (IBAction)listAction:(id)sender {
}
- (IBAction)favoriteAction:(id)sender {
}

@end
