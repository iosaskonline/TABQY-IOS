


#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface ECSMessage : NSObject <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

+(instancetype)sharedInstance;
-(void)sendTextMessageTo:(NSString *)recipient body:(NSString *)body  withController:(UIViewController *)controller;


-(void)sendMailTo:(NSString *)rec bcc:(NSArray *)bccArr cc:(NSArray *)ccArr subject:(NSString *)sub body:(NSString *)body data:(NSData *)da mimeType:(NSString *)mime withController:(UIViewController *)controller;

-(void)sendMailTo:(NSString *)rec subject:(NSString *)sub body:(NSString *)body withController:(UIViewController *)controller;


-(void)sendMailTo:(NSString *)rec subject:(NSString *)sub body:(NSString *)body data:(NSData *)da mimeType:(NSString *)mime withController:(UIViewController *)controller;

-(void)sendMailTo:(NSString *)rec bcc:(NSArray *)bccArr subject:(NSString *)sub body:(NSString *)body withController:(UIViewController *)controller;

@end
