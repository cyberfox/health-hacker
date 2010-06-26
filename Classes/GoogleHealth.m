//
//  GoogleHealth.m
//  Health Hacker
//
//  Created by Morgan Schweers on 6/25/10.
//  Copyright 2010 CyberFOX Software, Inc. All rights reserved.
//

#import "GoogleHealth.h"
@interface GoogleHealth (PrivateMethods)
- (void)setProfileListFeed:(GDataFeedBase *)feed;
- (NSError *)profileListFetchError;
- (void)setProfileListFetchError:(NSError *)error;

- (void)setProfileFeed:(GDataFeedHealthProfile *)feed;
- (NSError *)profileFetchError;
- (void)setProfileFetchError:(NSError *)error;

- (void)setRegisterFeed:(GDataFeedHealthRegister *)feed;
- (NSError *)registerFetchError;
- (void)setRegisterFetchError:(NSError *)error;
@end


@implementation GoogleHealth
- (id)initWithDelegate:(id)delegate {
  mDelegate = delegate;
  if (NO) {
    mServiceClass = [GDataServiceGoogleHealthSandbox class];
  } else {
    mServiceClass = [GDataServiceGoogleHealth class];
  }

  return self;
}

- (void)dealloc {
  [mProfileListFeed release];
  [mProfileListFetchError release];
  
  [mProfileFeed release];
  [mProfileFetchError release];
  
  [mRegisterFeed release];
  [mRegisterFetchError release];
  
  [super dealloc];
}

#pragma mark -

