//
//  RunKeeperDataSource.m
//  theMostAmazingFinalProject
//
//  Created by Luis Jonathan Godoy Marín on 28/05/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "RunKeeperDataSource.h"
#import "KeychainHelper.h"

static NSString * const AUTH_REQUEST_URL = @"https://runkeeper.com/apps/authorize?response_type=code&client_id=21d211d3e8d04362bf4056eca118cca6&redirect_uri=http%3A%2F%2Fwww.google.com";

static NSString * const ACCESS_TOKEN_URL = @"https://runkeeper.com/apps/token?code=%@&client_id=%@&client_secret=%@&redirect_uri=http%3A%2F%2Fwww.google.com";

static NSString * const CLIENT_ID = @"21d211d3e8d04362bf4056eca118cca6";
static NSString * const CLIENT_SECRET = @"0951b34bcd594bf59f9ce64092b8ab67";

@implementation RunKeeperDataSource

enum OPERATIONS {
    GET_TOKEN = 1,
    
    GET_USER = 2,
    GET_PROFILE = 3,
    
    GET_FITNESS_ACTIVITIES = 4,
    GET_FITNES_ACTIVITY_DETAIL = 5,
    GET_FITNESS_ACTIVITY_SUMMARY = 6,
    POST_FITNESS_ACTIVITY=7,
    
    GET_SLEEP_FEED = 8,
    GET_SLEEP_ACTIVITY = 9,
    POST_SLEEP_ACTIVITY = 10,
};

-(instancetype)init{
    self = [super init];
    if (self) {
        currentOperation = 0;
        webHandler = [[WebServiceHandler alloc] initWithDelegate:self];
    }
    return self;
}

#pragma mark - Public methods

-(void)getToken:(NSString *)CODE
{
    currentOperation = GET_TOKEN;
    [webHandler doRequest:[NSString stringWithFormat:@"https://runkeeper.com/apps/token?grant_type=authorization_code&code=%@&client_id=%@&client_secret=%@&redirect_uri=http%%3A%%2F%%2Fwww.google.com",CODE, CLIENT_ID, CLIENT_SECRET] withParameters:nil andHeaders:nil andHTTPMethod:@"POST"];
}

-(void)getFitnessActivities
{
    currentOperation = GET_FITNESS_ACTIVITIES;
    
    //Get the token from the keychain to form the header
    NSString *AUTH_TOKEN = [KeychainHelper getToken];
    NSLog(@"The retrieved token is %@", AUTH_TOKEN);
    //Form the header
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Bearer %@", AUTH_TOKEN], @"Authorization", @"application/vnd.com.runkeeper.FitnessActivityFeed+json", @"Content-Type", nil];
    [webHandler doRequest:@"http://api.runkeeper.com/fitnessActivities" withParameters:nil andHeaders:headers andHTTPMethod:@"GET"];
}

-(void)getUser
{
    currentOperation = GET_USER;
    //Get the token
    NSString *AUTH_TOKEN = [KeychainHelper getToken];
    NSLog(@"The retrieved token is %@", AUTH_TOKEN);
    //Form the header
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Bearer %@", AUTH_TOKEN], @"Authorization", @"application/vnd.com.runkeeper.User+json", @"Content-Type", nil];
    
    [webHandler doRequest:@"http://api.runkeeper.com/user/" withParameters:nil andHeaders:headers andHTTPMethod:@"GET"];
}

-(void)getProfile
{
    currentOperation = GET_PROFILE;
    //Get the token
    NSString *AUTH_TOKEN = [KeychainHelper getToken];
    NSLog(@"The retrieved token is %@", AUTH_TOKEN);
    //Form the header
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Bearer %@", AUTH_TOKEN], @"Authorization", @"application/vnd.com.runkeeper.Profile+json", @"Content-Type", nil];
    
    [webHandler doRequest:@"http://api.runkeeper.com/profile/" withParameters:nil andHeaders:headers andHTTPMethod:@"GET"];
}

-(void)postFitnessActivity:(FitnessActivity *)aFitnessActivity
{
    currentOperation = POST_FITNESS_ACTIVITY;
    
    //Get fitness activity to post
    //User will create a fitness activity object to post.
    //For now create a fitness activity object for posting.
    FitnessActivityPost *aNewActivity = [[FitnessActivityPost alloc] initDefault];
    
    //New fitness activity post created. For the header and send the message to the API
    //Get the token
    NSString *AUTH_TOKEN = [KeychainHelper getToken];
    NSLog(@"The retrieved token is %@", AUTH_TOKEN);
    //Form the header
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Bearer %@", AUTH_TOKEN], @"Authorization", @"application/vnd.com.runkeeper.NewFitnessActivity+json", @"Content-Type", nil];
    
    NSDictionary *messageBody = [NSDictionary dictionaryWithObjectsAndKeys:aNewActivity.strType,@"type", aNewActivity.strEquipment, @"equipment", aNewActivity.strStartTime, @"start_time", aNewActivity.strNotes, @"notes", aNewActivity.strTotalDistance, @"total_distance", aNewActivity.strDuration, @"duration", aNewActivity.strTotalCalories, @"total_calories", nil];
    
    [webHandler doRequest:@"http://api.runkeeper.com/fitnessActivities" withParameters:messageBody andHeaders:headers andHTTPMethod:@"POST"];
}

