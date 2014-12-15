//
//  ViewController.m
//  EncryptBaby
//
//  Created by TrungBQ on 12/10/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "MainViewController.h"
#import "DLIDEKeyboardView.h"

@interface MainViewController () {
    NSArray *_products;
}

@property (nonatomic, assign) BOOL              isPurchased;
@property (weak, nonatomic) IBOutlet UITextView *txtText;
@property (weak, nonatomic) IBOutlet UITextView *encodeText;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int startC;

@end

#define kRemoveAdsProductIdentifier @"com.dragon.GuessSongApp"
#define kPurchased @"purchased"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect appframe = [[UIScreen mainScreen] bounds];
    [DLIDEKeyboardView attachToTextView:_txtText];
    [DLIDEKeyboardView attachToTextView:_encodeText];
    
    _isPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:kPurchased];
    
    if (!_isPurchased) {
        _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, appframe.size.height - 50, appframe.size.width, 50)];
        _adView.delegate = self;
        _adView.alpha = 0;
    }
    
    [self.view addSubview:_adView];
    
    _startC = 1;
    _level = 4;
    _btnEasy.selected = TRUE;
    _txtText.text = @"";
    _encodeText.text = @"";
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [_txtText resignFirstResponder];
    
    return TRUE;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        NSArray *array = [_txtText.text componentsSeparatedByString:@" "];
        if ([array count] == 6 && ![text isEqualToString:@""]) {
            [textView resignFirstResponder];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You can input only 5 words. Please purchase FULL VERSION to unlimited words" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            return NO;
        } else
            return TRUE;
    }
}

#pragma mark - AdBannerViewDelegate method implementation

-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad Banner will load ad.");
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad Banner did load ad.");
    
    // Show the ad banner.
    [UIView animateWithDuration:0.5 animations:^{
        _adView.alpha = 1.0;
    }];
}


-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    NSLog(@"Ad Banner action is about to begin.");
    
    return YES;
}


-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"Ad Banner action did finish");
    
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Unable to show ads. Error: %@", [error localizedDescription]);
    
    // Hide the ad banner.
    [UIView animateWithDuration:0.5 animations:^{
        _adView.alpha = 0.0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)encode:(NSString*) text {
    _startC = 1;
    NSArray *array = [text componentsSeparatedByString:@" "];
    NSMutableArray *eString = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *_word in array) {
        NSLog(@"_____________%@", _word);
        
        NSString *sWord = [self swapWord:_word];
        [eString addObject:sWord];
    }
    
    NSString *encodeString = [eString componentsJoinedByString:@" "];
    
    NSLog(@"Encoded %@", encodeString);
    _encodeText.text = encodeString;
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Encoded String" message:encodeString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}

- (NSString*) swapWord:(NSString*) word {
    if ([word length] > 3) {
        int ranS = (arc4random() % _level) + 1;
        int length = (int) [word length];
        
        NSString *newWord = @"";
        
        _startC = ranS;
        if (_level == 1) {
            _startC = 1;
            NSLog(@"==== Start: %d", _startC);
            if (_startC < length - 2) {
                newWord = [NSString stringWithFormat:@"%@", [word substringToIndex:_startC]];
                
                NSString *needSwap = [word substringWithRange:NSMakeRange(_startC, length - 1 - _startC)];
                NSLog(@"Need: %@", needSwap);
                NSMutableArray *swap = [[NSMutableArray alloc] initWithCapacity:0];
                NSMutableArray *swapId = [[NSMutableArray alloc] initWithCapacity:0];
                
                for (int i = _startC; i < length - 1;i++) {
                    [swapId addObject:[NSNumber numberWithInt:i]];
                }
                
                while ([swapId count] > 0) {
                    int random = arc4random() % [swapId count];
                    
                    NSLog(@"Random: %d", random);
                    [swap addObject:[NSString stringWithFormat:@"%c", [word characterAtIndex: [[swapId objectAtIndex:random] intValue]]]];
                     
                    [swapId removeObjectAtIndex:random];
                }
                
                newWord = [NSString stringWithFormat:@"%@%@%@", newWord, [swap componentsJoinedByString:@""], [word substringFromIndex:[word length] - 1]];
            } else {
                newWord = word;
            }
            NSLog(@"Encode %@", newWord);
            
            return newWord;
        } else {
            // Swap 2 half of string
            int mid = ceil(length/2);
            NSString *midFirst = [word substringWithRange:NSMakeRange(1, mid - 1)];
            NSString *midLast = [word substringWithRange:NSMakeRange(mid, length - mid - 1)];
            
            NSLog(@"____First: %@", midFirst);
            NSLog(@"_____Last: %@", midLast);
            
            NSString *swapFirst = [self swapChild:midFirst];
            NSString *swapLast = [self swapChild:midLast];
            
            newWord = [NSString stringWithFormat:@"%@%@%@%@", [word substringToIndex:1], swapFirst, swapLast, [word substringWithRange:NSMakeRange(length - 1, 1)]];
            
            return newWord;
        }
    }
    
    return word;
}

- (NSString*) swapChild:(NSString*) word {
    int length = (int) [word length];
    NSMutableArray *swapId = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *swap = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < length;i++) {
        [swapId addObject:[NSNumber numberWithInt:i]];
    }
    
    while ([swapId count] > 0) {
        int random = arc4random() % [swapId count];
        
        NSLog(@"Random: %d", random);
        [swap addObject:[NSString stringWithFormat:@"%c", [word characterAtIndex: [[swapId objectAtIndex:random] intValue]]]];
        
        [swapId removeObjectAtIndex:random];
    }
    
    NSString *newWord = [swap componentsJoinedByString:@""];
    
    return newWord;
}

