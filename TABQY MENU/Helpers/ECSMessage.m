


#import "ECSMessage.h"
//#import "LocalizationSystem.h"

static ECSMessage * ecsMessage;



@interface ECSMessage()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic, retain)UIViewController *parentController;
@end


@implementation ECSMessage


+(instancetype)sharedInstance
{
    if(ecsMessage == nil) ecsMessage = [[ECSMessage alloc]init];
    return ecsMessage;

}

-(void)sendMailTo:(NSString *)rec bcc:(NSArray *)bccArr cc:(NSArray *)ccArr subject:(NSString *)sub body:(NSString *)body data:(NSData *)da mimeType:(NSString *)mime withController:(UIViewController *)controller
{

    [ECSMessage sharedInstance].parentController=controller;
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = (id<MFMailComposeViewControllerDelegate>)self;
        if(da!=nil)
        [mailComposer addAttachmentData:da mimeType:mime fileName:@"Attachment"];
        [mailComposer setSubject:sub];
        [mailComposer setToRecipients:[NSArray arrayWithObject:rec]];
        if(ccArr!=nil)
        [mailComposer setCcRecipients:ccArr];
        if(bccArr!=nil)
        [mailComposer setBccRecipients:bccArr];
        [mailComposer setMessageBody:body isHTML:YES]; 
        [[ECSMessage sharedInstance].parentController presentViewController:mailComposer animated:YES completion:NULL];
    }
    else
    {
        // Account not configured in iPhone
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"Email Not Configured", nil) message:AMLocalizedString(@"Seems like your iPhone is currently not configured to send emails. Please check your settings and try again.", nil) delegate:self cancelButtonTitle:AMLocalizedString(@"OK", nil) otherButtonTitles: nil];
//        [alert show];
        
    }

}

-(void)sendMailTo:(NSString *)rec subject:(NSString *)sub body:(NSString *)body withController:(UIViewController *)controller
{

    [self sendMailTo:rec bcc:nil cc:nil subject:sub body:body data:nil mimeType:nil withController:controller];
}


-(void)sendMailTo:(NSString *)rec subject:(NSString *)sub body:(NSString *)body data:(NSData *)da mimeType:(NSString *)mime withController:(UIViewController *)controller
{
    [self sendMailTo:rec bcc:nil cc:nil subject:sub body:body data:da mimeType:mime withController:controller];
}

-(void)sendMailTo:(NSString *)rec bcc:(NSArray *)bccArr subject:(NSString *)sub body:(NSString *)body withController:(UIViewController *)controller
{
    [self sendMailTo:rec bcc:bccArr cc:nil subject:sub body:body data:nil mimeType:nil withController:controller];

}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
        NSString *message=@"";
        switch (result)
        {
            case MFMailComposeResultCancelled:
                message = @"User cancelled email.";
                break;
            case MFMailComposeResultSaved:
                message = @"Draft saved.";
                break;
            case MFMailComposeResultSent:
                message = @"Mail has been sent.";
                break;
            case MFMailComposeResultFailed:
                message=@"Mail cannot be sent at this time due to an unknown system problem. Please try again later.";
                break;
        }
    [[ECSMessage sharedInstance].parentController dismissViewControllerAnimated:YES completion:NULL];

//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:message
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
    
}



-(void)sendTextMessageTo:(NSString *)recipient body:(NSString *)body  withController:(UIViewController *)controller
{

    self.parentController=controller;
    MFMessageComposeViewController *control = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        control.body = body;
        control.recipients = [NSArray arrayWithObject:recipient];
        control.messageComposeDelegate = self;
        [self.parentController presentViewController:control animated:YES completion:NULL];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSString *message=@"";
    switch (result)
    {
        case MessageComposeResultCancelled:
            message = @"User cancelled text message.";
            break;
        case MessageComposeResultSent:
            message = @"Message has been sent.";
            break;
        case MessageComposeResultFailed:
            message=@"Message cannot be sent at this time due to an unknown system problem. Please try again later.";
            break;
    }
    [self.parentController dismissViewControllerAnimated:YES completion:NULL];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
 
}


@end
