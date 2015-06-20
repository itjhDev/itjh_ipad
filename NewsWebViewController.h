//
//  NewsWebViewController.h
//  itjh-for-ipad
//
//  Created by apple on 15/6/7.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsWebViewController : UIViewController

@property(strong,nonatomic) NSString * articleID;
@property(strong,nonatomic)NSString *article;
@property(strong,nonatomic) NSString * postTime ;
@property(strong,nonatomic) NSString * content ;
@property(strong,nonatomic) NSString * author ;
@property(strong,nonatomic) NSString * imageURLString ;
@end
