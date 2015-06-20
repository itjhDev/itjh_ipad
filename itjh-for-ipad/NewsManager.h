//
//  NewsManager.h
//  itjh-for-ipad
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsManager : NSObject
//新闻分类
typedef NS_ENUM(NSInteger, NewsCategory)
{
    Base = 0,
    PoineeringWork,
    Technology,
    Internet,
    InterestingNews,
    Unkown1,
    Unkown2,
    Unkown3,
    Unkown4,
};
typedef void (^SuccessGetContentCompletionHandler)(NSString *HtmlString);
typedef void (^FailToGetContentCompletionHandler)(NSString *errorReason);
typedef void (^SuccessNewsCompletionHandler)(NSDictionary *newsDic);

+  (instancetype)sharedInstance;
//根据分类，页码，每页新闻数目获取新闻
- (void)getNewsList:(NewsCategory)category
                      offset:(NSInteger)offset
                        size:(NSInteger)size
                 success:(SuccessNewsCompletionHandler)successGetContentCompletionHandler
                    failure:(FailToGetContentCompletionHandler)failToGetContentCompletionHandler;
//根据新闻的ID获得新闻的html内容，之后给uiwebview渲染出来
- (void )getHTMLString:(NSString*)articleID
                       success:(SuccessGetContentCompletionHandler)successGetContentCompletionHandler
                          failure:(FailToGetContentCompletionHandler)failToGetContentCompletionHandler;
@end
