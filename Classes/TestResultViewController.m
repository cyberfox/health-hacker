//
//  TestResultViewController.m
//  Health Hacker
//
//  Created by Morgan Schweers on 1/18/11.
//  Copyright 2011 CyberFOX Software, Inc. All rights reserved.
//

#import "TestResultViewController.h"


@implementation TestResultViewController

@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;

#pragma mark -
#pragma mark Initialization

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


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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
  // Return the number of rows in the section.
  return (section == 0) ? 2 : 1;
}

- (NSString *)currentTime {
  NSDateFormatter *format = [[NSDateFormatter alloc] init];
  [format setDateFormat:@"MMM dd, yyyy HH:mm"];
  
  NSDate *now = [[NSDate alloc] init];
  
  NSString *dateString = [format stringFromDate:now]; 
  return dateString;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }

  if (indexPath.section == 0) {
    if (indexPath.row == 1) {
      cell.textLabel.text = @"124/86 at 88bpm";
      cell.detailTextLabel.text = [self currentTime];
      //  <130/85 is green, <=140/95 is yellow, > 140/95 is red
      cell.imageView.image = [UIImage imageNamed:@"status_yellow"];
    } else {
      cell.textLabel.text = @"120/74 at 82bpm";
      cell.detailTextLabel.text = [self currentTime];
      //  <130/85 is green, <=140/95 is yellow, > 140/95 is red
      cell.imageView.image = [UIImage imageNamed:@"status_green"];
    }

    if (indexPath.row == 0) {
      UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
      UIImage *image = [UIImage imageNamed:@"add" ];

      CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
      button.frame = frame;
      [button setBackgroundImage:image forState:UIControlStateNormal];
      button.userInteractionEnabled = YES;

      cell.accessoryView = button;
    }
  } else if (indexPath.section == 1) {
    cell.textLabel.text = @"93 mg/Dl";
    cell.detailTextLabel.text = [self currentTime];
    // <100 is green, 100-140 is yellow, > 140 is red
    cell.imageView.image = [UIImage imageNamed:@"status_green"];
  } else {
    cell.textLabel.text = @"428lbs";
    cell.detailTextLabel.text = [self currentTime];
    // <= goal weight is green, <=start weight is yellow, >start weight is red
    cell.imageView.image = [UIImage imageNamed:@"status_yellow"];
  }

  return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

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

