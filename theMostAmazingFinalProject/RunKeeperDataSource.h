//
//  RunKeeperDataSource.h
//  theMostAmazingFinalProject
//
//  Created by Luis Jonathan Godoy Marín on 28/05/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceHandler.h"
#import "FitnessActivity.h"
#import "RunKeeperUser.h"
#import "RunKeeperProfile.h"

@interface RunKeeperDataSource : NSObject <WebServiceHandlerDelegate> {
    int currentOperation;
    WebServiceHandler *webHandler;
}

-(void)getToken:(NSString *)CODE;
-(void)getFitnessActivities;
-(void)getUser;
-(void)getProfile;



@end
