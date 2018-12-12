//
//  MainHomeViewController.m
//  OxfordReading
//
//  Created by yangjuanping on 2018/7/2.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "MainHomeViewController.h"
#import "EnglishBookCell.h"
#import "BookPlayViewController.h"
#import "CYMusicModel.h"
#import "YYModel.h"
#import "PlayerViewController.h"

@interface MainHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSArray* bookList;
@end

@implementation MainHomeViewController

- (void)viewDidLoad {
    self.title = @"琢磨琢磨英语";
    [super viewDidLoad];
    
    [self getPlayList];
    
    [self setLayoutView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"EnglishBookCell" bundle:nil]forCellWithReuseIdentifier:@"EnglishBookCell"];
    // Do any additional setup after loading the view from its nib.
}

-(void)getPlayList{
    
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"mlist.plist" ofType:nil];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:pathStr];
    //字典数组转化为模型数组
    self.bookList = [NSArray yy_modelArrayWithClass:[CYMusicModel class] json:dataArr];
//    AudioBookModel* book1 = [[AudioBookModel alloc]init];
//    book1.title = @"at_school";
//    book1.icon = @"background";
//    book1.url = [[NSBundle mainBundle] pathForResource:@"at_school.mp3" ofType:nil];
//
//    AudioBookModel* book2 = [[AudioBookModel alloc]init];
//    book2.title = @"The Lost Teddy";
//    book2.icon = @"background";
//    book2.url =  [[NSBundle mainBundle] pathForResource:@"The Lost Teddy.mp3" ofType:nil];;
//
//    AudioBookModel* book3 = [[AudioBookModel alloc]init];
//    book3.title = @"The Haircut";
//    book3.icon = @"background";
//    book3.url =  [[NSBundle mainBundle] pathForResource:@"The Haircut.mp3" ofType:nil];;
//
//    AudioBookModel* book4 = [[AudioBookModel alloc]init];
//    book4.title = @"The Library";
//    book4.icon = @"background";
//    book4.url =  [[NSBundle mainBundle] pathForResource:@"The Library.mp3" ofType:nil];
//
//    _bookList = @[book1,book2,book3,book4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLayoutView{

    //设置cell尺寸
    float width = (kScreenWidth-60)/2;
    _flowLayout.itemSize = CGSizeMake(width, width);
    
    //设置行间距
    _flowLayout.minimumLineSpacing = 20;
    //设置cell间距
    //    layout.minimumInteritemSpacing = 10;
    //    layout.sectionInset = UIEdgeInsetsMake(0, 25, 15, 25);
    _flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    //设置滚动方向，垂直滚动
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _bookList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CYMusicModel* model = [_bookList objectAtIndex:indexPath.row];
    static NSString *collectionCellID = @"EnglishBookCell";
    EnglishBookCell *cell = (EnglishBookCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    cell.titleLab.text = model.name;
    cell.iconImage.image = [UIImage imageNamed:model.image];
    
    return cell;

}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerViewController* vc = [PlayerViewController allocController];
    vc.hidesBottomBarWhenPushed = YES;
    CYMusicModel* model = [_bookList objectAtIndex:indexPath.row];
    vc.modelArray = [NSArray arrayWithObjects:model, nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
