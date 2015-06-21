//
//  CollectionViewController.m
//  itjh-for-ipad
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#import "CollectionViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "NewsCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "NewsWebViewController.h"
@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *collections;
@property (strong,nonatomic)NSString *   selectedArticleID;
@property (strong,nonatomic)NSString *   selectedArticle;
@property (strong,nonatomic)NSString *   selectedPostTime;
@property (strong,nonatomic)NSString *   selectedauthor;
@property (strong,nonatomic)NSString *   selectedImageURLString;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _collections = [NSMutableArray array];
}
- (void)viewWillAppear:(BOOL)animated{
    
     self.navigationItem.title = @"我的收藏";
    [super viewWillAppear:animated];
    [_collections removeAllObjects];
     [self initializeDataSource];
}
-(void)initializeDataSource{
    AVUser *currentUser = [AVUser currentUser];
    __weak UICollectionView *collectionViews = _collectionView;
    //获得收藏列表
    
    if (currentUser) {
        NSArray * article_ids=   [currentUser objectForKey:@"article_ids"];
        AVQuery *querty = [AVQuery queryWithClassName:@"article"];
        if ([article_ids count]==0) {
            UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"你还没有收藏文章呢"
                                                                                        message:@"你还没有收藏文章呢"
                                                                                        delegate:nil
                                                                           cancelButtonTitle:@"好的"
                                                                           otherButtonTitles: nil];
            [alertView show];
            return;
        }
        [querty whereKey:@"article_id" containedIn:article_ids];
        
        [querty findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if ([objects count]!=0) {
                for (AVObject *object in objects) {
                    NSDictionary *dic=@{@"article_posttime":[object objectForKey:@"article_posttime"],
                                        @"article_name":[object objectForKey:@"article_name"],
                   @"article_id": [object objectForKey:@"article_id"],
                   @"article_name": [object objectForKey:@"article_name"],
                                        @"article_image_url" :[object objectForKey:@"article_image_url"],
                                        @"article_author" :[object objectForKey:@"article_author"]
                                        };
                    [_collections addObject:dic];
                }
                [collectionViews reloadData];
            }
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return [_collections count];
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView
                       cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection_news" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.newsPhoto sd_setImageWithURL:_collections[indexPath.row][@"article_image_url"] placeholderImage:[UIImage imageNamed:@"default_showPic"]];
    cell.articleName.text = [_collections[indexPath.row] objectForKey:@"article_name"];
    cell.author.text =  [_collections[indexPath.row] objectForKey:@"article_author"];
    cell.postTime.text = [_collections[indexPath.row] objectForKey:@"article_posttime"] ;
    return cell;
}
-(void)collectionView:(UICollectionView*)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *number = [_collections[indexPath.row] objectForKey:@"article_id"];
    _selectedArticleID    = [NSString stringWithFormat:@"%@",number];
    _selectedArticle         = [_collections[indexPath.row] objectForKey:@"article_name"];
    _selectedauthor =[_collections[indexPath.row] objectForKey:@"article_author"];
    _selectedPostTime = [_collections[indexPath.row] objectForKey:@"article_posttime"];
    _selectedImageURLString = _collections[indexPath.row][@"article_image_url"] ;
    [self performSegueWithIdentifier:@"collection_news_segue" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"collection_news_segue"]) {
        NewsWebViewController * vc = segue.destinationViewController ;
        vc.articleID = _selectedArticleID;
        vc.article = _selectedArticle;
        vc.postTime =_selectedPostTime;
        vc.author = _selectedauthor;
        vc.imageURLString = _selectedImageURLString;
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    float   toLeft = (CGRectGetWidth(collectionView.bounds)-392*2-30)/2;
    return UIEdgeInsetsMake(10, toLeft, 10,toLeft);
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
