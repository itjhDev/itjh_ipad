//
//  ViewController.m
//  itjh-for-ipad
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#import "ViewController.h"
#import "NewsCollectionViewCell.h"
#import "NewsManager.h"
#import "Constants.h"
#import "NewsWebViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "YCXMenu.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SDImageCache.h"
#import "Chameleon.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>
{
    
    IBOutlet UICollectionView *newsCollectionView;
    //用于储存当前新闻的数组，指向当前选择的分类的新闻
    NSMutableArray *  _news;
    
    NSDictionary *_allNews;
    NSString * _selectedArticleID;
    NewsCategory _selectedCategory;
     NSString * _selectedArticle;
    NSString *_selectedPostTime;
    NSString * _selectedContent;
    NSString *_selectedauthor;
    NSString *_selectedImageURLString;
    NewsManager *manager;
    NSInteger newsPage;
    IBOutlet UIImageView *headImage;
    IBOutlet UILabel *nameLabel;
    UIView *arrowView ;
}
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initializeDataSource];
    
    //下拉加载更多新闻
    newsCollectionView.footer = [MJRefreshAutoNormalFooter
                                                                footerWithRefreshingTarget:self
                                                                refreshingAction:@selector(refresh)];
  
    //让选中的分类底部有一条横线，指着当前分类
    arrowView = [[UIView alloc]initWithFrame:CGRectMake(0, 269, 36, 5)];
    arrowView.center = CGPointMake(66,549);
    arrowView.backgroundColor = [UIColor redColor];
    arrowView.layer.masksToBounds = YES;
    arrowView.layer.cornerRadius =5.0;
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius =5.0;

    [self.view addSubview:arrowView];
   
  }

