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

@end





@implementation SetCardGameViewController

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
    [self.eventMessages addObject:self.game.lastEventMessage];

    self.eventMessagesSlider.maximumValue += 1;
    [self.eventMessagesSlider setValue:self.eventMessagesSlider.maximumValue animated:NO];

    [self.eventMessageLabel setAttributedText:self.game.lastEventMessage];
    [self.eventMessageLabel setAlpha:1];
    
    for (UIButton *button in self.playingSetButtons)
    {
        SetCard *card = (SetCard*)[self.game cardAtIndex:[self.playingSetButtons indexOfObject:button]];
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
    [self.game flipCardAtIndex:[self.playingSetButtons indexOfObject:sender]];
    [self updateUI];
    self.flipsCount++;
}


- (IBAction)dealClick
{
    [self restartGame];
}

- (void)restartGame
{
    NSString *message = @"Are you sure want to start a new game";
    
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
	// the user clicked one of the OK/Cancel buttons
	if ([title isEqualToString:@"OK"])
	{
        [self startNewGame];
        
	}
	else if ([title isEqualToString:@"Cancel"])
	{
        // do nothing
	}
}

- (void)startNewGame
{
    // init standart 81-cards deck
    Deck* deck = [[SetDeck alloc] init];
    
    // create game with number of cards equals to number of stored buttons
    self.game = [[CardGame alloc] initWithNumberOfCards:[self.playingSetButtons count] fromCardDeck: deck andNumberOfCardsToMatch:3];
    
    self.flipsCount = 0;
    [self.eventMessages removeAllObjects];
    self.eventMessagesSlider.maximumValue = 0;
    
    [self updateUI];
}

- (IBAction)eventMessagesHistorySlide
{
    int pos = (int)self.eventMessagesSlider.value;
    if(pos < [self.eventMessages count])
    {
        [self.eventMessageLabel setText:self.eventMessages[pos]];
        [self.eventMessageLabel setAlpha:0.5];
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
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-set-game.jpg"]]];
    
    // code for making rounded corners of our custom buttons
    for (UIButton *button in self.playingSetButtons)
    {
        button.layer.cornerRadius = 7.0f;
        button.layer.masksToBounds = YES;
    }
    
    [self startNewGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
