//
//  SetGameViewController.m
//  iMatch
//
//  Created by Deliany Delirium on 07.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "CardGame.h"
#import "SetDeck.h"
#import "SetCard.h"
#import "GameResult.h"
#import <QuartzCore/QuartzCore.h>

@interface SetCardGameViewController ()

// UI outlets
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *playingSetButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISlider *eventMessagesSlider;

// other properties
@property (strong, nonatomic) NSMutableArray *eventMessages;
@property (nonatomic) NSUInteger flipsCount;

@property (strong, nonatomic) CardGame *game;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) GameResult *gameResult;

@end





@implementation SetCardGameViewController

- (Deck *)deck
{
    if (!_deck) {
        _deck = [[SetDeck alloc] init];
    }
    return _deck;
}

#define CARD_TO_MATCH 3

- (CardGame *)game
{
    if (!_game) {
        _game = [[CardGame alloc] initWithNumberOfCards:[self.playingSetButtons count] fromCardDeck:self.deck andNumberOfCardsToMatch:CARD_TO_MATCH];
    }
    return _game;
}

- (GameResult *)gameResult
{
    if (!_gameResult) {
        _gameResult = [[GameResult alloc] initWithGameName:[self gameName]];
    }
    return _gameResult;
}

-(NSMutableArray *)eventMessages
{
    if (!_eventMessages) {
        _eventMessages = [NSMutableArray array];
    }
    return _eventMessages;
}

- (void)setFlipsCount:(NSUInteger)flipsCount
{
    _flipsCount = flipsCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %u", flipsCount];
}

- (void)updateUI
{
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
    self.gameResult.score = self.game.score;
    
    [self.eventMessages addObject:self.game.lastEventMessage];
    
    self.eventMessagesSlider.maximumValue = [self.eventMessages count];
    self.eventMessagesSlider.value = self.eventMessagesSlider.maximumValue;
    
    [self.eventMessageLabel setAttributedText:self.game.lastEventMessage];
    [self.eventMessageLabel setAlpha:1];
    
    for (UIButton *button in self.playingSetButtons)
    {
        Card *card = [self.game cardAtIndex:[self.playingSetButtons indexOfObject:button]];
        [button setAttributedTitle:[card attributedDescription] forState:UIControlStateNormal];
        [button setAttributedTitle:[card attributedDescription] forState:UIControlStateSelected];
        [button setAttributedTitle:[card attributedDescription] forState:UIControlStateSelected | UIControlStateDisabled];

        button.backgroundColor = card.isFaceUp ? [UIColor lightGrayColor] : [UIColor whiteColor];
        button.enabled = card.playable;
        button.alpha = card.isPlayable ? 1 : 0.1;
    }
}

- (IBAction)selectSetCard:(UIButton *)sender
{
    self.flipsCount++;
    [self.game flipCardAtIndex:[self.playingSetButtons indexOfObject:sender]];
    [self updateUI];
}

- (IBAction)eventMessagesHistorySlide
{
    NSUInteger pos = (int)self.eventMessagesSlider.value;
    if(pos < [self.eventMessages count])
    {
        [self.eventMessageLabel setText:self.eventMessages[pos]];
        [self.eventMessageLabel setAlpha:0.5];
    }
}

- (IBAction)dealClick
{
    [self showAlertMessage];
}

- (void) showAlertMessage
{
    NSString *message = [NSString stringWithFormat:@"Are you sure want to start a new game?"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New game"
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
        [self restartGame];
	}
	else if ([title isEqualToString:@"Cancel"])
	{
        // do nothing
        
	}
}

- (void)restartGame
{
    self.deck = nil;
    self.game = nil;
    self.gameResult = nil;
    
    self.flipsCount = 0;
    self.eventMessagesSlider.maximumValue = 0;
    
    [self.eventMessages removeAllObjects];
    [self updateUI];
}

- (NSString *)gameName
{
    return @"Set Card Game";
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
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-set-game.jpg"]]];
    
    // code for making rounded corners of our custom buttons, quartz2d required for this code
    for (UIButton *button in self.playingSetButtons)
    {
        button.layer.cornerRadius = 7.0f;
        button.layer.masksToBounds = YES;
    }
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
