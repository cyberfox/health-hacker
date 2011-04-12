//
//  BPEntryController.h
//  Health Hacker
//
//  Created by Morgan Schweers on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TestResultViewController;

@interface BPEntryController : UIViewController {
  UITextField *systolic;
  UITextField *diastolic;
  UITextField *heartRate;
@private
  TestResultViewController *testResults;
}

@property (nonatomic, retain) IBOutlet TestResultViewController *testResults;

@property (nonatomic, retain) IBOutlet UITextField *systolic;
@property (nonatomic, retain) IBOutlet UITextField *diastolic;
@property (nonatomic, retain) IBOutlet UITextField *heartRate;

- (IBAction)pressDone:(id)sender;
@end
