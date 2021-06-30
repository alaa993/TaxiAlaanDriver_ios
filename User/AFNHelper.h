//
//  AFNHelper.h
//  Truck
//
//  Created by veena on 1/12/17.
//  Copyright © 2017 appoets. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoadingViewClass.h"
#import "AppDelegate.h"

@class LoadingViewClass;
@class AppDelegate;

#define POST_METHOD @"POST"
#define GET_METHOD  @"GET"
#define DELETE_METHOD @"DELETE"
#define PATCH_METHOD @"PATCH"

typedef void (^RequestCompletionBlock)(id response, NSDictionary *error, NSString *errorcode);

@interface AFNHelper : NSObject
{
//blocks
    RequestCompletionBlock dataBlock;
    LoadingViewClass *loading;
    AppDelegate *appDelegate;
}

@property(nonatomic,copy)NSString *strReqMethod;

-(id)initWithRequestMethod:(NSString *)method;

-(void)getDataFromPath:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block;

-(void)getDataFromPath:(NSString *)path withParamDataImage:(NSDictionary *)dictParam andImage:(UIImage *)image withBlock:(RequestCompletionBlock)block;

-(void)getDataFromPath_NoLoader:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block;
@end
