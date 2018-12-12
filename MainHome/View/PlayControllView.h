//
//  PlayControllView.h
//  OxfordReading
//
//  Created by yangjuanping on 2018/12/9.
//  Copyright © 2018 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayControllView : UIView
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *listBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoritBtn;

@end

NS_ASSUME_NONNULL_END
