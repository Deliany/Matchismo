//
//  SettingsTableViewController.m
//  Matchismo
//
//  Created by Deliany Delirium on 27.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "PlayingCardDeck.h"
#import "GameResult.h"

@interface SettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countOfDealedCardsLabel;
@property (nonatomic) NSUInteger playingCardsAmount;
@end

@implementation SettingsTableViewController

- (void)setPlayingCardsAmount:(NSUInteger)playingCardsAmount
{
    _playingCardsAmount = playingCardsAmount;
    self.countOfDealedCardsLabel.text = [NSString stringWithFormat:@"%d",playingCardsAmount];
}

- (void) showClearAlertMessage
{
    NSString *message = [NSString stringWithFormat:@"Are you sure want to clear all scores?"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear scores"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Cancel", nil];
    alert.tag = 0;
    
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    switch (alertView.tag) {
        case 0:
        {
            if ([title isEqualToString:@"OK"])
            {
                [GameResult clearAllGameScores];
            }
        }
            break;
            
        case 1:
        {
            if ([title isEqualToString:@"Confirm"])
            {
                NSString* enteredAmount = [[alertView textFieldAtIndex:0] text];
                NSInteger newAmount = [enteredAmount integerValue];
                if (newAmount > 0 && newAmount <= [PlayingCardDeck maxCardsAmount])
                {
                    self.playingCardsAmount = newAmount;
                    [self synchronize];
                }
            }
        }
            
        default:
            break;
    }
	
}

- (void) showEditAlert
{
    NSString *message = [NSString stringWithFormat:@"Please, enter new amount playing cards"];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Number of playing cards"
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:@"Confirm"
                                           otherButtonTitles:@"Cancel", nil];
    alert.tag = 1;    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"Cards amount";
    
    [alert show];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self showClearAlertMessage];
    }
    else if (indexPath.row == 1) {
        [self showEditAlert];        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#define PLAYING_CARDS_AMOUNT_KEY @"Playing_cards_amount"

- (void)synchronize
{    
    [[NSUserDefaults standardUserDefaults] setInteger:self.playingCardsAmount forKey:PLAYING_CARDS_AMOUNT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) loadSettings
{
    self.playingCardsAmount = [[NSUserDefaults standardUserDefaults] integerForKey:PLAYING_CARDS_AMOUNT_KEY];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadSettings];
}

@end
