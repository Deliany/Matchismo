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

@end





@implementation CardGameViewController

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


- (void) setNumberOfCardsToMatch:(NSUInteger)numberOfCardsToMatch
{
    _numberOfCardsToMatch = numberOfCardsToMatch;
    self.game.numberOfCardsToMatch = _numberOfCardsToMatch;
}

- (void)initDeckAndGame
{
    
    // init standart 52-cards deck
    Deck* deck = [[PlayingCardDeck alloc] init];
    // create game with number of cards equals to number of stored buttons
    self.game = [[CardGame alloc] initWithNumberOfCards:[self.playingCardButtons count] fromCardDeck: deck andNumberOfCardsToMatch:self.numberOfCardsToMatch];
    
    [self updateUI];
}

- (void) updateUI
{
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
    [self.eventMessages addObject:self.game.lastEventMessage];
    self.eventMessagesSlider.maximumValue += 1;
    [self.eventMessagesSlider setValue:self.eventMessagesSlider.maximumValue animated:NO];
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	// the user clicked one of the OK/Cancel buttons
	if ([title isEqualToString:@"OK"])
	{      
        self.flipsCount = 0;
        [self.eventMessages removeAllObjects];
        self.eventMessagesSlider.maximumValue = 0;
        self.gameTypeSegmentControl.enabled = true;
        [self initDeckAndGame];
	}
	else if ([title isEqualToString:@"Cancel"])
	{        
        // do nothing
        
	}
}

- (IBAction)gameTypeClick
{
    self.numberOfCardsToMatch = self.gameTypeSegmentControl.selectedSegmentIndex + 2;
}

- (IBAction)dealClick
{
    [self restartGame];
}
- (IBAction)eventMessagesHistorySlide
{
    int pos = (int)self.eventMessagesSlider.value;
    if(pos < [self.eventMessages count])
    {
        [self.eventMessageLabel setAttributedText:self.eventMessages[pos]];
        [self.eventMessageLabel setAlpha:0.5];
    }
}

- (void)restartGame
{
    NSString *message = [NSString stringWithFormat:@"Are you sure want to start a new game ?"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New game"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Cancel", nil];
	[alert show];
}

- (IBAction)flipCardClick:(UIButton *)sender
{
    self.gameTypeSegmentControl.enabled = NO;
    [self.game flipCardAtIndex:[self.playingCardButtons indexOfObject:sender]];
    [self updateUI];
    self.flipsCount++;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-card-game.jpg"]]];
    
    self.numberOfCardsToMatch = 2;
    [self initDeckAndGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
