//
//  CheckinViewController.m
//  SqueekAir
//
//  Created by Sergey Pronin on 01/02/2012.
//  Copyright (c) 2012 Empatika. All rights reserved.
//

#import "CheckinViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation CheckinViewController
@synthesize buttonCheckin;
@synthesize labelFirst;
@synthesize labelScnd;
@synthesize labelButtonCheckin;
@synthesize currentURL;

+(id)sharedInstance {
    static dispatch_once_t once;
    static CheckinViewController *instance = nil;
    dispatch_once(&once, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"carbon_bg.png"]];
    
    navController = [[UINavigationController alloc] init];
    UIImageView *imgView = [[[UIImageView alloc] initWithFrame:navController.navigationBar.bounds] autorelease];
    imgView.contentMode = UIViewContentModeLeft;
    UIImage *ii = [UIImage imageNamed:@"navbar.png"];
    imgView.image = ii;
    imgView.tag = 1303;
    if([navController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [navController.navigationBar setBackgroundImage:ii forBarMetrics: UIBarMetricsDefault];
    } else {
        navController.navigationBar.layer.contents = (id)ii.CGImage;
    }
    
    checkinWebViewController = [[CheckinWebViewController alloc] init];
    checkinWebViewController.delegate = self;
    checkinWebViewController.downController = self;
    
    scrollView.backgroundColor = self.view.backgroundColor;
    scrollView.hidden = YES;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"Loading...";
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
}

- (void)viewDidUnload
{
    [webView release];
    webView = nil;
    [imageView release];
    imageView = nil;
    [scrollView release];
    scrollView = nil;
    [self setButtonCheckin:nil];
    [self setLabelFirst:nil];
    [self setLabelScnd:nil];
    [self setLabelButtonCheckin:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.title = @"Online Check-In";
    
    //check for existing image
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:currentFlightInfo.historyID];
//    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    
//    if (data) {
//        imageView.image = [UIImage imageWithData:data];
//        CGRect rect = imageView.frame;
//        rect.size = imageView.image.size;
//        imageView.frame = rect;
//        scrollView.contentSize = imageView.image.size;
//        scrollView.hidden = NO;
//    } else {
//        scrollView.hidden = YES;
//    }
    
}

-(void)viewDidDisappear:(BOOL)animated {

}

- (IBAction)clickCheckin:(id)sender {
    checkinWebViewController.URL = currentURL;
    navController.viewControllers = [NSArray arrayWithObject:checkinWebViewController];
    
    presentViewController(self.navigationController, navController, 44);
}

- (IBAction)clickPay:(id)sender {
//    navController.viewControllers = [NSArray arrayWithObject:checkinPayViewController];
    presentViewController(self.navigationController, navController, 44);
}

- (void)dealloc {
    [webView release];
    [imageView release];
    [scrollView release];
    [buttonCheckin release];
    [labelFirst release];
    [labelScnd release];
    [labelButtonCheckin release];
    [super dealloc];
}

#pragma mark - CheckinWebViewController

-(void)checkinWebViewControllerCancelled:(CheckinWebViewController *)controller {
    
}

-(void)retake {    
    checkinWebViewController.URL = currentURL;
    navController.viewControllers = [NSArray arrayWithObject:checkinWebViewController];
    presentViewController(self.navigationController, navController, 44);
}

