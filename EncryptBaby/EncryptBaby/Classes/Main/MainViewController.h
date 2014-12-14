//
//  ViewController.h
//  EncryptBaby
//
//  Created by TrungBQ on 12/10/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>
#import <iAd/iAd.h>

@interface MainViewController : UIViewController <ADBannerViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UITextViewDelegate>

@property (nonatomic, retain) ADBannerView          *adView;
@property (nonatomic, assign) BOOL                  canShowAds;
@property (weak, nonatomic) IBOutlet UIButton *btnEasy;
@property (weak, nonatomic) IBOutlet UIButton *btnHard;

- (IBAction)btnCopyClick:(id)sender;
- (IBAction)btnEncodeClick:(id)sender;
- (IBAction)btnClearClick:(id)sender;
- (IBAction)easyClick:(id)sender;
- (IBAction)mediumClick:(id)sender;
- (IBAction)hardClick:(id)sender;
- (IBAction)buyClick:(id)sender;
- (IBAction)btnEmailClick:(id)sender;
- (IBAction)btnSMSClick:(id)sender;

@end

