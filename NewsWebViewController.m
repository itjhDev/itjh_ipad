//
//  NewsWebViewController.m
//  itjh-for-ipad
//
//  Created by apple on 15/6/7.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#import "NewsWebViewController.h"
#import "NewsManager.h"
#import <AVOSCloud/AVOSCloud.h>
@interface NewsWebViewController (){
    IBOutlet UIWebView *newsWebView;
    IBOutlet UIButton *collectButton;
    IBOutlet UILabel *collectorNumLabel;
    AVUser *currentUser;
    BOOL isCollected ;
}

@end

@implementation NewsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.article;
    currentUser = [AVUser currentUser];
   
    [self getCollectionState];
    [self initializeDataSource];
}
-(void)getCollectionState
{
    AVQuery *query = [AVQuery queryWithClassName:@"article" ];
    [query whereKey:@"article_id" equalTo:_articleID];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        NSString *count = [NSString stringWithFormat:@"%@",[object objectForKey:@"collected_num"]];
        if (![count isEqualToString:@"(null)"]) {
            collectorNumLabel.text = count;
        }
        else{
            collectorNumLabel.text = @"0";
        }
    }];
    
    
   
    NSArray *userCollection = [currentUser objectForKey:@"article_ids"];
     isCollected = NO;
    for (NSString *strid in userCollection) {
        if ([strid isEqualToString:_articleID]) {
            isCollected = YES;
            break;
        }
    }
    if (isCollected)
    {
        collectorNumLabel.textColor = [UIColor blueColor];
        [collectButton setImage:[UIImage imageNamed:@"store_icon_pressed"] forState:UIControlStateNormal];
     
    }
    else
    {
        collectorNumLabel.textColor = [UIColor grayColor];
        [collectButton setImage:[UIImage imageNamed:@"store_icon_default"] forState:UIControlStateNormal];

    }
}
- (IBAction)collectOrNot:(id)sender {
    if (!currentUser)     {
        UIAlertView *alertView =
                [[UIAlertView alloc]initWithTitle:@"获取收藏失败"
                                                  message:@"请先登录"
                                                   delegate:nil
                                     cancelButtonTitle:@"好的"
                                     otherButtonTitles:nil];
        [alertView show];
        return ;
    }
    if (isCollected)
    {
        [self cancelCollect:_articleID];
    }
    else
    {
        [self collect:_articleID title:_article author:_author postTime:_postTime imageURLStr:_imageURLString];
    }
}
#pragma mark --（取消）收藏
-(void)collect:(NSString*)artileID title:(NSString*)title
            author:(NSString*)author
        postTime:(NSString*)postTime
 imageURLStr:(NSString*)imageURLStr{
    
    
    
    AVQuery *query = [AVQuery queryWithClassName:@"article" ];
    [query whereKey:@"article_id" equalTo:artileID];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        //avoscloud里面没有IT江湖的新闻，如果这条信息没被记录，就创建对应新闻，如果已经记录了，收藏数加一
        if (!error) {
            [object setObject:artileID forKey:@"article_id"];
            [object setObject:author forKey:@"article_author"];
            [object setObject:title forKey:@"article_name"];
            [object setObject:postTime forKey:@"article_posttime"];
            [object setObject:imageURLStr forKey:@"article_image_url"];
            [object incrementKey:@"collected_num" ];
            [object saveInBackground];
        }
        else{
            AVObject *article = [AVObject objectWithClassName:@"article"];
            [article setObject:artileID forKey:@"article_id"];
            [article setObject:author forKey:@"article_author"];
            [article setObject:title forKey:@"article_name"];
            [article setObject:postTime forKey:@"article_posttime"];
            [article setObject:imageURLStr forKey:@"article_image_url"];
            [article incrementKey:@"collected_num" ];
            [article saveInBackground];
            NSLog(@"create");
        }
    }];
    //已注册的用户添加要收藏的信息的ID
    [currentUser addUniqueObject:artileID forKey:@"article_ids"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self getCollectionState];
        }
    }];
    
}
-(void)cancelCollect:(NSString*)articleID{
        NSArray *collecters = [currentUser objectForKey:@"article_ids"];
        [collecters enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:articleID]) {
                AVQuery *query = [AVQuery queryWithClassName:@"article" ];
                [query whereKey:@"article_id" equalTo:articleID];
                [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                    if (!error) {
                        [object incrementKey:@"collected_num" byAmount:@(-1)];
                        [object saveInBackground];
                    }
                }];
                
            }
        }];
    [currentUser removeObject:articleID forKey:@"article_ids"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self getCollectionState];
        }
    }];
}
-(void)initializeDataSource{
   [[NewsManager sharedInstance] getHTMLString:self.articleID success:^(NSString *HtmlString) {
         [newsWebView loadHTMLString:HtmlString baseURL:nil];
   } failure:^(NSString *errorReason) {
       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"获取新闻失败"
                                             message:errorReason delegate:nil
                                                                    cancelButtonTitle:@"好的" otherButtonTitles:nil];
       [alertView show];
   }];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
