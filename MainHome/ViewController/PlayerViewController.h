//
//  PlayerViewController.h
//  OxfordReading
//
//  Created by yangjuanping on 2018/12/10.
//  Copyright © 2018 yangjuanping. All rights reserved.
//

#import "BaseViewController.h"
#import "CYMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayerViewController : BaseViewController
//模型数据数组
@property (nonatomic,strong) NSArray<CYMusicModel *> *modelArray;
@end

NS_ASSUME_NONNULL_END
