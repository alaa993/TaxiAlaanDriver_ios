//
//  AFNHelper.m
//  Truck
//
//  Created by veena on 1/12/17.
//  Copyright © 2017 appoets. All rights reserved.
//
//

#import "AFNHelper.h"
#import "AFNetworking.h"
#import "config.h"
#import "Utilities.h"

@implementation AFNHelper

@synthesize strReqMethod;

#pragma mark -
#pragma mark - Init

-(id)initWithRequestMethod:(NSString *)method
{
    if ((self = [super init])) {
        self.strReqMethod=method;
    }
    return self;
}

#pragma mark -
#pragma mark - Methods
-(void)getDataFromPath:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block
{
    [self start];
    if (block) {
        dataBlock=[block copy];
    }
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [Utilities removeNullFromString:[defaults valueForKey:@"access_token"]];
    NSString *deviceId  = [Utilities removeNullFromString:[defaults valueForKey:@"deviceId"]];
    
    if (![access_token isEqualToString:@""])
    {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", access_token] forHTTPHeaderField:@"Authorization"];
    }
    
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",deviceId] forHTTPHeaderField:@"deviceId"];

    
    manager.requestSerializer.timeoutInterval=600;
    
    NSString *strURL=[NSString stringWithFormat:@"%@%@",SERVICE_URL,path];
    
    if ([self.strReqMethod isEqualToString:POST_METHOD])
    {
        [manager POST:strURL parameters:dictParam progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             [self stop];
             if(dataBlock){
                 
                 if(responseObject==nil)
                     dataBlock(task.response,nil,nil);
                 else
                     dataBlock(responseObject,nil,nil);
             }
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"Error %@",error);
                  [self stop];
                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                  NSLog(@"status code: %li", (long)httpResponse.statusCode);
                  
                  NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                  if (errorData == nil)
                  {
                      
                  }
                  else
                  {
                      
                      NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                      
                      if (httpResponse.statusCode==400||httpResponse.statusCode==405||httpResponse.statusCode==500 )
                      {
                          dataBlock(nil,nil,@"1");
                      }
                      else if(httpResponse.statusCode==401)
                      {
                          dataBlock(nil,serializedData,@"2");
                      }
                      else if(httpResponse.statusCode==422)
                      {
                          dataBlock(nil,serializedData,@"3");
                      }
                  }
              }];
        
    }
    else if ([self.strReqMethod isEqualToString:GET_METHOD])
    {
        [manager GET:strURL parameters:dictParam progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             [self stop];
             if(dataBlock){
                 if(responseObject==nil)
                     dataBlock(task.response,nil,nil);
                 else
                     dataBlock(responseObject,nil,nil);
             }
             
         }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"Error %@",error);
                 [self stop];
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                 NSLog(@"status code: %li", (long)httpResponse.statusCode);
                 
                 NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                 if (errorData == nil)
                 {
                     
                 }
                 else
                 {
                     
                     NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                     
                     if (httpResponse.statusCode==400||httpResponse.statusCode==405||httpResponse.statusCode==500 )
                     {
                         dataBlock(nil,nil,@"1");
                     }
                     else if(httpResponse.statusCode==401)
                     {
                         dataBlock(nil,serializedData,@"2");
                     }
                     else if(httpResponse.statusCode==422)
                     {
                         dataBlock(nil,serializedData,@"3");
                     }
                 }
                 
             }];
    }
    else if ([self.strReqMethod isEqualToString:DELETE_METHOD])
    {
        [manager DELETE:path parameters:dictParam
         
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             [self stop];
             if(dataBlock){
                 if(responseObject==nil)
                     dataBlock(task.response,nil,nil);
                 else
                     dataBlock(responseObject,nil,nil);
             }
             
         }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error %@",error);
                    [self stop];
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                    NSLog(@"status code: %li", (long)httpResponse.statusCode);
                    
                    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                    
                    if (errorData == nil)
                    {
                        
                    }
                    else
                    {
                        
                        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                        
                        if (httpResponse.statusCode==400||httpResponse.statusCode==405||httpResponse.statusCode==500 )
                        {
                            dataBlock(nil,nil,@"1");
                        }
                        else if(httpResponse.statusCode==401)
                        {
                            dataBlock(nil,serializedData,@"2");
                        }
                        else if(httpResponse.statusCode==422)
                        {
                            dataBlock(nil,serializedData,@"3");
                        }
                    }
                    
                }];
    }
    else if ([self.strReqMethod isEqualToString:PATCH_METHOD])
    {
        [manager PATCH:path parameters:dictParam
         
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             [self stop];
             if(dataBlock){
                 if(responseObject==nil)
                     dataBlock(task.response,nil,nil);
                 else
                     dataBlock(responseObject,nil,nil);
             }
             
         }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   NSLog(@"Error %@",error);
                   [self stop];
                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                   NSLog(@"status code: %li", (long)httpResponse.statusCode);
                   
                   NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                   
                   if (errorData == nil)
                   {
                       
                   }
                   else
                   {
                       
                       NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                       
                       if (httpResponse.statusCode==400||httpResponse.statusCode==405||httpResponse.statusCode==500 )
                       {
                           dataBlock(nil,nil,@"1");
                       }
                       else if(httpResponse.statusCode==401)
                       {
                           dataBlock(nil,serializedData,@"2");
                       }
                       else if(httpResponse.statusCode==422)
                       {
                           dataBlock(nil,serializedData,@"3");
                       }
                   }
                   
               }];
    }
}