-(void)getSleepFeed
{
    currentOperation = GET_SLEEP_FEED;
    
    //Get the token
#warning Using hardcoded value for atuhorization token.
    //    NSString * AUTH_TOKEN = [KeychainHelper getToken];
    NSString * AUTH_TOKEN = @"3205693701f44eab893db341ae9e2f44";    NSLog(@"The retrieved token is %@", AUTH_TOKEN);
    //Form the header
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Bearer %@", AUTH_TOKEN], @"Authorization", @"application/vnd.com.runkeeper.SleepSetFeed+json", @"Accept", @"application/vnd.com.runkeeper.SleepSetFeed+json", @"Content-Type", nil];
    
    [webHandler doRequest:@"http://api.runkeeper.com/sleep" withParameters:nil andHeaders:headers andHTTPMethod:@"GET"];
}

-(void)getSleepActivity:(NSString *)sleepID
{
    currentOperation = GET_SLEEP_ACTIVITY;
    
//    Get the token
#warning Using hardcoded value for atuhorization token.
//    NSString * AUTH_TOKEN = [KeychainHelper getToken];
    NSString * AUTH_TOKEN = @"3205693701f44eab893db341ae9e2f44";
    NSLog(@"The retrieved token is %@", AUTH_TOKEN);
    //Form the header
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Bearer %@", AUTH_TOKEN], @"Authorization", @"application/vnd.com.runkeeper.SleepSet+json", @"Content-Type", nil];
    
    [webHandler doRequest:[NSString stringWithFormat:@"http://api.runkeeper.com/sleep/%@", sleepID] withParameters:nil andHeaders:headers andHTTPMethod:@"GET"];
}

-(void)postSleepActivity:(SleepActivityPost *)sleepActivity
{
    currentOperation = POST_SLEEP_ACTIVITY;
    
   //Create a sleep activity for use. It will eventually be an object generated from user input.
    SleepActivityPost *defaultSleepActivity = [[SleepActivityPost alloc] initWithDefault];
    
    //Form the API request using the token
#warning Using hardcoded value for atuhorization token.
    //    NSString * AUTH_TOKEN = [KeychainHelper getToken];
    NSString * AUTH_TOKEN = @"3205693701f44eab893db341ae9e2f44";
    NSLog(@"The retrieved token is %@", AUTH_TOKEN);
    //Form the header
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Bearer %@", AUTH_TOKEN], @"Authorization", @"application/vnd.com.runkeeper.NewSleepSet+json", @"Content-Type", nil];
    
    NSDictionary *messageBody = [NSDictionary dictionaryWithObjectsAndKeys:defaultSleepActivity.strTimestamp, @"timestamp", defaultSleepActivity.strTotalSleep, @"total_sleep", defaultSleepActivity.strDeep, @"deep", defaultSleepActivity.strREM, @"rem", defaultSleepActivity.strLight, @"light", defaultSleepActivity.strAwake, @"awake", defaultSleepActivity.strTimesWoken, @"times_woken",nil];
    
    [webHandler doRequest:@"http://api.runkeeper.com/sleep" withParameters:messageBody andHeaders:headers andHTTPMethod:@"POST"];
}



#pragma mark - WebServiceHandler delegate methods

-(void)webServiceCallFinished:(id)data
{
    NSError *error;
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error && !([[data description] isEqualToString:@"<>"]))
    {
        NSLog(@"There was an error parsing the RunKeeper JSON file");
    }
    else if (currentOperation == GET_TOKEN) {
        NSString *tokenType = [jsonObject objectForKey:@"token_type"];
        NSString *ACCESS_TOKEN = [jsonObject objectForKey:@"access_token"];
        NSLog(@"%@",tokenType);
        NSLog(@"%@",ACCESS_TOKEN);
        [KeychainHelper storeTheToken:ACCESS_TOKEN];
        
        NSLog(@"The token is: %@", [KeychainHelper getToken]);
    }
    else if (currentOperation == GET_FITNESS_ACTIVITIES)
    {
        NSMutableArray *arrFitnessActivities = [[NSMutableArray alloc] init];
        
        for (NSDictionary *aFitnessActivityDict in [jsonObject objectForKey:@"items"])
        {
            FitnessActivity *aFitnessActivity = [[FitnessActivity alloc] initWithJSONDict:aFitnessActivityDict];
            [arrFitnessActivities addObject:aFitnessActivity];
            
        }
    }
    else if (currentOperation == GET_USER)
    {
        //User object contains URIs needed for other calls.
        RunKeeperUser *rkUser = [[RunKeeperUser alloc] initWithJSONDict:jsonObject];
        
    }
    else if (currentOperation == GET_PROFILE)
    {
        //Profile object contains user personal information and location
        RunKeeperProfile *rkProfile = [[RunKeeperProfile alloc] initWithJSONDict:jsonObject];
    }
    else if (currentOperation == POST_FITNESS_ACTIVITY)
    {
        NSLog(@"Post was successfull. Diplay something notifying the user.");
    }
    else if (currentOperation == GET_SLEEP_FEED)
    {
        NSArray *SleepFeed = [jsonObject objectForKey:@"items"];
        NSLog(@"Sleep feed has been parsed. Do something useful.");
    }
    else if (currentOperation == GET_SLEEP_ACTIVITY)
    {
        SleepActivity *aSleepActvity = [[SleepActivity alloc] initWithJSONODict:jsonObject];
        NSLog(@"Sleep activity created. Store it to the database");
    }
    else if (currentOperation == POST_SLEEP_ACTIVITY)
    {
        NSLog(@"Post was successful. Display something notifying the user.");
    }
}

-(void)webServiceCallError:(NSError *)error
{
    NSLog(@"%@",error.description);
}


@end