-(void)sendEm {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@""];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:nil];
        [mailer setToRecipients:toRecipients];
        
        NSData *imageData = UIImagePNGRepresentation(shotImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"Image"]; 
        
        NSString *emailBody = @"";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        [self presentModalViewController:mailer animated:YES];
        
        [mailer release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

-(void)saveToAlb {
    UIImageWriteToSavedPhotosAlbum(shotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self.view addSubview:hud];
    [hud show:YES];
    saveToAlbum.enabled = NO;
}

- (void) image:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary*)info {
    if (hud){
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
        [hud autorelease];
        hud = nil;
    }
    [saveToAlbum setImage:[UIImage imageNamed:@"checkin_save2albumBut_inactive.png"] forState:UIControlStateNormal];
    UIAlertView* alView = [[UIAlertView alloc]initWithTitle:@"Save to album" message:@"Image successfully saved!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alView show];
    [alView release];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageViewForAnimation;
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
    CGSize boundsSize = scrollView.bounds.size;
    CGRect frameToCenter = rView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width-frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height-frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}

- (void)scrollViewDidZoom:(UIScrollView *)sscrollView {
    imageViewForAnimation.frame = [self centeredFrameForScrollView:sscrollView andUIView:imageViewForAnimation];;
}

//save image
-(void)checkinWebViewController:(CheckinWebViewController *)controller preparedCheckinImage:(UIImage *)img {
    
    scrollView.hidden = NO;
    scrollView.frame = [[UIScreen mainScreen]bounds];
    buttonCheckin.hidden = YES;
    labelFirst.hidden = YES;
    labelScnd.hidden = YES;
    labelButtonCheckin.hidden = YES;
    
    shotImage = img;
    
    retakeBt = [UIButton buttonWithType:UIButtonTypeCustom];
    retakeBt.frame = CGRectMake(self.view.bounds.size.width/2-44, 5, 88, 32);
    [retakeBt setImage:[UIImage imageNamed:@"checkin_retakeButton.png"] forState:UIControlStateNormal];
    [retakeBt addTarget:self action:@selector(retake) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retakeBt];
    
    sendEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    sendEmail.frame = CGRectMake(self.view.bounds.size.width/3-100, self.view.bounds.size.height-60, 144, 50);
    [sendEmail setImage:[UIImage imageNamed:@"checkin_sendByMailBut.png"] forState:UIControlStateNormal];
    [sendEmail addTarget:self action:@selector(sendEm) forControlEvents:UIControlEventTouchUpInside];
    
    
    saveToAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
    saveToAlbum.frame = CGRectMake((self.view.bounds.size.width/3)*2-44, self.view.bounds.size.height-60, 144, 50);
    [saveToAlbum setImage:[UIImage imageNamed:@"checkin_save2albumBut.png"] forState:UIControlStateNormal];
    [saveToAlbum addTarget:self action:@selector(saveToAlb) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewForAnimation = [[UIImageView alloc] initWithImage:img];
    imageViewForAnimation.alpha = 1.0f;
    imageViewForAnimation.contentMode = UIViewContentModeScaleAspectFit;
    
    scrollView.minimumZoomScale = scrollView.frame.size.width/imageViewForAnimation.frame.size.width;
    scrollView.maximumZoomScale = 2.0;
    [scrollView setZoomScale:scrollView.minimumZoomScale];
    
    NSArray *array = [NSArray arrayWithArray:scrollView.subviews];
    for (UIView *v in array) {
        [v removeFromSuperview];
    }
    [scrollView addSubview:imageViewForAnimation];
    [scrollView sizeToFit];
    [imageViewForAnimation release];
    
    [UIView animateWithDuration:0.5f animations:^{
        CGRect rectScroll = scrollView.frame;
        rectScroll.origin.x = 20;
        rectScroll.origin.y = 40;
        rectScroll.size.width = [[UIScreen mainScreen] bounds].size.width - 40;
        rectScroll.size.height = 310;
        scrollView.frame = rectScroll;
        rectScroll = imageViewForAnimation.frame;
        rectScroll.size.width = [[UIScreen mainScreen] bounds].size.width - 40;
        imageViewForAnimation.frame = rectScroll;
        [scrollView setContentSize:CGSizeMake(imageViewForAnimation.bounds.size.width, imageViewForAnimation.bounds.size.height)];
    }];
    
    [self.view addSubview:sendEmail];
    [self.view addSubview:saveToAlbum];
    
//    NSData *data = UIImagePNGRepresentation(img);
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
////    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:currentFlightInfo.historyID];
////    [data writeToFile:imagePath atomically:YES];
//    CGRect rect = imageView.frame;
//    rect.size = img.size;
//    imageView.frame = rect;
//    scrollView.contentSize = img.size;
//    imageView.image = img;
    dismissViewController(self.navigationController, navController);
    
    [self viewWillAppear:YES];
}

@end
