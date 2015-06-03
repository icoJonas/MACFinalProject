//
//  RecipeViewController.m
//  theMostAmazingFinalProject
//
//  Created by Mac on 6/2/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "RecipeViewController.h"
#import "BackgroundViewHelper.h"
#import "ImageHelper.h"
#import "IngredientsTableViewController.h"
#import "DirectionsViewController.h"
#import "WebViewController.h"

@interface RecipeViewController ()

@end

@implementation RecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navNavbar.title = self.recipeToDisplay.strRecipeTitle;
//    self.lblTitle.text = self.recipeToDisplay.strRecipeTitle;
    self.lblCategory.text = [NSString stringWithFormat:@"Category: %@",self.recipeToDisplay.strRecipeCategory];
    self.lblCuisine.text = [NSString stringWithFormat:@"Cuisine: %@", self.recipeToDisplay.strRecipeCuisine];
    self.lblMainIngredient.text = [NSString stringWithFormat:@"Main ingredient: %@",self.recipeToDisplay.strRecipePrimaryIngredient];;
    self.lblPrepTime.text = [NSString stringWithFormat:@"Prep time: %@ minutes",self.recipeToDisplay.strRecipeTotalMinutes];
    self.lblRating.text = [NSString stringWithFormat:@"%g/5 stars", [self.recipeToDisplay.strRecipeStarRating floatValue]];
    self.lblYield.text = [NSString stringWithFormat:@"Yields: %@ %@", self.recipeToDisplay.strRecipeYieldNumber, self.recipeToDisplay.strRecipeYieldUnit];
    
//    [ImageHelper setImage:self.imgRecipeImage FromPath:self.recipeToDisplay.strRecipeImageURL];
    dispatch_queue_t tempQueue = dispatch_queue_create("tempQueue", nil);
    dispatch_async(tempQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //Resize the image  
            UIImage *tempImage =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.recipeToDisplay.strRecipeImageURL]]];
            UIImage *tempImage2 = nil;
            CGSize targetSize = CGSizeMake(276,276);
            UIGraphicsBeginImageContext(targetSize);
            
            CGRect thumbnailRect = CGRectMake(22, 44, 276, 276);
            thumbnailRect.origin = CGPointMake(0.0,0.0);
            thumbnailRect.size.width  = targetSize.width;
            thumbnailRect.size.height = targetSize.height;
            
            [tempImage drawInRect:thumbnailRect];
            
            tempImage2 = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();

            //Load the new image
            self.imgRecipeImage.image = tempImage2;
            
            NSLog(@"The size of the image is: %@", NSStringFromCGSize(self.imgRecipeImage.image.size));
            NSLog(@"The frame of the image is: %@", NSStringFromCGRect(self.imgRecipeImage.frame));
        });
    });
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

- (IBAction)btnBackPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnBookmarkPressed:(id)sender
{
    //Download the recipe and save it to the database
//    self.recipeToDisplay saveTo
}

- (IBAction)btnIngredientsPressed:(id)sender
{
    //Load a popover with a scrollable table view of ingredients
    IngredientsTableViewController *itvc = [[IngredientsTableViewController alloc] initWithNibName:@"IngredientsTableViewController" bundle:nil];
    itvc.currentRecipe = self.recipeToDisplay;

    itvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:itvc animated:YES completion:nil];
}

- (IBAction)btnDirectionsPressed:(id)sender
{
    DirectionsViewController *dvc = [[DirectionsViewController alloc] initWithNibName:@"DirectionsViewController" bundle:nil];
    dvc.currentRecipe = self.recipeToDisplay;
    
    dvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:dvc animated:YES completion:nil];
}

- (IBAction)btnWebpagePressed:(id)sender
{
    WebViewController *wvc = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    wvc.currentRecipe = self.recipeToDisplay;
    
    wvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:wvc animated:YES completion:nil];
}

@end
