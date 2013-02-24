//
//  ViewController.m
//  iMatch
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardGame.h"
#import "PlayingCard.h"
#import "GameResult.h"

@interface CardGameViewController () <UICollectionViewDataSource>

// UI outlets
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventMessageLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegmentControl;
@property (weak, nonatomic) IBOutlet UISlider *eventMessagesSlider;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;

// other properties
@property (strong, nonatomic) NSMutableArray *eventMessages;
@property (nonatomic) NSUInteger flipsCount;
@property (nonatomic) NSUInteger numberOfCardsToMatch;

@property (strong, nonatomic) CardGame *game;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) GameResult *gameResult;

@end





@implementation CardGameViewController

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.startingCardCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animate:NO];
    return cell;
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card*)card animate:(BOOL)animate
{
    // abstract
}

- (CardGame *)game
{
    if (!_game) {
        _game = [[CardGame alloc] initWithNumberOfCards:self.startingCardCount fromCardDeck:[self createDeck] andNumberOfCardsToMatch:self.numberOfCardsToMatch];
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

-(Deck*)createDeck
{
    return nil; // abstract
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

- (IBAction)flipCardClick:(UITapGestureRecognizer*)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        self.flipsCount++;
        self.gameTypeSegmentControl.enabled = NO;
        [self.game flipCardAtIndex:indexPath.item];
        [self updateUI];
    }

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
    
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells])
    {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        BOOL animated = card.faceUp ? YES : NO;
        [self updateCell:cell usingCard:card animate:animated];
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
    //self.deck = nil;
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
