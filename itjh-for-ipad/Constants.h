//
//  Constants.h
//  itjh-for-ipad
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#ifndef itjh_for_ipad_Constants_h
#define itjh_for_ipad_Constants_h

//首页
static const NSString *GET_BASE_URL= @"http://m.itjh.com.cn:8080/mitjh/ArticleServer/queryArticleListByNew/";

//获得新闻的分类
static const NSString *GET_ARTICLE_CATEGORY = @"http://m.itjh.com.cn:8080/mitjh/ArticleServer/queryArticleListByCategory/";
//根据新闻编号对应新闻
static const NSString * GET_ARTICLE_BY_ID =@ "http://m.itjh.com.cn:8080/mitjh/ArticleServer/queryArticleById/";
static  NSString *const FETCHINFO_NOTIFICATION = @"FETCHINFO_NOTIFICATION";
static  NSString *const FAILEDINFO_NOTIFICAION = @"FAILEDINFO_NOTIFICAION";
//如果是输入10的话，那么会加载每页会加载11个，所以减一
#define EVERY_PAGE_COUNT (10 - 1)
#endif
