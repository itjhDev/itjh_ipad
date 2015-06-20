//
//  NewsManager.m
//  itjh-for-ipad
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#import "NewsManager.h"
#import "AFNetworking.h"
#import "Constants.h"

@interface  NewsManager()
{
    AFHTTPRequestOperationManager *httpRequestOperationManager;
}

@end

@implementation NewsManager
+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance=[[self alloc]init];
        [sharedInstance setupManager];
    });
    return sharedInstance;
}

-(void)setupManager
{
     httpRequestOperationManager = [AFHTTPRequestOperationManager manager];
}
-(void)getNewsList:(NewsCategory)category
            offset:(NSInteger)offset
              size:(NSInteger)size
       success:(SuccessNewsCompletionHandler)successGetContentCompletionHandler
           failure:(FailToGetContentCompletionHandler)failToGetContentCompletionHandler
{
    NSString *strURL;
    //根据分类获得要发送请求的url
    switch (category) {
        case Base:
            strURL=[NSString stringWithFormat:@"%@%ld/%ld",GET_BASE_URL,(long)offset,(long)size];
            break;
            case PoineeringWork:
            case Technology:
            case Internet:
            case InterestingNews:
            case Unkown1:
            case Unkown2:
            case Unkown3:
            strURL=[NSString stringWithFormat:@"%@%ld/%ld/%ld",
                            GET_ARTICLE_CATEGORY,(long)category,(long)offset,(long)size];
            break;
            break;
            default:
            break;
    }
    [httpRequestOperationManager GET:strURL parameters:nil
                                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     
        successGetContentCompletionHandler((NSDictionary*)responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code == -1009) {
            failToGetContentCompletionHandler(@"无网络，请检查网络连接");
        }
      else
      {
            failToGetContentCompletionHandler(error.localizedDescription);
      }
    }];
    
}
- (void )getHTMLString:(NSString*)articleID
                       success:(SuccessGetContentCompletionHandler)successGetContentCompletionHandler
                          failure:(FailToGetContentCompletionHandler)failToGetContentCompletionHandler
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",GET_ARTICLE_BY_ID,articleID];
    
    [httpRequestOperationManager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //合成HTML，新闻的本体
        NSDictionary * dic = (NSDictionary*)responseObject;
        NSString * atitle = dic[@"content"][@"title"];
        NSString * postDate = dic[@"content"][@"date"];
        NSString * postTime = [postDate substringWithRange:NSMakeRange(0, 11)];
        NSString * content = dic[@"content"][@"content"];
        NSString * author = dic[@"content"][@"author"];
        NSString * topHtml = [NSString stringWithFormat:@"<html lang='zh-CN'><head><meta charset='utf-8'><meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'><title>%@</title><meta name='apple-itunes-app' content='app-id=639087967, app-argument=zhihudaily://story/4074215'><meta name='viewport' content='width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1'><link rel='stylesheet' href='http://203.195.152.45:8080/itjh/resource/zhihu.css'><script src='http://203.195.152.45:8080/itjh/resource/jquery.1.9.1.js'></script><style>.main-wrap {max-width: 1000px;min-width: 300px;margin: 0 auto;}</style><base target='_blank'></head><body> <div class='main-wrap content-wrap'> <div class='content-inner'> <div class='question'> <h2 class='question-title' >%@</h2> <div class='answer'> <div class='meta' style='padding-bottom:10px;border-bottom:1px solid #e7e7eb '> <span class='bio'>%@</span> &nbsp; <span class='bio'>%@</span> </div> <div class='content'>",atitle,atitle,postTime,author];        NSString *footHtml = @" </div> </div> </div>           </boby></script> </body> <script>$('img').attr('style', '');$('img').attr('width', '');$('img').attr('height', '');$('img').attr('class', '');$('img').attr('title', '');$('p').attr('style', '');</script></html>";
       NSString *result =[NSString stringWithFormat:@"%@%@%@",topHtml,content,footHtml];
        
        successGetContentCompletionHandler(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code == -1009) {
            failToGetContentCompletionHandler(@"无网络，请检查网络连接");
        }
        else
        {
            failToGetContentCompletionHandler(error.localizedDescription);
        }

    }];
    
}
@end
