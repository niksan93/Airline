//
//  CheckinViewController.h
//  SqueekAir
//
//  Created by Sergey Pronin on 01/02/2012.
//  Copyright (c) 2012 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckinWebViewController.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"

@interface CheckinViewController : UIViewController <CheckinWebViewControllerDelegate, UIScrollViewDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
    NSString *currentURL;
    
    IBOutlet UIWebView *webView;
    IBOutlet UIImageView *imageView;
    UINavigationController *navController;
    IBOutlet UIScrollView *scrollView;
    
    UIImage* shotImage;
    UIButton* retakeBt;
    UIButton* sendEmail;
    UIButton* saveToAlbum;
    UIImageView *imageViewForAnimation;
    
    CheckinWebViewController *checkinWebViewController;

    MBProgressHUD *hud;
}

@property (nonatomic, retain) NSString *currentURL;
@property (retain, nonatomic) IBOutlet UIButton *buttonCheckin;
@property (retain, nonatomic) IBOutlet UILabel *labelFirst;
@property (retain, nonatomic) IBOutlet UILabel *labelScnd;
@property (retain, nonatomic) IBOutlet UILabel *labelButtonCheckin;

- (IBAction)clickCheckin:(id)sender;
- (IBAction)clickPay:(id)sender;

+(id)sharedInstance;

@end


static void presentViewController(UIViewController *parent, UIViewController *child, float toY) {
    CGRect rect = child.view.frame;
    rect.origin.y = parent.view.frame.size.height;
    child.view.frame = rect;
    
    [parent.view addSubview:child.view];
    
    if ([parent isKindOfClass:[UITableViewController class]]) {
        UITableViewController *tvcon = (UITableViewController *)parent;
        [[tvcon tableView] setScrollEnabled:NO];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        
        CGRect frame = child.view.frame;
        frame.origin.y = toY;
        child.view.frame = frame;
        
    }];
}

static void dismissViewController(UIViewController *parent, UIViewController *child) {
    [UIView animateWithDuration:0.3f animations:^{
        
        CGRect rect = child.view.frame;
        rect.origin.y = parent.view.frame.size.height;
        child.view.frame = rect;
        
    }
                     completion:^(BOOL f) {
                         [child.view removeFromSuperview];
                     }
     ];
    
    
    if ([parent isKindOfClass:[UITableViewController class]]) {
        UITableViewController *tvcon = (UITableViewController *)parent;
        [[tvcon tableView] setScrollEnabled:YES];
    }
}