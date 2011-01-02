//
//  LoginAlertView.m
//  Health Hacker
//
//  Created by Morgan Schweers on 7/5/10.
//  Copyright 2010 CyberFOX Software, Inc. All rights reserved.
//

#import "LoginAlertView.h"

@implementation LoginAlertView
#pragma mark -
#pragma mark Utility methods

UITextField *userField=nil, *passField=nil;
id<LoginAlertViewDelegate> mDelegate;
NSString *message;

- (LoginAlertView *)initWithDelegate:(id)aDelegate andMessage:(NSString *)msg {
  mDelegate = aDelegate;
  message = msg;
  return self;
}

- (void)showPasswordPrompt {
  UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:message 
                                                   message:@"\n\n\n" // IMPORTANT
                                                  delegate:self 
                                         cancelButtonTitle:@"Cancel" 
                                         otherButtonTitles:@"Enter", nil];
  
  userField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 75.0, 260.0, 25.0)]; 
  [userField setBackgroundColor:[UIColor whiteColor]];
  [userField setPlaceholder:@"username"];
  [prompt addSubview:userField];
  
  passField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 110.0, 260.0, 25.0)]; 
  [passField setBackgroundColor:[UIColor whiteColor]];
  [passField setPlaceholder:@"password"];
  [passField setSecureTextEntry:YES];
  [prompt addSubview:passField];
  
  // set place
  //  [prompt setTransform:CGAffineTransformMakeTranslation(0.0, 110.0)];
  [prompt show];
  [prompt release];
  
  // set cursor and show keyboard
  [userField becomeFirstResponder];  
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    //  Cancel means nothing gets set, nothing changes.
    return;
  }

  NSString *username = [userField text];
  NSString *password = [passField text];
  NSLog(@"Got: %@ / %@", username, password);
  [mDelegate loginUsername:username andPassword:password];
}
@end
