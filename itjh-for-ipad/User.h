//
//  User.h
//  itjh-for-ipad
//
//  Created by apple on 15/6/17.
//  Copyright (c) 2015年 2012110401. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+(void)signUpWithName:(NSString*)name password:(NSString*)password headImage:(NSString*)headimage;
+(void)logOut;
+(void)collectArticleID:(NSString*)articleID title:(NSString*)title postTime:(NSString*)time author:(NSString*)author imageURL:(NSString*)imageURL;
+(void)uncollectedArtcleID:(NSString*)articleID;
+(void)getCollectionList;
+(BOOL)isLogin;

@end
