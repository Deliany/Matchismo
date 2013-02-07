//
//  ViewController.m
//  iMatch
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "ViewController.h"
#import "CardGame.h"

@interface ViewController ()

// UI outlets
@property (weak, nonatomic) IBOutlet UILabel *labelFlips;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentControl;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventMessagelabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegmentControl;
@property (weak, nonatomic) IBOutlet UISlider *eventMessagesSlider;

@property (strong, nonatomic) NSMutableArray *playingCardButtons;
@property (strong, nonatomic) NSMutableArray *eventMessages;
@property (nonatomic) NSUInteger flipsCount;
@property (nonatomic) NSUInteger difficulty; // 0 - easy, 1 - medium
@property (nonatomic) NSUInteger gameType; // 0 - 2-card game, 1 - 3-card game

@property (strong, nonatomic) CardGame *game;

@end

@implementation ViewController

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
    self.labelFlips.text = [NSString stringWithFormat:@"Flips: %u", flipsCount];
}

- (NSMutableArray *)playingCardButtons
{
    if(!_playingCardButtons)
    {
        _playingCardButtons = [[NSMutableArray alloc] init];
    }
    
    return _playingCardButtons;
}


- (void) setGameType:(NSUInteger)gameType
{
    _gameType = gameType;
    self.game.gameType = _gameType;
}

- (void)setDifficulty:(NSUInteger)difficulty
{
    _difficulty = difficulty;
    // easy difficulty
    if (self.difficulty == 0)
    {
        [self createButtonsWithRows:4 andCols:4];
    }
    else if (self.difficulty == 1) // medium difficulty
    {
        [self createButtonsWithRows:5 andCols:5];
    }
}

- (void)createButtonsWithRows:(NSUInteger)rows andCols:(NSUInteger)cols
{
    // remove buttons from view
    for (UIButton *button in self.playingCardButtons)
    {
        [button removeFromSuperview];
    }
    
    // and clear array
    [self.playingCardButtons removeAllObjects];
    
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            // X+100 Y+120 Z K
            button.frame = CGRectMake(150 + 50*(5-cols) + 100*j, 120 + 120*i, 70, 100);
            [button setBackgroundImage:[UIImage imageNamed:@"cardback.jpg"] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
            [button addTarget:self action:@selector(flipCardClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.playingCardButtons addObject:button];
            // add to view to make it visible
            [self.view addSubview:button];
        }
    }
    
    // init standart 52-cards deck
    Deck* deck = [[PlayingDeck alloc] init];
    // create game with number of cards equals to number of stored buttons
    self.game = [[CardGame alloc] initWithNumberOfCards:[self.playingCardButtons count] fromCardDeck: deck andGameType:self.gameType];
    
    [self updateUI];
}

- (void) updateUI
{
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
    [self.eventMessages addObject:self.game.lastEventMessage];
    self.eventMessagesSlider.maximumValue += 1;
    [self.eventMessagesSlider setValue:self.eventMessagesSlider.maximumValue animated:NO];
    
    [self.eventMessagelabel setText:self.game.lastEventMessage];
    [self.eventMessagelabel setTextColor:[UIColor blackColor]];
    for (UIButton *button in self.playingCardButtons) {
        Card *card = [self.game cardAtIndex:[self.playingCardButtons indexOfObject:button]];
        [button setTitle:card.description forState:UIControlStateSelected];
        [button setTitle:card.description forState:UIControlStateSelected | UIControlStateDisabled];
        
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
        self.difficulty = [self.difficultySegmentControl selectedSegmentIndex];        
        
        self.flipsCount = 0;
        [self.eventMessages removeAllObjects];
        self.eventMessagesSlider.maximumValue = 0;
        self.gameTypeSegmentControl.enabled = true;
	}
	else if ([title isEqualToString:@"Cancel"])
	{        
        // switch to previous difficulty
        [self.difficultySegmentControl setSelectedSegmentIndex:self.difficulty];
        
	}
}

- (IBAction)gameTypeClick
{
    self.gameType = self.gameTypeSegmentControl.selectedSegmentIndex;
}

- (IBAction)difficultyChangeClick
{
    [self restartGame];
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
        [self.eventMessagelabel setText:self.eventMessages[pos]];
        [self.eventMessagelabel setTextColor:[UIColor grayColor]];
    }
}

- (void)restartGame
{
    NSArray *difficulties = @[@"easy", @"medium"];
    NSString *message = [NSString stringWithFormat:@"Are you sure want to start a new game on %@ difficulty?", difficulties[self.difficultySegmentControl.selectedSegmentIndex]];
    
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
    self.view.backgroundColor = [UIColor clearColor];
    
    [self createButtonsWithRows:4 andCols:4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
