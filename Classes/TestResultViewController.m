//
//  TestResultViewController.m
//  Health Hacker
//
//  Created by Morgan Schweers on 1/18/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import "TestResultViewController.h"
#import "BloodPressure.h"

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

- (void)awakeFromNib {
  bloodPressure = [BloodPressure getBP:self.managedObjectContext];
  for (BloodPressure *bp in bloodPressure) {
    NSLog(@"Got: %@/%@", bp.systolic, bp.diastolic);
  }
  [bloodPressure retain];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return MAX([bloodPressure count], 1);
  }
  // Return the number of rows in the section.
  return (section != 2) ? 2 : 1;
}

-(void)addBloodPressureReading:(int)heartRate systolic:(int)systolic diastolic:(int)diastolic {
  NSLog(@"Adding blood pressure reading");
  NSLog(@"Adding: %d/%d @ %d!", systolic, diastolic, heartRate);
  [BloodPressure create:self.managedObjectContext systolic:systolic diastolic:diastolic heartRate:heartRate];
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

int glucose[] = { 93, 133 };
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
  } else {
    cell.accessoryView = nil;
  }

  if (indexPath.section == 0 && indexPath.row == 0 && [bloodPressure count] == 0) {
    cell.textLabel.text = @" ";
    cell.detailTextLabel.text = @" ";
    cell.imageView.image = nil;
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
      int bloodSugar = glucose[indexPath.row];
      cell.textLabel.text = [NSString stringWithFormat:@"%d mg/Dl",bloodSugar];
      cell.imageView.image = [self rateGlucose:bloodSugar];
    } else {
      cell.detailTextLabel.text = [self currentTime:nil];
      cell.textLabel.text = @"428lbs";
      // <= goal weight is green, <=start weight is yellow, >start weight is red
      cell.imageView.image = [UIImage imageNamed:@"status_yellow"];
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

