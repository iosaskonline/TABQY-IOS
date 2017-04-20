//
//  ECSServiceClass.m
//  ChicagoSoulApp
//
//  Created by Shreesh Garg on 03/03/13.
//  Copyright (c) 2013 eComStreet. All rights reserved.
//

#import "ECSServiceClass.h"

// Class definition for Image object

@interface ImageObject : NSObject
@property (nonatomic, retain) NSString * imageKey;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSData *imageData;
-(id)initWithName:(NSString *)name key:(NSString *)key data:(NSData *)data;

@end


@implementation ImageObject

-(id)initWithName:(NSString *)name key:(NSString *)key data:(NSData *)data
{
    self.imageData = data;
    self.imageKey = key;
    self.imageName = name;
    return self;
}

@end




// Clsss definition for respose
@interface ECSResponse ()
@end

// Implementation of ECSResponse
@implementation ECSResponse

@synthesize data;
@synthesize error;
@synthesize statusCode;
@synthesize stringValue;

@end


@interface ECSServiceClass ()

@property (nonatomic, retain) NSMutableDictionary *paramDictionary;
@property (nonatomic, retain) NSMutableDictionary *extraDictionary;
@property (nonatomic, retain) NSMutableDictionary *headerDictionary;
@property (nonatomic, retain) NSMutableArray * arrayImage;
@property (nonatomic, retain) NSDictionary * jsonString;
@property BOOL isJSONInput;
@end

@implementation ECSServiceClass
@synthesize callback;
@synthesize controller;
@synthesize serviceURL;


-(void)dealloc
{
    
    self.paramDictionary = nil;
    self.headerDictionary = nil;
    self.extraDictionary = nil;
    self.arrayImage = nil;

}


-(id)init
{
    self.isJSONInput = NO;
    self.paramDictionary = [[NSMutableDictionary alloc]init];
    self.headerDictionary = [[NSMutableDictionary alloc]init];
    self.extraDictionary = [[NSMutableDictionary alloc]init];
    self.arrayImage = [[NSMutableArray alloc]init];
    return self;
}
-(void)addJson:(NSDictionary *)stringData
{
    self.isJSONInput = YES;
    self.jsonString = stringData;
    
   
}


-(void)addExtraParam:(NSString *)value forKey:(NSString *)key
{
    if(value == nil) value = @"";
    [self.extraDictionary setObject:value forKey:key];
}

-(void)addParam:(NSString *)value forKey:(NSString *)key
{
    if(value == nil) value = @"";
    [self.paramDictionary setObject:value forKey:key];
    
}

-(void)addHeader:(NSString *)value forKey:(NSString *)key
{
    if(value == nil) return;
    [self.headerDictionary setObject:value forKey:key];
    
}

-(void)addImageData:(NSData *)data withName:(NSString *)name forKey:(NSString *)key
{
    ImageObject * object= [[ImageObject alloc]initWithName:name key:key data:data];
    [self.arrayImage addObject:object];
    
}


-(void)setHeaders:(NSMutableURLRequest *)request
{
    if(self.headerDictionary.allKeys.count > 0)
    {
        NSArray *keyArray   = self.headerDictionary.allKeys;
        for(int i = 0; i < keyArray.count; i++)
        {
            
            [request setValue:[self.headerDictionary valueForKey:[keyArray objectAtIndex:i]] forHTTPHeaderField:[keyArray objectAtIndex:i]];
        }
    }

}

-(NSString *)urlCodedParams
{
    NSString *paramString = @"&";
    if(self.paramDictionary.allKeys.count > 0)
    {
        NSArray *keyArray   = self.paramDictionary.allKeys;
        for(int i = 0; i < keyArray.count; i++)
        {
            NSString *pairString = [NSString stringWithFormat:@"%@=%@&",[keyArray objectAtIndex:i],[self.paramDictionary valueForKey:[keyArray objectAtIndex:i]]];
            paramString = [paramString stringByAppendingString:pairString];
        }
    }
    return paramString;
}


