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

- (NSString *)getAuthCodeForUser:(NSString *)inUsername password:(NSString *)inPassword;
- (NSString *)urlencode:(NSString *)unencoded;
@end


@implementation GoogleHealth

@synthesize username, password;

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
  [service setAuthToken:[self getAuthCodeForUser:username password:password]];
  return service;
}

- (NSString *)urlencode:(NSString *)unencoded {
  return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                             (CFStringRef)unencoded,
                                                             NULL,
                                                             (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                             kCFStringEncodingUTF8 );
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

#pragma mark Experimental

- (NSString *)getAuthCodeForUser:(NSString *)inUsername password:(NSString *)inPassword {
  NSString *authCodeRequest = @"https://www.google.com/accounts/ClientLogin";
  NSMutableURLRequest *httpReq = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:authCodeRequest]];
  [httpReq setTimeoutInterval:30.0];
  [httpReq setHTTPMethod:@"POST"];
  [httpReq addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

  NSString *body = [[NSString alloc] initWithFormat:@"Email=%@&Passwd=%@&service=health&source=CyberFOX-iHackHealth-1",
                    [self urlencode:inUsername], [self urlencode:inPassword]];

  [httpReq setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding]];

  NSHTTPURLResponse *response = nil;
  NSData *data = nil;
  NSError *error = nil;
  NSString* responseStr;
  data = [NSURLConnection sendSynchronousRequest:httpReq
                               returningResponse:&response error:&error];
  if( [data length] > 0) {
    responseStr = [[NSString alloc] initWithData:data
                                        encoding:NSASCIIStringEncoding];
  }

  NSString *authCode;
  NSArray *cookies = [responseStr componentsSeparatedByString:@"\n"];
  for (NSString *cookie in cookies) {
    NSArray *keyValue = [cookie componentsSeparatedByString:@"="];
    if([keyValue count] > 1) {
      if ([[keyValue objectAtIndex:0] isEqualToString:@"Auth"]) {
        authCode = [keyValue objectAtIndex:1];
        NSLog(@"Received auth code: %@", authCode);
      }
    }
  }

  return authCode;
}

- (void)sendNotice {
  GDataEntryBase *profileListEntry = [self selectedProfileListEntry:0];

  NSString *profileID = [[profileListEntry content] stringValue];
  GDataServiceGoogleHealth *service = [self healthService];
  NSString *token = [service authToken];

  NSString *myStr = [NSString stringWithFormat:@"https://www.google.com/health/feeds/register/ui/%@", profileID];
  NSMutableURLRequest *httpReq = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:myStr]];
  [httpReq setTimeoutInterval:30.0];
  [httpReq setHTTPMethod:@"POST"];
  [httpReq addValue:@"application/atom+xml" forHTTPHeaderField:@"Content-Type"];

  NSString* param = [NSString stringWithFormat:@"GoogleLogin auth=%@", token];
  [httpReq setValue:param forHTTPHeaderField: @"Authorization"];
//  [httpReq addValue:@"Authorization" forHTTPHeaderField:param];

  NSString *strData = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  "<entry xmlns=\"http://www.w3.org/2005/Atom\">"
    "<title type=\"text\">Health Hacker Recording</title>"
    "<content type=\"text\">Blood Glucose Update</content>"
    "<ContinuityOfCareRecord xmlns=\"urn:astm-org:CCR\">"
      "<Body>"
        "<Results>"
          "<Result>"
            "<Test>"
              "<DateTime>"
                "<Type><Text>Date logged</Text></Type>"
                "<ExactDateTime>2010-06-04T01:23:45Z</ExactDateTime>"
              "</DateTime>"
              "<Description>"
                "<Text>Glucose, Blood</Text>"
                "<Code>"
                  "<Value>7.6164</Value>"
                  "<CodingSystem>Google</CodingSystem>"
                "</Code>"
              "</Description>"
              "<Source>"
                "<Actor>"
                  "<ActorID>cyberfox@gmail.com</ActorID>"
                  "<ActorRole>"
                    "<Text>Patient</Text>"
                  "</ActorRole>"
                "</Actor>"
              "</Source>"
              "<TestResult>"
                "<Value>80</Value>"
                "<Units>"
                  "<Unit>mg/dl</Unit>"
                "</Units>"
              "</TestResult>"
            "</Test>"
          "</Result>"
        "</Results>"
      "</Body>"
    "</ContinuityOfCareRecord>"
  "</entry>";

  NSHTTPURLResponse *response = nil;
  NSString *requestBody = strData;//[[NSString alloc] initWithFormat:strData ];

  [httpReq setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding]];
  NSData *data = nil;
  NSError *error = nil;
  NSString* responseStr;
  data = [NSURLConnection sendSynchronousRequest:httpReq
                               returningResponse:&response error:&error];
  if( [data length] >0) {
    responseStr = [[NSString alloc] initWithData:data
                                        encoding:NSASCIIStringEncoding];
    NSLog(@"Got: %@", responseStr);
  }
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
