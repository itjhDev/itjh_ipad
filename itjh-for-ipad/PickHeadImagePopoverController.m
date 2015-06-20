//
//  PickHeadImagePopoverController.m
//  itjh-for-ipad
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#import "PickHeadImagePopoverController.h"
@interface PickHeadImagePopoverController()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;



@end
@implementation PickHeadImagePopoverController
-(void)viewDidLoad{
  
    [super viewDidLoad];
    //默认提供八张图片
    [_imageViews enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
        obj.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDefaultImage:)];
        [obj addGestureRecognizer:tapGestureRecognizer];
    }];
    
}
-(void)chooseDefaultImage:(UIGestureRecognizer*)tapGestureRecognizer{
    _headImageView.image = ((UIImageView*)tapGestureRecognizer.view).image;
}
- (IBAction)chooseThisImage:(id)sender {
    [self.delegate pickHeadImage:_headImageView.image];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}



@end
