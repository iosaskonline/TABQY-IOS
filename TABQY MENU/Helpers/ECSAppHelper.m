//
//  ECSHelper.m
//  TME
//
//  Created by Shreesh Garg on 03/12/13.
//  Copyright (c) 2013 Shreesh Garg. All rights reserved.
//

#import "ECSConfig.h"
#import "ECSAppHelper.h"
#import "UIExtensions.h"
#import <AVFoundation/AVFoundation.h>
#import "UIAppExtensions.h"
#import "AppDelegate.h"
#import "AppUserObject.h"
#import "ECSBaseViewController.h"
//#import "BC_WebPageVC.h"
//#import "AppData.h"
//#import "MMDrawerController.h"



static ECSAppHelper * appHelper;
//static AppData *userData;

@interface ECSAppHelper ()<UIActionSheetDelegate>
{
    
}
@property (strong, retain) UIViewController * controller;

@end

@implementation ECSAppHelper


+(NSString *)getUniqueStreamUrl:(NSString *)userId  stream:(NSString *)streamUrl{
    
    
    return [NSString stringWithFormat:@"%@_%@",userId,streamUrl];
    
    
}

+(NSString *)getUniqueApplogicName:(NSString *)userId andEmail:(NSString *)email
{
    
   
    

    return [NSString stringWithFormat:@"%@_%@_%@",email,APPLOZIC_KEY,@"One"];


    
    
}

//+(NSString *)getUniqueApplogicGroupName:(NSString *)userId andEmail:(NSString *)email
//{
//   // return [NSString stringWithFormat:@"%@_%@",email,APPLOZIC_KEY];
//    
//    
//}

+(instancetype)sharedInstance
{
   if(appHelper == nil)
   {
       appHelper = [[ECSAppHelper alloc]init];
   }
  return appHelper;
}
    
    
    +(NSString *)getInvitationMailBody
    {
    
    NSString * appName = @"One";
        NSString * applink = @"www.buckworm.com/download-one-app.php";

        

        
        AppUserObject * appUserObject = [AppUserObject getFromUserDefault];
        
        NSString *mailBody=[NSString stringWithFormat:@"Hi,\n\n%@ invited you to use the %@ app!\n\nFollow this link to download the app:\n\n%@\n\nThanks!\n\nTeam %@",appUserObject.resturantName,[self getAppName],applink,[self getAppName]];
        return mailBody;
    
    
    }
    
    +(NSString *)getAppName
    {
        NSString * appName = @"One";
        

      
        return appName;
    
    }

-(void)presentActionSheetForImageSelection:(UIViewController *)controller
{
    [ECSAppHelper sharedInstance].controller = controller;
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library",nil];
    [actionSheet showInView:controller.view];
}


// delegate method of UIAction sheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if(buttonIndex == 2) return;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if(buttonIndex == 0)
    {
        
        NSError *error=nil;
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if(deviceInput)
           [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        else {
        
            [ECSAlert showAlert:@"You have not given permission to TY to use camera. You can change you privacy setting in iPhone's Settings."];
            return;
        
        }
       
    }
    else if(buttonIndex == 1)
    {
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [imagePicker setDelegate:[ECSAppHelper sharedInstance].controller];
    [[ECSAppHelper sharedInstance].controller presentViewController:imagePicker animated:YES completion:nil];
    
}


+(void)openBuckwormApp:(UIViewController *)controller
{
    UIViewController * contentScreen = nil;
    
    
    NSString *customURL = @"buckwormapp://?";
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:customURL]])
    {
        

        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
       // NSDictionary *dict= [prefs objectForKey:@"usersDetails"];
        
        NSString *appName=[prefs valueForKey:@"appName"];
        NSString *webUrl=[prefs valueForKey:@"app_website"];
        
        
       // userData=[AppData instanceFromDictionary:[dict objectForKey:@"appData"]];
        NSString *logoUrl=[prefs valueForKey:@"app_logo"];
        NSString *st=[NSString stringWithFormat:@"%@",logoUrl];
        st = [st stringByReplacingOccurrencesOfString:@" "
                                           withString:@"%20"];
        NSString *applogoString = [NSURL URLWithString:st].absoluteString;
        
        NSString *appWebsiteString = [NSURL URLWithString:webUrl].absoluteString;
        appName = [appName stringByReplacingOccurrencesOfString:@" "
                                           withString:@"%20"];
         NSString *appDynamicName = [NSURL URLWithString:appName].absoluteString;
        
        NSString *strUrl=[NSString  stringWithFormat:@"buckwormapp://?screenname=homeone//&url=%@//&logo=%@//&appName=%@",appWebsiteString,applogoString,appDynamicName];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
        
        
       
    }
    else
    {
        
        NSString *url =[NSString stringWithFormat:@"https://www.buckworm.com/download-buckworm-app.php"];
       // contentScreen = [[BC_WebPageVC alloc]initWithURL:url andTitle:@"Shop-Save-Give"];
    }
    
    if(contentScreen){
        [controller.navigationController pushViewController:contentScreen animated:NO];
        
    }


}






@end