#pragma mark - Message Delegate
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

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnEmailClick:(id)sender {
    MFMailComposeViewController *mViewController = [[MFMailComposeViewController alloc] init];
    mViewController.mailComposeDelegate = self;
    [mViewController setSubject:@"Encrypt Mesage"];
    [mViewController setMessageBody:_encodeText.text isHTML:NO];
    
    [self presentViewController:mViewController animated:TRUE completion:nil];
}

- (IBAction)btnSMSClick:(id)sender {
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    MFMessageComposeViewController *mViewController = [[MFMessageComposeViewController alloc] init];
    mViewController.messageComposeDelegate = self;
    [mViewController setBody:_encodeText.text];
    
    [self presentViewController:mViewController animated:TRUE completion:nil];
}

- (IBAction)btnCopyClick:(id)sender {
    [_txtText resignFirstResponder];
    
    NSString *copyStringverse = _encodeText.text;
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:copyStringverse];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Copy" message:@"Message copied to clipboard" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)btnEncodeClick:(id)sender {
    [_txtText resignFirstResponder];
    
    NSString *text = _txtText.text;
    if ([text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter message to be encoded" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    [self encode:text];
}

- (IBAction)btnClearClick:(id)sender {
    [_txtText resignFirstResponder];
    
    _txtText.text = @"";
    _encodeText.text = @"";
}

- (IBAction)easyClick:(id)sender {
    _level = 4;
    
    _btnEasy.selected = TRUE;
    _btnHard.selected = NO;
}

- (IBAction)mediumClick:(id)sender {
    _level = 2;
}

- (IBAction)hardClick:(id)sender {
    _level = 1;
    
    _btnEasy.selected = NO;
    _btnHard.selected = TRUE;
}

- (IBAction)buyClick:(id)sender {
    [SVProgressHUD showWithStatus:@"Processing ..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSArray *identifiers = [NSArray arrayWithObjects:@"", nil];
    [self validateProductIdentifiers:identifiers];
}

#pragma mark - RETRIEVE PRODUCT INFORMATION
// Custom method
- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    for(SKProduct *aProduct in response.products){
        NSLog(@"%@", aProduct.productIdentifier);
    }
    _products = response.products;
    
    if ([_products count] > 0) {
        SKProduct * product = (SKProduct *) _products[0];
        
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
    [SVProgressHUD dismiss];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        if(SKPaymentTransactionStateRestored){
            NSLog(@"Transaction state -> Restored");
            //called when the user successfully restores a purchase
            
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    [SVProgressHUD dismiss];
    for(SKPaymentTransaction *transaction in transactions){
        //        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
        if (transaction.transactionState == SKPaymentTransactionStatePurchasing){
            NSLog(@"Transaction state -> Purchasing");
            //called when the user is in the process of purchasing, do not add any of your own code here.
            [SVProgressHUD showWithStatus:@"Processing ..." maskType:SVProgressHUDMaskTypeBlack];
        }else if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            //this is called when the user has successfully purchased the package (Cha-Ching!)
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPurchased];
            [_adView removeFromSuperview];
            
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
            NSLog(@"Transaction state -> Purchased");
        } else if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            NSLog(@"Transaction state -> Restored");
            //add the same code as you did from SKPaymentTransactionStatePurchased here
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        } else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
            //called when the transaction does not finnish
            if(transaction.error.code != SKErrorPaymentCancelled){
                NSLog(@"Transaction state -> Cancelled");
                //the user cancelled the payment ;(
            }
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
    }
}

@end
