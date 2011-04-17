//
//  TestResultViewController.m
//  Health Hacker
//
//  Created by Morgan Schweers on 1/18/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIKit/UIKit.h"
#import "TestResultViewController.h"
#import "BloodPressure.h"
#import "BloodGlucose.h"
#import "Weight.h"

@implementation TestResultViewController

@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;

#pragma mark -
#pragma mark Initialization

UIImage *green;
UIImage *yellow;
UIImage *red;

@synthesize bpEntry;
@synthesize displayTableView;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

NSArray *bloodPressure;
NSArray *glucose;
NSArray *weights;

- (void)awakeFromNib {
  bloodPressure = [[BloodPressure getBP:self.managedObjectContext] retain];
  glucose = [[BloodGlucose getGlucose:self.managedObjectContext] retain];
  weights = [[Weight getWeight:self.managedObjectContext] retain];

  green = [UIImage imageNamed:@"status_green"];
  yellow = [UIImage imageNamed:@"status_yellow"];
  red = [UIImage imageNamed:@"status_red"];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString *SECTIONS[] = { @"Blood Pressure", @"Blood Sugar", @"Weight" };
  
  if(section < 3 && section >=0) return SECTIONS[section];
  return nil;
}

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *sections[] = { bloodPressure, glucose, weights };
  NSArray *currentSection = sections[section];
  return MAX([currentSection count], 1);
}

-(void)addBloodPressureReading:(int)heartRate systolic:(int)systolic diastolic:(int)diastolic {
  NSLog(@"Adding blood pressure reading");
  NSLog(@"Adding: %d/%d @ %d!", systolic, diastolic, heartRate);
  [BloodPressure create:self.managedObjectContext systolic:systolic diastolic:diastolic heartRate:heartRate];
  [bloodPressure release];
  bloodPressure = [BloodPressure getBP:self.managedObjectContext];
  [bloodPressure retain];
  [displayTableView reloadData];
}

- (NSString *)currentTime:(NSDate *)when {
  NSDateFormatter *format = [[NSDateFormatter alloc] init];
  [format setDateFormat:@"MMM dd, yyyy HH:mm"];
  if (when == nil) {
    when = [[NSDate alloc] init];
  }
  
  NSString *dateString = [format stringFromDate:when];
  return dateString;
}

// <100 is green, 100-140 is yellow, > 140 is red
- (UIImage *)rateGlucose:(int) glucose {
  if (glucose < 100) {
    return green;
  } else if (glucose < 140) {
    return yellow;
  } else {
    return red;
  }
}

// < 120/80 is green, < 140/90 is yellow, >=140/90 is red ( http://en.wikipedia.org/wiki/Blood_pressure )
- (UIImage *)rateBloodPressure:(int)sys diastolic:(int)dia {
  if (sys < 120 && dia <= 80) {
    return green;
  } else if (sys < 140 && dia < 90) {
    return yellow;
  } else {
    return red;
  }
}

#define PI 3.14159265358979323846
#define DEG_TO_RAD(x) (x*PI)/180.0

+ (void) drawArc:(double)percentage width:(double)size_x height:(double)size_y {
  UIColor *outlineColor = [UIColor grayColor];
  UIColor *completeColor = [UIColor lightGrayColor];

  if (percentage != 0.0) {
    double endAngle = fmod(360*(percentage/100.0) + 270.0, 360.0);
    UIBezierPath *greenPath = [UIBezierPath bezierPath];

    [greenPath setLineWidth:1];

    // move to the center so that we have a closed slice
    // size_x and size_y are the height and width of the view
    [greenPath moveToPoint:CGPointMake(size_x/2.0, size_y/2.0)];

    // draw an arc
    [greenPath addArcWithCenter:CGPointMake(size_x/2, size_y/2) radius:(size_x/2.0-1) startAngle:DEG_TO_RAD(270.0) endAngle:DEG_TO_RAD(endAngle) clockwise:YES];

    // close the slice , by drawing a line to the center
    [greenPath addLineToPoint:CGPointMake(size_x/2.0, size_y/2.0)];
    //  Outline it...
    [outlineColor set];
    [greenPath stroke];

    [completeColor set];
    // ...and fill it
    [greenPath fill];
  }

  //  Always draw the outer circle
  UIBezierPath *outerPath = [UIBezierPath bezierPath];
  [outerPath addArcWithCenter:CGPointMake(size_x/2.0, size_y/2.0) radius:(size_x/2.0-1) startAngle:DEG_TO_RAD(0.0) endAngle:DEG_TO_RAD(360.0) clockwise:YES];
  [outerPath setLineWidth:2];
  [outlineColor set];
  [outerPath stroke];
}

+ (UIImage *) drawImage:(double)percent width:(double)width height:(double)height {
//  CGRect size = CGRectMake(0.0, 0.0, width, height);
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, [UIScreen mainScreen].scale);
  [self drawArc:percent width:width height:height];
  UIImage *result = UIGraphicsGetImageFromCurrentImageContext();;
  UIGraphicsEndImageContext();
  return result;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }

  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  if (indexPath.row == 0) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"add"];
    
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    if (indexPath.section == 0) {
      [button addTarget:self action:@selector(enterBP:) forControlEvents:UIControlEventTouchUpInside];
    }
    button.userInteractionEnabled = YES;
    
    cell.accessoryView = button;
  }

  NSArray *sections[] = { bloodPressure, glucose, weights };

  if ([sections[indexPath.section] count] == 0) {
    cell.textLabel.text = @" ";
    cell.detailTextLabel.text = @" ";
    UIImage *img = [TestResultViewController drawImage:25 width:24.0 height:24.0];
    cell.imageView.image = img;

//    cell.imageView.image = nil;
  } else {
    if (indexPath.section == 0) {
      BloodPressure *bp = [bloodPressure objectAtIndex:indexPath.row];
      cell.detailTextLabel.text = [self currentTime:bp.created_at];
      int sys = [bp.systolic intValue];
      int dia = [bp.diastolic intValue];
      int rate = [bp.beats intValue];
      cell.textLabel.text = [NSString stringWithFormat:@"%d/%d at %dbpm",sys,dia,rate];
      cell.imageView.image = [self rateBloodPressure:sys diastolic:dia];
    } else if (indexPath.section == 1) {
      cell.detailTextLabel.text = [self currentTime:nil];
      BloodGlucose *reading = [glucose objectAtIndex:indexPath.row];
      int bloodSugar = [reading.milligrams intValue];
      cell.textLabel.text = [NSString stringWithFormat:@"%d mg/Dl",bloodSugar];
      cell.imageView.image = [self rateGlucose:bloodSugar];
    } else {
      UIImage *img = [TestResultViewController drawImage:1 width:24.0 height:24.0];
      cell.imageView.image = img;

      cell.accessoryView = nil;
      cell.detailTextLabel.text = [self currentTime:nil];
      cell.textLabel.text = @"428lbs";
      // <= goal weight is green, <=start weight is yellow, >start weight is red
//      cell.imageView.image = [UIImage imageNamed:@"status_yellow"];
    }
  }

  return cell;
}

- (void)enterBP:(id)sender {
  [self.navigationController pushViewController:bpEntry animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
//}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
  [super dealloc];
}


@end

