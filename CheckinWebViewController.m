//
//  CheckinWebViewController.m
//  SqueekAir
//
//  Created by Sergey Pronin on 01/02/2012.
//  Copyright (c) 2012 Empatika. All rights reserved.
//

#import "CheckinWebViewController.h"
#import "CheckinViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation CheckinWebViewController
@synthesize URL;
@synthesize downController;
@synthesize delegate;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416-75)];
    [self.view addSubview:webView];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)clickDown {
    [webView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
    [delegate checkinWebViewControllerCancelled:self];
    dismissViewController(downController.navigationController, self.navigationController);
}

-(void)clickSnapshot {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Online Check-In" message:@"This window will be saved as the online boarding pass for your flight. Continue?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    [alert show];
    [alert release];
    
//    if (demo()) {
//        [BPUtils analyzeEvent:@"checkin_snapshotDemo"];
//    } else {
//        [BPUtils analyzeEvent:@"checkin_snapshot"];
//    }
}

-(void)clickFwrd {
    if ([webView canGoForward]) {
        [webView goForward];
    }
}

-(void)clickBack {
    if ([webView canGoBack]) {
        [webView goBack];
    }
}

-(void)clickAct {
    UIActionSheet* actSheet = [[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil]autorelease];
    [actSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        NSString* currentURL = webView.request.URL.absoluteString;
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:currentURL]];
	}
}

-(void)viewWillAppear:(BOOL)animated {
    btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMenu.frame = CGRectMake(0, 0, 88, 32);
    [btnMenu setImage:[UIImage imageNamed:@"modalka_CloseBut.png"] forState:UIControlStateNormal];
    [btnMenu addTarget:self action:@selector(clickDown) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnMenu] autorelease];
    
    btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMenu.frame = CGRectMake(0, 0, 118, 32);
    [btnMenu setImage:[UIImage imageNamed:@"checkin_barcodeButton_2.png"] forState:UIControlStateNormal];
    [btnMenu addTarget:self action:@selector(clickSnapshot) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnMenu] autorelease];
    
    tlbar = [[[UIToolbar alloc]init]autorelease];
    tlbar.barStyle = UIBarStyleBlack;
    [tlbar sizeToFit];
//    CGFloat toolbarHeight = [tlbar frame].size.height;
//    CGRect rootViewBounds = self.parentViewController.view.bounds;
//    CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
//    CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
//
////    NSLog(@"%@", self.navigationController.navigationBar.bounds.size.height);
//    CGRect rectArea = CGRectMake(0, rootViewHeight-toolbarHeight-96, rootViewWidth, toolbarHeight);
//    [tlbar setFrame:rectArea];
    tlbar.frame = CGRectMake(0, 340, self.view.bounds.size.width, 32);

    UIBarButtonItem* btnFwrd = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"checkin_browser_fwrd.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickFwrd)]autorelease];
    
     UIBarButtonItem* btnBack = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"checkin_browser_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBack)]autorelease];
    
    UIBarButtonItem* btnAct = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(clickAct)]autorelease];
    
    UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]autorelease];
    
    [tlbar setItems:[NSArray arrayWithObjects:btnBack, flexibleSpace, btnFwrd, flexibleSpace, flexibleSpace, btnAct, nil]];
    [self.view addSubview:tlbar];
    
//    NSString *strUrl = airline.checkinMobile ? airline.checkinMobile : airline.checkinWeb;
//    if ([strUrl rangeOfString:@"http://"].length == 0) {
//        if ([strUrl rangeOfString:@"https://"].length == 0)
//            strUrl = [NSString stringWithFormat:@"http://%@", strUrl];
//    }
    
    NSString *strUrl = @"http://m.aeroflot.ru/";
    
    if (hud) {
        [hud hide:NO];
        [hud removeFromSuperview];
        [hud release];
        hud = nil;
    }
    
    
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
}

#pragma mark - UIWebViewDelegate

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, [error description]);
    if (hud){
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
        [hud autorelease];
//        hud = nil;
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"Loading...";
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    [hud show:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (hud){
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
        [hud autorelease];
        hud = nil;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
//        if (demo()){ 
//            [BPUtils analyzeEvent:@"checkin_snapshot_doneDemo"];
//        } else {
//            [BPUtils analyzeEvent:@"checkin_snapshot_done"];
//        }
        
        UIView* viewWhite = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        viewWhite.alpha = 1.0;
        viewWhite.backgroundColor = [UIColor whiteColor];
        [self.view.window addSubview:viewWhite];
        [UIView animateWithDuration:0.5f animations:^{
            viewWhite.alpha = 0;
        } completion:^(BOOL finished) {
            [viewWhite removeFromSuperview];
            [viewWhite release];

        }]; 
        CGRect tmpFrame         = webView.frame;
        // set new Frame
        CGRect aFrame               = webView.frame;
        aFrame.size.height  = [webView sizeThatFits:[[UIScreen mainScreen] bounds].size].height;
        webView.frame              = aFrame;
        
        // do image magic
        UIGraphicsBeginImageContext([webView sizeThatFits:[[UIScreen mainScreen] bounds].size]);
//        UIGraphicsBeginImageContext(webView.bounds.size);
        
        CGContextRef resizedContext = UIGraphicsGetCurrentContext();
        [webView.layer renderInContext:resizedContext];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        // reset Frame of view to origin
        webView.frame = tmpFrame;
        
        
        [delegate checkinWebViewController:self preparedCheckinImage:image];
        
        [webView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
    } else {
//        if (demo()) {
//            [BPUtils analyzeEvent:@"checkin_snapshot_cancelDemo"];
//        } else {
//            [BPUtils analyzeEvent:@"checkin_snapshot_cancel"];
//        }
    }
}



@end
