//
//  ViewController.m
//  iMatch
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardGame.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "GameResult.h"

@interface CardGameViewController ()

// UI outlets
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventMessageLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegmentControl;
@property (weak, nonatomic) IBOutlet UISlider *eventMessagesSlider;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *playingCardButtons;

// other properties
@property (strong, nonatomic) NSMutableArray *eventMessages;
@property (nonatomic) NSUInteger flipsCount;
@property (nonatomic) NSUInteger numberOfCardsToMatch;

@property (strong, nonatomic) CardGame *game;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) GameResult *gameResult;

@end





@implementation CardGameViewController

- (Deck *)deck
{
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    return _deck;
}

- (CardGame *)game
{
    if (!_game) {
        _game = [[CardGame alloc] initWithNumberOfCards:[self.playingCardButtons count] fromCardDeck:self.deck andNumberOfCardsToMatch:self.numberOfCardsToMatch];
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

- (NSMutableArray *)eventMessages
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


- (void) setNumberOfCardsToMatch:(NSUInteger)numberOfCardsToMatch
{
    _numberOfCardsToMatch = numberOfCardsToMatch;
    self.game.numberOfCardsToMatch = _numberOfCardsToMatch;
}

- (IBAction)flipCardClick:(UIButton *)sender
{
    self.flipsCount++;
    self.gameTypeSegmentControl.enabled = NO;
    
    [self.game flipCardAtIndex:[self.playingCardButtons indexOfObject:sender]];
    [self updateUI];
}

- (void) updateUI
{
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
    self.gameResult.score = self.game.score;
    
    [self.eventMessages addObject:self.game.lastEventMessage];
    
    self.eventMessagesSlider.maximumValue = [self.eventMessages count];
    self.eventMessagesSlider.value = self.eventMessagesSlider.maximumValue;
    
    [self.eventMessageLabel setAttributedText:self.game.lastEventMessage];
    [self.eventMessageLabel setAlpha:1];
    
    for (UIButton *button in self.playingCardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.playingCardButtons indexOfObject:button]];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setTitle:[card description] forState:UIControlStateSelected];
        [button setTitle:[card description] forState:UIControlStateSelected | UIControlStateDisabled];
        
        if(card.isFaceUp)
        {
            [button setBackgroundImage:nil forState:UIControlStateNormal];
        }
        else
        {
            [button setBackgroundImage:[UIImage imageNamed:@"cardback.jpg"] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        }
        button.selected = card.isFaceUp;
        button.enabled = card.playable;
        button.alpha = card.isPlayable ? 1 : 0.3;
    }
}

- (IBAction)eventMessagesHistorySlide
{
    NSUInteger pos = (int)self.eventMessagesSlider.value;
    if(pos < [self.eventMessages count])
    {
        [self.eventMessageLabel setAttributedText:self.eventMessages[pos]];
        [self.eventMessageLabel setAlpha:0.5];
    }
}

- (IBAction)gameTypeClick
{
    self.numberOfCardsToMatch = self.gameTypeSegmentControl.selectedSegmentIndex + 2;
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
    self.gameTypeSegmentControl.enabled = true;
    
    [self.eventMessages removeAllObjects];
    [self updateUI];
}

- (NSString *)gameName
{
    return @"Card Game";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-card-game.jpg"]]];
    
    self.numberOfCardsToMatch = 2;
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