-(void)moveArrowTo:(CGPoint)place{
    [UIView animateWithDuration:0.5 animations:^{
        arrowView .center =place;
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
     [self getCurrentInfo];
}
//获得当前用户的头像和名字

-(void)getCurrentInfo
{
    AVUser *user = [AVUser currentUser];
    if (user) {
        NSData *imageData = [user objectForKey:@"headimage"];
        headImage.image = [UIImage imageWithData:imageData];
        nameLabel.textColor = [UIColor greenColor];
        nameLabel.text = [user objectForKey:@"username"];
    }
    else
    {
        headImage.image = [UIImage imageNamed:@"default_showPic"];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text = @"未登录";
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
 [self.navigationController setNavigationBarHidden:NO animated:YES];  
}
-(void)initializeDataSource
{
    manager=[NewsManager sharedInstance];
    newsCollectionView.alwaysBounceVertical=YES;
    //存放全部的新闻
    _allNews =@{
                         @"创业" : [[NSMutableArray alloc]init],
                         @"科技" : [[NSMutableArray alloc]init],
                         @"互联网" : [[NSMutableArray alloc]init],
                         @"趣闻" : [[NSMutableArray alloc]init],
                         @"首页" : [[NSMutableArray alloc]init]
                         };
    //默认首页
    
    _selectedCategory = Base;
    _news = _allNews[@"首页"];
    [manager getNewsList:_selectedCategory
                               offset:0
                                 size:EVERY_PAGE_COUNT success:^(NSDictionary *newsDic) {
                                     
        [_news addObjectsFromArray:[newsDic objectForKey:@"content"]];
         //页数加一
        newsPage ++; //GET_NEXT_PAGE_OFFSET([_news count], newsPage);
        [newsCollectionView reloadData];
    } failure:^(NSString *errorReason) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"获取新闻失败"
                                                                                  message:errorReason
                                                                                   delegate:nil
                                                                      cancelButtonTitle:@"好的"
                                                                      otherButtonTitles:nil];
        [alertView show];
    }];
    
  
}

-(void)refresh{
    
    [manager getNewsList:_selectedCategory
                               offset:newsPage
                                 size:EVERY_PAGE_COUNT
                          success:^(NSDictionary *newsDic) {
                              if ([[newsDic objectForKey:@"content"] count]==0) {
                                  MBProgressHUD * progressHUD =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                  progressHUD.labelText = @"加载完了";
                                  progressHUD.mode=MBProgressHUDModeText;
                                  [progressHUD hide:YES afterDelay:1.0];
                                  [newsCollectionView.footer endRefreshing];
                                    }
                            else{
                                [_news addObjectsFromArray:[newsDic objectForKey:@"content"]];
                                newsPage++;//=GET_NEXT_PAGE_OFFSET([_news count], newsPage);
                                [newsCollectionView reloadData];
                                [newsCollectionView.footer endRefreshing];
                                }

    }
                           failure:^(NSString *errorReason) {
                                    [newsCollectionView.footer endRefreshing];
                                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"获取新闻失败"
                                                                                                              message:errorReason
                                                                                                               delegate:nil
                                                                                                 cancelButtonTitle:@"好的"
                                                                                                  otherButtonTitles:nil];
          [alertView show];
         [newsCollectionView.footer endRefreshing];
    }];
  
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView
            numberOfItemsInSection:(NSInteger)section
{
    return [_news count];
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView
                        cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsCollectionViewCell * cell = [newsCollectionView dequeueReusableCellWithReuseIdentifier:@"news" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.newsPhoto sd_setImageWithURL:_news[indexPath.row][@"img"] placeholderImage:[UIImage imageNamed:@"default_showPic"]];
    cell.articleName.text = [_news[indexPath.row] objectForKey:@"title"];
    cell.author.text =  [_news[indexPath.row] objectForKey:@"author"];
    cell.postTime.text = [[_news[indexPath.row] objectForKey:@"date"] substringWithRange:(NSMakeRange(0, 11))];
    return cell;
}
-(void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *number = [_news[indexPath.row] objectForKey:@"aid"];
    _selectedArticleID    = [NSString stringWithFormat:@"%@",number];
    _selectedArticle         = [_news[indexPath.row] objectForKey:@"title"];
    _selectedauthor =[_news[indexPath.row] objectForKey:@"author"];
    _selectedPostTime = [[_news[indexPath.row] objectForKey:@"date"] substringWithRange:(NSMakeRange(0, 11))];
    _selectedImageURLString = _news[indexPath.row][@"img"] ;
    [self performSegueWithIdentifier:@"news_segue" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"news_segue"]) {
        NewsWebViewController * vc = segue.destinationViewController ;
        vc.articleID = _selectedArticleID;
        vc.article = _selectedArticle;
        vc.postTime =_selectedPostTime;
        vc.author = _selectedauthor;
        vc.imageURLString = _selectedImageURLString;
    }
}
- (IBAction)selectNewsCategory:(UIButton *)sender {
    NSString *category = sender.titleLabel.text;
    CGPoint end= CGPointMake(66, sender.frame.origin.y+sender.frame.size.height+5);
      [self moveArrowTo:end];
           if ([category isEqualToString:@"创业"]) {
            _selectedCategory = PoineeringWork;
            _news = _allNews[@"创业"];
            newsCollectionView.backgroundColor = FlatRedDark;
        }
        else if ([category isEqualToString:@"科技"]) {
            _selectedCategory = Technology;
            _news = _allNews[@"科技"];
            newsCollectionView.backgroundColor =FlatSkyBlueDark ;
        }
        else if ([category isEqualToString:@"互联网"]) {
            _selectedCategory = Internet;
            _news = _allNews[@"互联网"];
            newsCollectionView.backgroundColor =FlatLimeDark ;
        }
        else if ([category isEqualToString:@"趣闻"]) {
            _selectedCategory = InterestingNews;
            _news = _allNews[@"趣闻"];
            newsCollectionView.backgroundColor =FlatGreenDark ;
        }
        else if ([category isEqualToString:@"首页"]) {
            _selectedCategory = Base;
            _news = _allNews[@"首页"];
            newsCollectionView.backgroundColor =FlatSandDark ;
        }
        
        //newsPage = [_news count];
        newsPage = (int)([_news count]/EVERY_PAGE_COUNT);
        if ([_news count]==0) {
            [self refresh];
        }
        
        [newsCollectionView reloadData];
       
   
   
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    float   toLeft = (CGRectGetWidth(newsCollectionView.bounds)-392*2-30)/2;
    return UIEdgeInsetsMake(10, toLeft, 10,toLeft);
}
- (IBAction)settingConfigure:(UIButton*)sender {
    __block AVUser *currentUser = [AVUser currentUser];
    YCXMenuItem *logMenu;
    
    if (currentUser) {
        logMenu = [YCXMenuItem menuItem:@"注销" image:nil tag:99 userInfo:@{ @"title" : @"Menu" }];
        logMenu.foreColor = [UIColor redColor];
    }
       else
       {
         logMenu = [YCXMenuItem menuItem:@"登录" image:nil tag:99 userInfo:@{ @"title" : @"Menu" }];
             logMenu.foreColor = [UIColor greenColor];
       }
    
   NSArray *iterms = @[
                        logMenu,
                        [YCXMenuItem menuItem:@"清除缓存" image:nil tag:101 userInfo:@{ @"title" : @"Menu" }],
                    //    [YCXMenuItem menuItem:@"关于我们" image:nil tag:102 userInfo:@{@"title":@"Menu"}],
                        ];
  CGRect menuRect= CGRectMake(sender.frame.origin.x, sender.frame.origin.y+5, sender.frame.size.width, sender.frame.size.height);
    [YCXMenu showMenuInView:self.navigationController.view
                                    fromRect:menuRect
                                menuItems:iterms
                                    selected:^(NSInteger index, YCXMenuItem *item) {
        if (index==0) {
            if (currentUser)
            {
                [AVUser logOut];
                [self getCurrentInfo];
            }
            else
            {
                [self performSegueWithIdentifier:@"login_segue" sender:self];
            }
        }
        else if(index ==1){
          NSString *message = [NSString stringWithFormat:@"已用缓存%uKB,真的要清除缓存么？",[[SDImageCache sharedImageCache] getSize]/1024];
            UIAlertView *alertVew = [[UIAlertView alloc]initWithTitle:@"清楚缓存"
                                                                                     message:message
                                                                                      delegate:self
                                                                        cancelButtonTitle:@"取消"
                                                                         otherButtonTitles:@"确认", nil];
            [alertVew show];
        }
    } ];
}

- (IBAction)showCollection:(id)sender {
   if ([AVUser currentUser]) {
          [self performSegueWithIdentifier:@"collection_segue" sender:self];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"获取收藏失败"
                                                                                  message:@"请先登录"
                                                                                   delegate:nil
                                                                      cancelButtonTitle:@"好的"
                                                                       otherButtonTitles:nil];
        [alertView show];
    }
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1)
    {
        //清除缓存
        [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
            UIAlertView *alertVew = [[UIAlertView alloc]initWithTitle:@"完成"
                                                                                     message:@"已清除缓存"
                                                                                      delegate:nil
                                                                         cancelButtonTitle:@"好的 "
                                                                          otherButtonTitles: nil];
            [alertVew show];
        }];
    }
}
@end
