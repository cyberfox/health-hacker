//
//  RootViewController.m
//  Health Hacker
//
//  Created by Morgan Schweers on 6/25/10.
//  Copyright CyberFOX Software, Inc. 2010. All rights reserved.
//

#import "MedicationViewController.h"
#import "AIXMLSerialization.h"
#import "Medication.h"
#import "User.h"

@interface MedicationViewController (PrivateMethods)
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSString *)extract:(NSDictionary *)dict withFields:(NSArray *)fields;
@end

LoginAlertView *passwordPrompt=nil;
BOOL pullInitiated=NO;

@implementation MedicationViewController

@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  // Set up the edit and add buttons.
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
  self.navigationItem.rightBarButtonItem = addButton;
  self.navigationItem.title = @"Medications";
  User *currentUser = [User getUser:managedObjectContext_];
  if (currentUser == nil) {
    passwordPrompt = [[LoginAlertView alloc] initWithDelegate:self andMessage:@"Google Health\nUsername and password"];
  } else {
    [self loginUsername:currentUser.username andPassword:currentUser.password];
  }

  [addButton release];
}

// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [super viewDidLoad];
  if (healthService == nil) {
    [passwordPrompt showPasswordPrompt];
  }
}

-(void) pullDownToReloadAction {
  if (healthService != nil) {
    pullInitiated = YES;
    [healthService fetchFeedOfProfileList];
  } else {
    [passwordPrompt showPasswordPrompt];
  }
}


- (void)loginUsername:(NSString *)user andPassword:(NSString *)pass {
  if (healthService == nil) {
    [healthService dealloc];
  }
  healthService = [[HackersHealthService alloc] initWithDelegate:self];

  User *currentUser = [User getUser:managedObjectContext_];
  if (currentUser == nil) {
    User *uInfo = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext_];
    uInfo.username = user;
    uInfo.password = pass;
    [managedObjectContext_ save:nil];    
  }

  healthService.username = user;
  healthService.password = pass;
  [healthService fetchFeedOfProfileList];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  Medication *meds = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = [[meds valueForKey:@"product"] description];
  NSString *dosage = [[meds valueForKey:@"dosage"] description];
  NSString *kind = [[meds valueForKey:@"kind"] description];
  NSString *route = [[meds valueForKey:@"route"] description];
  NSNumber *doseCount = meds.dose_count;

  NSMutableArray *display = [NSMutableArray new];
  if(dosage != nil) [display addObject:dosage];
  if (dosage == nil && doseCount != nil && [doseCount intValue] != 0) {
    [display addObject:[doseCount stringValue]];
  }
  if(kind != nil) [display addObject:kind];
  if(route != nil) [display addObject:route];
  cell.detailTextLabel.text = [display componentsJoinedByString:@" "];
  [display release];
}

#pragma mark -
#pragma mark Add a new object

- (void)insertNewObject {
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the managed object for the given index path
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    Medication *meds = [self.fetchedResultsController objectAtIndexPath:indexPath];
    meds.current = NO;

    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
      /*
       Replace this implementation with code to handle the error appropriately.
       */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
  }   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here -- for example, create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
  if (fetchedResultsController_ != nil) {
    return fetchedResultsController_;
  }
  
  /*
   Set up the fetched results controller.
   */
  // Create the fetch request for the entity.
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  // Edit the entity name as appropriate.
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medication" inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  
  // Edit the sort key as appropriate.
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"product" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"current = %d", YES];

  [fetchRequest setSortDescriptors:sortDescriptors];
  [fetchRequest setPredicate:predicate];
  
  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
  aFetchedResultsController.delegate = self;
  self.fetchedResultsController = aFetchedResultsController;
  
  [aFetchedResultsController release];
  [fetchRequest release];
  [sortDescriptor release];
  [sortDescriptors release];
  
  NSError *error = nil;
  if (![fetchedResultsController_ performFetch:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
     */
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  return fetchedResultsController_;
}


#pragma mark -
#pragma mark Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
  healthService = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
  [fetchedResultsController_ release];
  [managedObjectContext_ release];
  [super dealloc];
}

