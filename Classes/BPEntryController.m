//
//  BPEntryController.m
//  Health Hacker
//
//  Created by Morgan Schweers on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BPEntryController.h"
#import "TestResultViewController.h"

@implementation BPEntryController

@synthesize systolic;
@synthesize diastolic;
@synthesize heartRate;
@synthesize testResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)pressDone:(id)sender {
  NSString *sys = [systolic text];
  int iSys = [sys intValue];
  NSString *dia = diastolic.text;
  int iDia = [dia intValue];
  NSString *hr = heartRate.text;
  int iHr = [hr intValue];
  // TODO (mrs) -- Error checking

  [testResults addBloodPressureReading:iHr systolic:iSys diastolic:iDia];
  NSLog(@"Add pressed (%d/%d @ %d)!", iSys, iDia, iHr);
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [systolic becomeFirstResponder];
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

@end