// get a service object with the current username/password
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information (such as cookies and the "last modified" date for
// fetched data.)
//
// For Google Health, there are separate classes for the testing (sandbox)
// service and the production service

- (GDataServiceGoogleHealth *)healthService {
  
  static GDataServiceGoogleHealth* service = nil;
  
  // the service class may have changed if the user clicked the sandbox
  // radio buttons
  if (service == nil || ![service isMemberOfClass:mServiceClass]) {
    
    // allocate the currently-selected service class
    [service release];
    service = [[mServiceClass alloc] init];
    
    [service setShouldCacheDatedData:YES];
    [service setServiceShouldFollowNextLinks:YES];
  }
  
  // username/password may change

  [service setUserCredentialsWithUsername:username
                                 password:password];
  return service;
}

// get the profileList selected in the top list, or nil if none
- (GDataEntryBase *)selectedProfileListEntry:(int)index {
  
  NSArray *profileLists = [mProfileListFeed entries];
  int rowIndex = index;
  if ([profileLists count] > 0 && rowIndex > -1) {
    
    GDataEntryBase *profileList = [profileLists objectAtIndex:rowIndex];
    return profileList;
  }
  return nil;
}

// get the profile selected in the second list, or nil if none
- (GDataEntryHealthProfile *)selectedProfile:(int)index {
  NSArray *entries = [mProfileFeed entries];
  int rowIndex = index;
  if ([entries count] > 0 && rowIndex > -1) {
    
    GDataEntryHealthProfile *profile = [entries objectAtIndex:rowIndex];
    return profile;
  }
  return nil;
}

// get the register selected in the second list, or nil if none
- (GDataEntryHealthRegister *)selectedRegister:(int)index {
  NSArray *entries = [mRegisterFeed entries];
  int rowIndex = index;
  if ([entries count] > 0 && rowIndex > -1) {
    
    GDataEntryHealthRegister *registerEntry = [entries objectAtIndex:rowIndex];
    return registerEntry;
  }
  return nil;
}

#pragma mark Fetch feed of all of the user's profileLists

// begin retrieving the list of the user's profileLists
- (void)fetchFeedOfProfileList {
  
  [self setProfileListFeed:nil];
  [self setProfileListFetchError:nil];
  
  [self setProfileFeed:nil];
  [self setProfileFetchError:nil];
  
  [self setRegisterFeed:nil];
  [self setRegisterFetchError:nil];
  
  mIsProfileListFetchPending = YES;
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  GDataServiceGoogleHealth *service = [self healthService];
  NSURL *feedURL = [mServiceClass profileListFeedURL];
  [service fetchFeedWithURL:feedURL
                   delegate:self
          didFinishSelector:@selector(profileListFeedTicket:finishedWithFeed:error:)];
  }

// profile list fetch callback
- (void)profileListFeedTicket:(GDataServiceTicket *)ticket
             finishedWithFeed:(GDataFeedBase *)feed
                        error:(NSError *)error {
  
  [self setProfileListFeed:feed];
  [self setProfileListFetchError:error];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

  mIsProfileListFetchPending = NO;

  [mDelegate gdataUpdated];
}

#pragma mark Fetch a profileList's profile

// for the profileList selected in the top list, begin retrieving the feed of
// analytics data

- (void)fetchSelectedProfile:(int)index {
  GDataEntryBase *profileListEntry = [self selectedProfileListEntry:0];
  if (profileListEntry != nil) {
    
    [self setProfileFeed:nil];
    [self setProfileFetchError:nil];
    
    [self setRegisterFeed:nil];
    [self setRegisterFetchError:nil];
    
    NSString *profileID = [[profileListEntry content] stringValue];
    
    GDataServiceGoogleHealth *service = [self healthService];
    
    NSURL *feedURL;
    if (YES) {
//    if ([self isProfileSegmentSelected]) {
      // fetch a profile feed
      feedURL = [mServiceClass profileFeedURLForProfileID:profileID];
      [service fetchFeedWithURL:feedURL
                       delegate:self
              didFinishSelector:@selector(profileFeedTicket:finishedWithFeed:error:)];
      mIsProfileFetchPending = YES;
    } else {
      // fetch notices in the register feed
      feedURL = [mServiceClass registerFeedURLForProfileID:profileID];
      [service fetchFeedWithURL:feedURL
                       delegate:self
              didFinishSelector:@selector(registerFeedTicket:finishedWithFeed:error:)];
      mIsRegisterFetchPending = YES;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  }
}

// profiles/notices fetch callback
- (void)profileFeedTicket:(GDataServiceTicket *)ticket
         finishedWithFeed:(GDataFeedHealthProfile *)feed
                    error:(NSError *)error {
  
  [self setProfileFeed:feed];
  [self setProfileFetchError:error];
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  mIsProfileFetchPending = NO;

  [mDelegate gdataUpdated];
}

- (void)registerFeedTicket:(GDataServiceTicket *)ticket
          finishedWithFeed:(GDataFeedHealthRegister *)feed
                     error:(NSError *)error {
  
  [self setRegisterFeed:feed];
  [self setRegisterFetchError:error];
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  mIsRegisterFetchPending = NO;

  [mDelegate gdataUpdated];
}

- (NSString *)getProfileAt:(int)index {
  GDataEntryBase *entry = [[mProfileListFeed entries] objectAtIndex:index];
  return [[entry title] stringValue];
}

- (NSString *)getEntryAt:(int)index {
  // identify the profile entry with the CCR and health item
  // categories
  GDataEntryHealthProfile *profileEntry;
  profileEntry = [[mProfileFeed entries] objectAtIndex:index];

  NSDate *editDate = [[profileEntry editedDate] date];
  NSString *ccrTerm = [[profileEntry CCRCategory] term];
  NSString *itemTerm = [[profileEntry healthItemCategory] term];

  //  Date: {type}/{details}
  NSString *displayStr = [NSString stringWithFormat:@"%@: %@/%@",
                          editDate, ccrTerm, itemTerm];

  return displayStr;
}

- (NSString *)getRegisterAt:(int)index {
  GDataEntryHealthProfile *registerEntry;
  registerEntry = [[mRegisterFeed entries] objectAtIndex:index];
  
  return [[registerEntry title] stringValue];
}

#pragma mark Setters and Getters

- (GDataFeedBase *)profileListFeed {
  return mProfileListFeed;
}

- (void)setProfileListFeed:(GDataFeedBase *)feed {
  [mProfileListFeed autorelease];
  mProfileListFeed = [feed retain];
}

- (NSError *)profileListFetchError {
  return mProfileListFetchError;
}

- (void)setProfileListFetchError:(NSError *)error {
  [mProfileListFetchError release];
  mProfileListFetchError = [error retain];
}


- (GDataFeedHealthProfile *)profileFeed {
  return mProfileFeed;
}

- (void)setProfileFeed:(GDataFeedHealthProfile *)feed {
  [mProfileFeed autorelease];
  mProfileFeed = [feed retain];
}

- (NSError *)profileFetchError {
  return mProfileFetchError;
}

- (void)setProfileFetchError:(NSError *)error {
  [mProfileFetchError release];
  mProfileFetchError = [error retain];
}


- (GDataFeedHealthRegister *)registerFeed {
  return mRegisterFeed;
}

- (void)setRegisterFeed:(GDataFeedHealthRegister *)feed {
  [mRegisterFeed autorelease];
  mRegisterFeed = [feed retain];
}

- (NSError *)registerFetchError {
  return mRegisterFetchError;
}

- (void)setRegisterFetchError:(NSError *)error {
  [mRegisterFetchError release];
  mRegisterFetchError = [error retain];
}
@end
