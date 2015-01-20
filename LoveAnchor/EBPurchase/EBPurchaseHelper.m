//
//  EBPurchaseHelper.m
//  CXGameSDK
//
//  Created by NaNa on 14-11-7.
//  Copyright (c) 2014年 nn. All rights reserved.
//

#import "EBPurchaseHelper.h"
#import "EBPurchase.h"
#import "SVProgressHUD.h"
#import "NSData+Base64.h"

@interface EBPurchaseHelper () <EBPurchaseDelegate, UIAlertViewDelegate> {
    EBPurchase *_ebPurchase;
    BOOL        _isPurchased;
    NSString   *_productId;
}

@end

@implementation EBPurchaseHelper

static EBPurchaseHelper * _sharedHelper;

+ (EBPurchaseHelper *)sharedHelper
{
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[EBPurchaseHelper alloc] init];
    return _sharedHelper;
}

- (void)requestProduct:(NSString *)productId
{
    _productId = productId;
    _ebPurchase = [[EBPurchase alloc] init];
    _ebPurchase.delegate = self;
    _isPurchased = NO;
    // Request In-App Purchase product info and availability.
    if (![_ebPurchase requestProduct:productId]) {
        // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
    }
}

#pragma mark - purchase
- (void)purchaseProduct
{
    // First, ensure that the SKProduct that was requested by
    // the EBPurchase requestProduct method in the viewWillAppear
    // event is valid before trying to purchase it.
    
    if (_ebPurchase.validProduct != nil) {
        // Then, call the purchase method.
        
        if (![_ebPurchase purchaseProduct:_ebPurchase.validProduct]) {
            // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
            UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before making this purchase." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [settingsAlert show];
        }
    }
}

- (void)restorePurchase
{
    // Restore a customer's previous non-consumable or subscription In-App Purchase.
    // Required if a user reinstalled app on same device or another device.
    
    // Call restore method.
    if (![_ebPurchase restorePurchase]) {
        // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
        UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before restoring a previous purchase." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [settingsAlert show];
    }
}

#pragma mark -
#pragma mark EBPurchaseDelegate Methods

- (void)requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription
{
    NSLog(@"ViewController requestedProduct");
    
    if (productPrice != nil) {
        // Product is available, so update button title with price.
        [self purchaseProduct];
        NSLog(@"Buy Game Levels Pack ");
    } else {
        // Product is NOT available in the App Store, so notify user.
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"This In-App Purchase item is not available in the App Store at this time. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unavailAlert show];
    }
}

- (void)successfulPurchase:(EBPurchase*)ebp identifier:(NSString*)productId receipt:(NSData*)transactionReceipt
{
    NSLog(@"ViewController successfulPurchase");
    [SVProgressHUD dismiss];

    // Purchase or Restore request was successful, so...
    // 1 - Unlock the purchased content for your new customer!
    // 2 - Notify the user that the transaction was successful.
    
    if (!_isPurchased) {
        // If paid status has not yet changed, then do so now. Checking
        // isPurchased boolean ensures user is only shown Thank You message
        // once even if multiple transaction receipts are successfully
        // processed (such as past subscription renewals).
        
        _isPurchased = YES;
                
        // 1 - Unlock the purchased content and update the app's stored settings.
        NSString *urlStr = [NSString stringWithFormat:@"%@apple/ipn/%@",BaseURL,[CommonUtil getUserModel].access_token];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
        request.delegate = self;
        
        NSString *ticket = [transactionReceipt base64Encoding];
        [request setPostValue:ticket forKey:@"receipt"];
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSNumber *code = [result objectForKey:@"code"];
        if (code.intValue == 1) {
            // 2 - Notify the user that the transaction was successful.
            [SVProgressHUD dismiss];
            NSDictionary *dic = @{@"productId": _productId,
                                  };
            [[NSNotificationCenter defaultCenter] postNotificationName:PURCHASE_SUCCESSED_NOTIFICATION object:nil userInfo:dic];
        }
    }
}

- (void)failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    NSLog(@"ViewController failedPurchase");
    [SVProgressHUD dismiss];

    // Purchase or Restore request failed, so notify the user.

    NSDictionary *dic = @{@"errorCode": [NSString stringWithFormat:@"%ld",(long)errorCode],
                          @"errorMessage": errorMessage
                          };
    [[NSNotificationCenter defaultCenter] postNotificationName:PURCHASE_FAILED_NOTIFICATION object:nil userInfo:dic];
}

- (void)cancelledPurchase:(EBPurchase *)ebp error:(NSInteger)errorCode message:(NSString *)errorMessage
{
    NSLog(@"ViewController cancelledPurchase");
    [SVProgressHUD dismiss];
    // Purchase or Restore request was cancelled, so notify the user.
    
    NSDictionary *dic = @{@"errorMessage": errorMessage};
    [[NSNotificationCenter defaultCenter] postNotificationName:PURCHASE_CANCELLED_NOTIFICATION object:nil userInfo:dic];
}

- (void)incompleteRestore:(EBPurchase*)ebp
{
    NSLog(@"ViewController incompleteRestore");
    
    // Restore queue did not include any transactions, so either the user has not yet made a purchase
    // or the user's prior purchase is unavailable, so notify user to make a purchase within the app.
    // If the user previously purchased the item, they will NOT be re-charged again, but it should
    // restore their purchase.
    
    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:@"Restore Issue" message:@"A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [restoreAlert show];
}

- (void)failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    NSLog(@"ViewController failedRestore");
    
    // Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Restore Stopped" message:@"Either you cancelled the request or your prior purchase could not be restored. Please try again later, or contact the app's customer support for assistance." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [SVProgressHUD dismiss];
}

@end
