//
//  ScheduleWorkoutViewController.h
//  theMostAmazingFinalProject
//
//  Created by Luis Jonathan Godoy Marín on 6/4/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutManagerDataSource.h"

@interface ScheduleWorkoutViewController : UIViewController <WorkoutManagerDataSourceDelegate, UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UIActivityIndicatorView *activityView;
    NSMutableArray *schedulesArr;
    NSMutableArray *workoutsArr;
    NSMutableArray *scheduleStepsArr;
    NSMutableArray *daysArr;
    NSMutableArray *exercisesArr;
    NSMutableArray *workoutsArrFiltered;
    NSMutableArray *exercisesArrFiltered;
}

@property(strong,nonatomic) WorkoutManagerDataSource *wgerDataSource;

@end