-(void)getDataFromPath:(NSString *)path withParamDataImage:(NSDictionary *)dictParam andImage:(UIImage *)image withBlock:(RequestCompletionBlock)block{
    
    [self start];
    
    if (block) {
        dataBlock=[block copy];
    }
    NSData *imageToUpload = UIImageJPEGRepresentation(image, 0.5);
    if (imageToUpload)
    {
        NSString *url=[NSString stringWithFormat:@"%@%@",SERVICE_URL,path];
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *access_token = [Utilities removeNullFromString:[defaults valueForKey:@"access_token"]];
        NSString *deviceId  = [Utilities removeNullFromString:[defaults valueForKey:@"deviceId"]];
        
        if (![access_token isEqualToString:@""])
        {
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", access_token] forHTTPHeaderField:@"Authorization"];
        }

        [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",deviceId] forHTTPHeaderField:@"deviceId"];

        
        manager.requestSerializer.timeoutInterval=600;
        
        [manager POST:url parameters:dictParam constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imageToUpload name:@"avatar" fileName:@"user.jpg" mimeType:@"file"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self stop];
            if(dataBlock){
                if(responseObject==nil)
                    dataBlock(task.response,nil,nil);
                else
                    dataBlock(responseObject,nil,nil);
            }
        }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  [self stop];
                  NSLog(@"Error %@",error);
                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                  NSLog(@"status code: %li", (long)httpResponse.statusCode);
                  
                  NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                  if (errorData == nil)
                  {
                      
                  }
                  else
                  {
                      NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                      
                      if (httpResponse.statusCode==400||httpResponse.statusCode==405||httpResponse.statusCode==500 )
                      {
                          dataBlock(nil,nil,@"1");
                      }
                      else if(httpResponse.statusCode==401)
                      {
                          dataBlock(nil,serializedData,@"2");
                      }
                      else if(httpResponse.statusCode==422)
                      {
                          dataBlock(nil,serializedData,@"3");
                      }}
                  
              }];
    }
    
}

-(void)getDataFromPath_NoLoader:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block
{
    if (block) {
        dataBlock=[block copy];
    }
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [Utilities removeNullFromString:[defaults valueForKey:@"access_token"]];
    
   NSString *deviceId  = [Utilities removeNullFromString:[defaults valueForKey:@"deviceId"]];
    
    if (![access_token isEqualToString:@""])
    {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", access_token] forHTTPHeaderField:@"Authorization"];
    }
    
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",deviceId] forHTTPHeaderField:@"deviceId"];
    
    manager.requestSerializer.timeoutInterval=600;
    
    NSString *strURL=[NSString stringWithFormat:@"%@%@",SERVICE_URL,path];
    
    if ([self.strReqMethod isEqualToString:POST_METHOD])
    {
        [manager POST:strURL parameters:dictParam progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             if(dataBlock){
                 
                 if(responseObject==nil)
                     dataBlock(task.response,nil,nil);
                 else
                     dataBlock(responseObject,nil,nil);
             }
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"Error %@",error);
                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                  NSLog(@"status code: %li", (long)httpResponse.statusCode);
                  
                  NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                  
                  if ( errorData ==nil)
                  {
                      
                  }
                  else{
                      NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                      
                      if (httpResponse.statusCode==400||httpResponse.statusCode==405||httpResponse.statusCode==500 )
                      {
                          dataBlock(nil,nil,@"1");
                      }
                      else if(httpResponse.statusCode==401)
                      {
                          
                          dataBlock(nil,serializedData,@"2");
                      }
                      else if(httpResponse.statusCode==422)
                      {
                          dataBlock(nil,serializedData,@"3");
                      }
                  }
            }];
    }
    else
    {
        [manager GET:strURL parameters:dictParam progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             if(dataBlock){
                 if(responseObject==nil)
                 dataBlock(task.response,nil,nil);
                 else
                 dataBlock(responseObject,nil,nil);
             }
         }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"Error %@",error);
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                 NSLog(@"status code: %li", (long)httpResponse.statusCode);
                 
                 NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                 if (errorData == nil)
                 {
                     
                 }
                 else
                 {
                     NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
                     
                     if (httpResponse.statusCode==400||httpResponse.statusCode==405||httpResponse.statusCode==500 )
                     {
                         dataBlock(nil,nil,@"1");
                     }
                     else if(httpResponse.statusCode==401)
                     {
                         dataBlock(nil,serializedData,@"2");
                     }
                     else if(httpResponse.statusCode==422)
                     {
                         dataBlock(nil,serializedData,@"3");
                     }
                 }
                 
                 
                 
             }];
    }
}

-(void)start
{
    loading = [LoadingViewClass new];
    [loading startLoading];
}

-(void)stop
{
    [loading stopLoading];
}

@end
