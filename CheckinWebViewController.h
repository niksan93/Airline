//
//  CheckinWebViewController.h
//  SqueekAir
//
//  Created by Sergey Pronin on 01/02/2012.
//  Copyright (c) 2012 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class CheckinWebViewController;

@protocol CheckinWebViewControllerDelegate <NSObject>

-(void)checkinWebViewController:(CheckinWebViewController *)controller preparedCheckinImage:(UIImage *)img;
-(void)checkinWebViewControllerCancelled:(CheckinWebViewController *)controller;

@end

@interface CheckinWebViewController : UIViewController<NSURLConnectionDataDelegate, UIWebViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
    UIViewController *downController;
    
    UIWebView *webView;
    
    UIToolbar* tlbar;
    UIButton *btnMenu;
    
    NSObject<CheckinWebViewControllerDelegate> *delegate;
    
    MBProgressHUD *hud;
}

@property (nonatomic, retain) NSObject<CheckinWebViewControllerDelegate> *delegate;
@property (nonatomic, retain) UIViewController *downController;
@property (nonatomic, retain) NSString *URL;

@end
