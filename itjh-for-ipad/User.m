//
//  User.m
//  itjh-for-ipad
//
//  Created by apple on 15/6/17.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#import "User.h"
#import "AVUser.h"
@implementation User
+(void)loginWithName:(NSString*)name password:(NSString*)password headImage:(NSString*)headimage
{
    [AVUser logInWithUsernameInBackground:name password:password block:^(AVUser *user, NSError *error) {
        if (!user) {
            
        }
        else
        {
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
 }
+(void)signUpWithName:(NSString*)name password:(NSString*)password headImage:(NSString*)headimage
{
    AVUser *user =  [AVUser user];
    user.username = name;
    user.password = password;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"%@",error.localizedDescription);
        }
    }];

}
+(void)logOut
{
    
}
+(void)collectArticleID:(NSString*)articleID title:(NSString*)title postTime:(NSString*)time author:(NSString*)author imageURL:(NSString*)imageURL
{
    
}
+(void)uncollectedArtcleID:(NSString*)articleID
{
    
}
+(void)getCollectionList
{
    
}
+(BOOL)isLogin
{
    if ([AVUser currentUser]==nil) {
        return NO;
    }
    else{
        return YES;
    }
}
@end
