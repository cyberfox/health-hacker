//
//  LoginAlertView.h
//  Health Hacker
//
//  Created by Morgan Schweers on 7/5/10.
//  Copyright 2010 CyberFOX Software, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginAlertViewDelegate
- (void)loginUsername:(NSString *)user andPassword:(NSString *)pass;
@end

@interface LoginAlertView : NSObject {
}

- (LoginAlertView *)initWithDelegate:(id)aDelegate andMessage:(NSString *)msg;
- (void)showPasswordPrompt;
@end
