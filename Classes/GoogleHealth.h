//
//  GoogleHealth.h
//  Health Hacker
//
//  Created by Morgan Schweers on 6/25/10.
//  Copyright 2010 CyberFOX Software, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataHealth.h"

@protocol GoogleHealthNotifier
- (void)gdataUpdated;
@end


@interface GoogleHealth : NSObject {
  GDataFeedBase *mProfileListFeed;
  BOOL mIsProfileListFetchPending;
  NSError *mProfileListFetchError;

  GDataFeedHealthProfile *mProfileFeed;
  BOOL mIsProfileFetchPending;
  NSError *mProfileFetchError;

  GDataFeedHealthRegister *mRegisterFeed;
  BOOL mIsRegisterFetchPending;
  NSError *mRegisterFetchError;

  Class mServiceClass;
  id mDelegate;

  NSString *username;
  NSString *password;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

- (id)initWithDelegate:(id)delegate;

- (GDataServiceGoogleHealth *)healthService;
- (GDataEntryBase *)selectedProfileListEntry:(int)index;
- (GDataEntryHealthProfile *)selectedProfile:(int)index;
- (GDataEntryHealthRegister *)selectedRegister:(int)index;

- (void)fetchFeedOfProfileList;
- (void)fetchSelectedProfile:(int)index;
- (GDataFeedBase *)profileListFeed;
- (GDataFeedHealthProfile *)profileFeed;
- (GDataFeedHealthRegister *)registerFeed;

- (NSString *)getProfileAt:(int)index;
- (NSString *)getEntryAt:(int)index;
- (NSString *)getRegisterAt:(int)index;

- (void)sendNotice;

@end
