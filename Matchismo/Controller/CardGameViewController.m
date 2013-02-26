//
//  ViewController.m
//  Matchismo
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "CardGameViewController.h"
#import "SetCardGameViewController.h"
#import "CardGame.h"
#import "PlayingCard.h"
#import "GameResult.h"

@interface CardGameViewController () <UICollectionViewDataSource, UIAlertViewDelegate>

// UI outlets
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegmentControl;
@property (weak, nonatomic) IBOutlet UISlider *eventMessagesSlider;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UIView *eventMessageView;

// other properties
@property (strong, nonatomic) NSMutableArray *eventMessages;
@property (nonatomic) NSUInteger flipsCount;

@property (strong, nonatomic) CardGame *game;
@property (strong, nonatomic) GameResult *gameResult;

@end





@implementation CardGameViewController

#pragma mark Abstract methods

-(Deck*)createDeck
{
    return nil; // abstract
}

- (NSString *)gameName
{
    return nil; // abstract
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card*)card animate:(BOOL)animate
{
    // abstract
}

-(NSArray*)updateEventMessageViewStatus:(UIView*)view withCards:(NSArray*)cards andScore:(NSInteger)score
{
    return nil; // abstract
}


#pragma mark -
#pragma Properties getters or setters

- (CardGame *)game
{
    if (!_game) {
        _game = [[CardGame alloc] initWithNumberOfCards:self.startingCardsCount fromCardDeck:[self createDeck] andNumberOfCardsToMatch:self.countOfCardsToMatch];
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


- (void) setCountOfCardsToMatch:(NSUInteger)numberOfCardsToMatch
{
    _countOfCardsToMatch = numberOfCardsToMatch;
    self.game.countOfCardsToMatch = _countOfCardsToMatch;
}


#pragma mark -
#pragma UICollectionViewDataSource methods

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return [self.game countOfCardsInGame];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animate:NO];
    return cell;
}


#pragma mark -
#pragma UI interaction methods

- (IBAction)flipCardClick:(UITapGestureRecognizer*)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        self.flipsCount++;
        self.gameTypeSegmentControl.enabled = NO;
        [self.game flipCardAtIndex:indexPath.item];
        
        if (self.game.countOfUnplayableCards > 0 && [self isKindOfClass:[SetCardGameViewController class]])
        {
            [self.cardCollectionView deleteItemsAtIndexPaths:[self.game removeUnplayableCards]];
        }
        [self updateUI];
    }

}

- (void) updateUI
{
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.game.score]];
    self.gameResult.score = self.game.score;
    
    NSArray *viewsArray = [self updateEventMessageViewStatus:self.eventMessageView withCards:[self.game.flippedCardsHistoryArray lastObject] andScore:self.game.lastMatchScore];
    
    [self.eventMessages addObject:viewsArray];//self.game.lastEventMessage];
    
    self.eventMessagesSlider.maximumValue = [self.eventMessages count];
    self.eventMessagesSlider.value = self.eventMessagesSlider.maximumValue;
    
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells])
    {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        BOOL animated = card.lastPlayed ? YES : NO;
        [self updateCell:cell usingCard:card animate:animated];
    }
}

- (IBAction)eventMessagesHistorySlide
{
    NSUInteger pos = (int)self.eventMessagesSlider.value;
    if(pos < [self.eventMessages count])
    {
        for (UIView *subView in self.eventMessageView.subviews) {
            [subView removeFromSuperview];
        }
        for (UIView* subView in self.eventMessages[pos]) {
            [subView setAlpha:0.5];
            [self.eventMessageView addSubview:subView];
        }
    }
}

- (IBAction)gameTypeClick
{
    self.countOfCardsToMatch = self.gameTypeSegmentControl.selectedSegmentIndex + 2;
}

- (IBAction)requestMoreCardsClick
{
    if ([self.game countOfCardsInDeck] > 0) {
        [self.game increaseNumberOfCardsUpTo:3];
        [self.cardCollectionView reloadData];
        
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.game.countOfCardsInGame - 1 inSection:0];
        [self.cardCollectionView scrollToItemAtIndexPath:scrollIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty deck"
                                                        message:@"Deck is empty, you cannot request more cards from it"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];

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
}

- (void)restartGame
{
    self.game = nil;
    self.gameResult = nil;
    
    self.flipsCount = 0;
    self.eventMessagesSlider.maximumValue = 0;
    self.gameTypeSegmentControl.enabled = true;
    
    [self.eventMessages removeAllObjects];
    [self.cardCollectionView reloadData];
    [self updateUI];
}

@end