-(void)runService
{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    
    if(self.serviceMethod == GET)
    {
        self.serviceURL = [self.serviceURL stringByAppendingString:@"?"];
        self.serviceURL = [self.serviceURL stringByAppendingString:[self urlCodedParams]];
        [request setHTTPMethod:@"GET"];
    }
    else if(self.serviceMethod == POST)
    {
        [request setHTTPMethod:@"POST"];
        if(self.isJSONInput == YES)
        {
            NSLog(@"dict%@",self.jsonString);
            NSData *postdata = [NSJSONSerialization dataWithJSONObject:self.jsonString options:0 error:nil];
            [request setHTTPBody:postdata];
//            [request setValue:@"application/json" forHTTPHeaderField:CONTENT_TYPE_KEY];//jitendra
//            [request setHTTPBody:[[self urlCodedParams] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            [request setValue:CONTENT_TYPE_VAL forHTTPHeaderField:CONTENT_TYPE_KEY];
            [request setHTTPBody:[[self urlCodedParams] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    else if(self.serviceMethod == PUT)
    {
         [request setValue:CONTENT_TYPE_VAL forHTTPHeaderField:CONTENT_TYPE_KEY];
         [request setHTTPMethod:@"PUT"];
         [request setHTTPBody:[[self urlCodedParams] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if(self.serviceMethod == DELETE)
    {
      [request setHTTPMethod:@"DELETE"];
    }
    else if(self.serviceMethod == IMAGE || self.serviceMethod == IMAGEPUT)
    {
        if(self.serviceMethod == IMAGE)
        [request setHTTPMethod:@"POST"];
        else  [request setHTTPMethod:@"PUT"];
        NSString *stringBoundary =@"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
        [request addValue:contentType forHTTPHeaderField:CONTENT_TYPE_KEY];
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        for(int i = 0; i < self.arrayImage.count; i++)
        {
            ImageObject * imageObject = [self.arrayImage objectAtIndex:i];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",imageObject.imageKey,imageObject.imageName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageObject.imageData];
            if(i!= self.arrayImage.count - 1)
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        for(int i = 0; i < self.paramDictionary.allKeys.count; i++)
        {
            NSString *key = [self.paramDictionary.allKeys objectAtIndex:i];
            NSString *val = [self.paramDictionary objectForKey:key];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",val] dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        [request setHTTPBody:body];
    }
    
    [request setURL:[NSURL URLWithString:[self.serviceURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [self setHeaders:request];
    NSHTTPURLResponse *resp=nil;
    NSError *err = nil;
    NSData *returnData=[NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    NSString *respString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    
    ECSResponse *response = [[ECSResponse alloc]init];
    response.data = returnData;
    response.statusCode= resp.statusCode;
    response.error = err;
    response.urlRequest = request;
    response.stringValue = respString;
    response.extraDictionary = self.extraDictionary;
    if(err || response.statusCode != 200) response.isValid = NO; else response.isValid = YES;
    
    if(response.data == nil)
    {
        response.data = [NSData data];
    }
    
    [self.controller performSelectorOnMainThread:self.callback withObject:response waitUntilDone:YES];
}

//-(void)runPutService
//{
//    
//}
//
//-(void)runDeleteService
//{
//
//
//}




//-(void)setGetService:(NSString *)url
//{
//
//    NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    [req setHTTPMethod:@"GET"];
//    NSHTTPURLResponse *resp=nil;
//    NSError *err = nil;
//    NSData *returnData=[NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&err];
//    NSString *respString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
//    
//    ECSResponse *response = [[ECSResponse alloc]init];
//    response.data = returnData;
//    response.statusCode= resp.statusCode;
//    response.error = err;
//    response.stringValue = respString;
//    if(err || response.statusCode != 200) response.isValid = NO; else response.isValid = YES;
//    
//    if(response.data == nil) return;
//    [self.controller performSelectorOnMainThread:self.callback withObject:response waitUntilDone:YES];
//
//}

//-(void)preparingGetService
//{
//     self.subURL = [self.subURL stringByAppendingString:[self urlCodedParams]];
//}


//-(void)runGetService
//{
//    
//    [self preparingGetService];
//    [self performSelectorInBackground:@selector(setGetService:) withObject:self.subURL];
//    
//}

//-(void)runPostService
//{
//
//    [self setPostServiceWithBody:[self urlCodedParams]];
//}



//-(void)setPostServiceWithBody:(NSString *)string
//{
//
//    NSString *url =  [NSString stringWithFormat:@"%@%@",SERVERURLPATH,self.subURL];
//    NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    [req setHTTPMethod:@"POST"];
//    [req setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
//    NSHTTPURLResponse *resp=nil;
//    NSError *err = nil;
//    NSData *returnData=[NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&err];
//    
//    NSString *respString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
//    
//    ECSResponse *response = [[ECSResponse alloc]init];
//    response.data = returnData;
//    response.statusCode= resp.statusCode;
//    response.error = err;
//    response.stringValue = respString;
//    
//    if(response.statusCode != 200) response.isValid = NO;
//    else response.isValid = YES;
//    
//    if([response data]== nil)
//    {
//        NSLog(@"As data is blank, we can not move forward");
//        return;
//    }
//    
//    [self.controller performSelectorOnMainThread:self.callback withObject:response waitUntilDone:YES];
//}


@end
