//
//  SettingsViewController.m
//  Matchismo
//
//  Created by Deliany Delirium on 16.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "SettingsViewController.h"
#import "GameResult.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (IBAction)clearLabelClick
{
    [self showAlertMessage];
}

- (void) showAlertMessage
{
    NSString *message = [NSString stringWithFormat:@"Are you sure want to clear all scores?"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear scores"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Cancel", nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	if ([title isEqualToString:@"OK"])
	{
        [GameResult clearAllGameScores];
	}
	else if ([title isEqualToString:@"Cancel"])
	{
        // do nothing
        
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
