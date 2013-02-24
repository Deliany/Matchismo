//
//  GameScoresViewController.m
//  Matchismo
//
//  Created by Deliany Delirium on 15.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "GameScoresViewController.h"
#import "GameResult.h"

@interface GameScoresViewController ()

@property (weak, nonatomic) IBOutlet UITextView *gameResultsTextView;

@end

@implementation GameScoresViewController

-(void) updateUI{
    NSString *displayText = @"";
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm MMM dd"];
    
    
    for(GameResult *result in [GameResult allGameResults]){
        NSString* formattedDate = [formatter stringFromDate:result.end];
        displayText = [displayText stringByAppendingFormat:@"%@ Score: %d ( %@ for %g sec)\n",result.gameName, result.score, formattedDate, round(result.duration)];
    }
    if([displayText length]==0){
        displayText = @"There's no Game Scores available! Keep playing!";
    }
    self.gameResultsTextView.text = displayText;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
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
