//
//  ExerciseSelectionViewController.m
//  theMostAmazingFinalProject
//
//  Created by Luis Jonathan Godoy Marín on 6/3/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "ExerciseSelectionViewController.h"
#import "BackgroundViewHelper.h"
#import "wgerSQLiteDataSource.h"
#import "ExerciseTableViewCell.h"

@interface ExerciseSelectionViewController ()

@end

@implementation ExerciseSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    wgerSQLiteDataSource *dataSource = [wgerSQLiteDataSource new];
    NSLog(@"%@",[dataSource getExercisesForMuscle:[self.muscleDic objectForKey:@"id"]]);
    [exerciseTableView registerNib:[UINib nibWithNibName:@"ExerciseTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [BackgroundViewHelper getSharedInstance].assignedView = self.view;
    [[BackgroundViewHelper getSharedInstance] start];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableView DataSource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return exercises.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    NSDictionary *muscleDic = [exercises objectAtIndex:indexPath.row];
    ExerciseTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setupCellWithData:muscleDic];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67.0;
}

#pragma mark - UITableView Delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *muscleDic = [exercises objectAtIndex:indexPath.row];
//    ExerciseSelectionViewController *exerVC = [[ExerciseSelectionViewController alloc] init];
//    exerVC.muscleDic = muscleDic;
//    [self.navigationController pushViewController:exerVC animated:YES];
}


@end
