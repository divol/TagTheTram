//
//  tttBiggerPhotoViewController.m
//  TagTheTram
//
//  Created by divol on 15/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import <Social/Social.h>
#import <MessageUI/MessageUI.h> 

#import "tttBiggerPhotoViewController.h"
#import "tttDatabase.h"


@interface tttBiggerPhotoViewController()
-(void)appliquePhoto:(NSDictionary*)laphoto;
@end

@implementation tttBiggerPhotoViewController
@synthesize photo;

@synthesize imageStation;
@synthesize titleStation;
@synthesize datetimeStation;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self appliquePhoto:photo];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)appliquePhoto:(NSDictionary*)laphoto{
    
    NSString *pathphoto = [[tttDatabase currentDatabase] getAttrPhoto:laphoto withAttr:pathPhoto];
    NSString *datephoto = [[tttDatabase currentDatabase] getAttrPhoto:laphoto withAttr:datePhoto];
    NSString *labelphoto = [[tttDatabase currentDatabase] getAttrPhoto:laphoto withAttr:labelPhoto];
    
    
     self.imageStation.image = [UIImage imageWithContentsOfFile:pathphoto];
    
    self.titleStation.text = labelphoto;
    
    //duplicated code from tttImageViewController
#pragma warning duplicated code from tttImageViewController
    
    
    NSDateFormatter *dateStr = [[NSDateFormatter alloc] init];
    [dateStr setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    
    NSDate *nsdate = [dateStr dateFromString:datephoto];
    [dateStr release];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY '@' HH:mm"];
    NSString *formattedDateString = [dateFormatter stringFromDate:nsdate];
    self.datetimeStation.text=formattedDateString  ;
    [dateFormatter release];
    
    
    
//    IBOutlet UILabel *label;
//    IBOutlet UILabel *date;
    
    
}
- (IBAction) close:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark social sharing






- (void)sendEmail {
    // Email Subject
    NSString *emailTitle = @"Tag the Tram!";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Image  %@ le %@",self.titleStation.text,self.datetimeStation.text];
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"jacques.divol@laposte.net"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    [mc addAttachmentData:UIImageJPEGRepresentation(self.imageStation.image, 1) mimeType:@"image/jpeg" fileName:@"MyFile.jpeg"];
    
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}







- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * service = NULL;
    
    switch (buttonIndex){
        case 0:
        {
           service = SLServiceTypeFacebook;
            
            break;
        }
        case 1:
        {
            service = SLServiceTypeTwitter;
            break;
        }
        case 2:
        {
            [self sendEmail];
        	break;
        }
    }
    
    if (service){
     SLComposeViewController *controllerSLC = [SLComposeViewController composeViewControllerForServiceType:service];
    
    NSString *message =[NSString stringWithFormat:@"Image  %@ le %@",self.titleStation.text,self.datetimeStation.text];
    
    [controllerSLC setInitialText:message];
    //[controllerSLC addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
    [controllerSLC addImage:self.imageStation.image];
    [self presentViewController:controllerSLC animated:YES completion:Nil];
    }

}




- (IBAction)socialAction:(id)sender{
    
    // Définir et configurer une instance d'ActionSheet
    UIActionSheet *styleAlert;
    
    
    
    
    styleAlert = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Share!",nil)
                                             delegate:self
                                    cancelButtonTitle: NSLocalizedString(@"cancel",nil)
                               destructiveButtonTitle:nil
                                    otherButtonTitles:NSLocalizedString(@"Facebook",nil), NSLocalizedString(@"Twitter",nil),NSLocalizedString(@"Mail",nil), nil
                  ];
    
    // Utiliser le style actuel de la Navigation Bar
    styleAlert.actionSheetStyle = self.navigationController.navigationBar.barStyle;
    
    // Plusieurs modes de présentation selon le contexte :
    // showInView, showFromTabBar et showFromToolBar.
    [styleAlert showInView:self.view];
    [styleAlert release];
}



@end