- (Medication *)extractMedication:(GDataEntryHealthProfile *)profileEntry {
  GDataObject *xmlObject = [profileEntry continuityOfCareRecord];
  GDataObject *metaObj = [profileEntry profileMetaData];
  NSXMLElement *xmlResult = [xmlObject XMLElement];
  NSDictionary *metaDict = [[metaObj XMLElement] toDictionary];
  NSDictionary *results = [xmlResult toDictionary];
//  NSLog(@"Dictionary: %@", results);
//  NSLog(@"Pictionary: %@", metaDict);
  NSString *product = [results valueForKeyPath:@"ContinuityOfCareRecord.Body.Medications.Medication.Product.ProductName.Text"];
  NSString *dosage = [results valueForKeyPath:@"ContinuityOfCareRecord.Body.Medications.Medication.Product.Strength.Value"];
  NSString *current = [results valueForKeyPath:@"ContinuityOfCareRecord.Body.Medications.Medication.Status.Text"];
//  NSLog(@"Current: %@", current);
  if (dosage != nil) {
    NSString *unit = [results valueForKeyPath:@"ContinuityOfCareRecord.Body.Medications.Medication.Product.Strength.Units.Unit"];
    if (unit != nil) {
      dosage = [[NSString alloc] initWithFormat:@"%@%@",dosage,unit];
    }
  }
  NSString *kind = [results valueForKeyPath:@"ContinuityOfCareRecord.Body.Medications.Medication.Product.Form.Text"];
  NSString *frequency = [results valueForKeyPath:@"ContinuityOfCareRecord.Body.Medications.Medication.Directions.Direction.Frequency.Value"];
  NSString *route = [results valueForKeyPath:@"ContinuityOfCareRecord.Body.Medications.Medication.Directions.Direction.Route.Text"];
  NSString *dose = [results valueForKeyPath:@"ContinuityOfCareRecord.Body.Medications.Medication.Directions.Direction.Dose.Value"];
  NSString *comment = [metaDict valueForKeyPath:@"ProfileMetaData.UserComment.content"];
  NSString *documentId = [results valueForKeyPath:@"ContinuityOfCareRecord.CCRDocumentObjectID"];
  NSNumber *doseCount = [[NSNumber alloc] initWithInt:[dose intValue]];

  Medication *med = [Medication findByDocumentId:documentId fromContext:managedObjectContext_];
  if (med == nil) {
    med = (Medication *)[NSEntityDescription insertNewObjectForEntityForName:@"Medication" inManagedObjectContext:managedObjectContext_];
  }
  med.product = product;
  med.dosage = dosage;
  med.dose_count = doseCount;
  med.current = [[NSNumber alloc] initWithInt:[current caseInsensitiveCompare:@"ACTIVE"] == NSOrderedSame];
  med.comment = comment;
  med.kind = kind;
  med.frequency = frequency;
  med.route = route;
  med.document_id = documentId;
  [managedObjectContext_ save:nil];

  if ([current caseInsensitiveCompare:@"ACTIVE"] == NSOrderedSame) {
    if (dosage == nil) {
      if (kind == nil) {
        if(frequency == nil) frequency = [[NSString new] autorelease];
        NSLog(@"%@ %@ %@", product, frequency, route);
      } else {
        NSLog(@"%@ (%@) %@ %@", product, kind, frequency, route);
      }
    } else {
      NSLog(@"%@ (%@ %@) %@ %@", product, dosage, kind, frequency, route);
    }
  }
  return med;
}

- (void)gdataUpdated {
  if ([healthService profileListFeed] == nil) {
    NSLog(@"We haven't gotten the profile list yet");
    return;
  } else {
    NSLog(@"Got updated (%@)!", [healthService getProfileAt:0]);
  }
  if ([healthService profileFeed] == nil) {
    [healthService fetchSelectedProfile:0];
    NSLog(@"Haven't gotten the individual profile yet!");
    return;
  }
  if (pullInitiated) {
    [self.pullToReloadHeaderView finishReloading:self.tableView animated:YES];
  }
  for (GDataEntryHealthProfile *profileEntry in healthService.profileFeed.entries) {
    NSString *ccrTerm = [[profileEntry CCRCategory] term];
//    NSString *itemTerm = [[profileEntry healthItemCategory] term];

    if ([ccrTerm isEqual:@"MEDICATION"]) {
      [self extractMedication:profileEntry];
    }
  }
  [self.tableView reloadData];
  //  THIS WORKED!??!?!?!?!
  //   [healthService sendNotice];
}

@end
