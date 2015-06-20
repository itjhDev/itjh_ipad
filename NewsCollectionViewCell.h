//
//  NewsCollectionViewCell.h
//  itjh-for-ipad
//
//  Created by apple on 15/6/7.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#import <UIKit/UIKit.h>
//新闻视图的每个cell，展示图片，题目，时间
@interface NewsCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *newsPhoto;
@property (strong, nonatomic) IBOutlet UILabel *articleName;
@property (strong, nonatomic) IBOutlet UILabel *author;
@property (strong, nonatomic) IBOutlet UILabel *postTime;


@end
