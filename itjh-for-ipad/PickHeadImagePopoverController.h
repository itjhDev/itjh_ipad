//
//  PickHeadImagePopoverController.h
//  itjh-for-ipad
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PickHeadImagePopoverControllerDelegate
-(void)pickHeadImage:(UIImage*)pickHeadImage;
@end

@interface PickHeadImagePopoverController : UIViewController
@property(nonatomic,assign) id<PickHeadImagePopoverControllerDelegate> delegate;
@end
