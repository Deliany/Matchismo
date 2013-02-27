//
//  CardGame.m
//  Matchismo
//
//  Created by Deliany Delirium on 03.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "CardGame.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface CardGame ()

@property (strong, nonatomic) Deck* deck;
@property (strong, nonatomic) NSMutableArray* cards;
@property (readwrite, nonatomic) NSInteger score;
@property (readwrite, nonatomic) NSInteger lastMatchScore;
@property (readwrite, strong, nonatomic) NSAttributedString *lastEventMessage;
@property (readwrite, strong, nonatomic) NSMutableArray *flippedCardsHistoryArray;
@property (readwrite, strong, nonatomic) NSMutableArray *matchedCardsArray;

@end

@implementation CardGame

- (id) initWithNumberOfCards:(NSUInteger)numOfCards fromCardDeck:(Deck *)deck andNumberOfCardsToMatch:(NSUInteger)numOfCardsToMatch
{
    if(self = [super init])
    {
        // if requested card number is greater than number of cards that deck contains
        if(numOfCards > [deck countOfAvailableCards])
        {
            return nil;
        }
        
        _deck = deck;
        _cards = [NSMutableArray arrayWithCapacity:numOfCards];
        _lastEventMessage = [[NSAttributedString alloc] initWithString:@""];
        _flippedCardsHistoryArray = [NSMutableArray array];
        _matchedCardsArray = [NSMutableArray array];
        
        _countOfCardsToMatch = numOfCardsToMatch;
        
        for (int i = 0; i < numOfCards; ++i)
        {
            Card *drawnCard = [deck drawRandomCard];
            [_cards addObject:drawnCard];
        }
    }
    
    return self;
}

#define NOT_MATCH_PENALTY -2
#define FLIP_PENALTY -1

- (void) flipCardAtIndex:(NSUInteger) index
{
    // clear last played status from all cards
    [self clearLastPlayedStatus];
    self.lastMatchScore = 0;
    
    Card *currentCard = [self cardAtIndex:index];
        
    if (currentCard && currentCard.isPlayable)
    {
        if (currentCard.isFaceUp)
        {
            self.lastEventMessage = [[NSAttributedString alloc] initWithString:@""];
        }
        else
        {
            NSMutableAttributedString *msg = [[NSMutableAttributedString alloc] initWithString:@"Flipped up "];
            [msg appendAttributedString:[currentCard attributedDescription]];
            
            self.lastEventMessage = [[NSAttributedString alloc] initWithAttributedString:msg];
        }
        self.score += FLIP_PENALTY;
        currentCard.faceUp = !currentCard.faceUp;
        
        // mark current card as last played
        currentCard.lastPlayed = YES;
        
        // copy cards content to history array
        // if flipped card is only one that facing up, then create new array
        // else copy card to last created array
        if ([self countOfPlayingCardsFacingUp] <= 1) {
            [self.flippedCardsHistoryArray addObject:[NSMutableArray arrayWithObject:[currentCard copy]]];
        }
        else if ([self countOfPlayingCardsFacingUp] > 1) {
            NSMutableArray *lastCards = [self.flippedCardsHistoryArray lastObject];
            [lastCards addObject:[currentCard copy]];
        }
        
        if([self countOfPlayingCardsFacingUp] == self.countOfCardsToMatch)
        {
            [self matchCardsFacingUp];
        }
    }
}

- (void)matchCardsFacingUp
{
    NSMutableArray* cardsToMatch = [[NSMutableArray alloc] init];
    NSMutableAttributedString *cardsContents = [[NSMutableAttributedString alloc] initWithString:@""];
    
    for (Card* card in self.cards) {
        if (card.isFaceUp && card.isPlayable) {
            [cardsToMatch addObject:card];
        }
    }
    
    // form an attributed string of cards facing up
    for (Card* matchCard in cardsToMatch)
    {
        [cardsContents appendAttributedString:[matchCard attributedDescription]];
        if (![matchCard isEqual:[cardsToMatch lastObject]])
        {
            [cardsContents appendAttributedString:[[NSAttributedString alloc] initWithString:@" & "]];
        }
        // mark all cards that facing up as last played
        matchCard.lastPlayed = YES;
    
    }
    
    // extract one card to compare with others
    Card* card = [cardsToMatch lastObject];
    [cardsToMatch removeObject:card];
    
    
    NSInteger matchScore = [card match:cardsToMatch];
    
    
    // match!
    if (matchScore)
    {
        self.lastMatchScore = matchScore;
        
        for (Card* card in cardsToMatch) {
            card.playable = NO;
            [self.matchedCardsArray addObject:[card copy]];
        }
        card.playable = NO;
        [self.matchedCardsArray addObject:[card copy]];
        self.score += matchScore;
        
        NSMutableAttributedString *msg = [[NSMutableAttributedString alloc] initWithAttributedString:cardsContents];
        [msg appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" match for %d points!", matchScore]]];
        
        self.lastEventMessage = [[NSAttributedString alloc] initWithAttributedString:msg];
    }
    else // not match!
    {
        self.lastMatchScore = NOT_MATCH_PENALTY;
        
        for (Card* card in cardsToMatch) {
            card.faceUp = NO;
        }
        card.faceUp = NO;
        self.score += NOT_MATCH_PENALTY;
        
        NSMutableAttributedString *msg = [[NSMutableAttributedString alloc] initWithAttributedString:cardsContents];
        [msg appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %d points penalty", NOT_MATCH_PENALTY]]];
        self.lastEventMessage = [[NSAttributedString alloc] initWithAttributedString:msg];
    }
}

- (Card*) cardAtIndex:(NSUInteger) index
{
    return index < [self.cards count] ? self.cards[index] : nil;
}

- (NSUInteger)countOfPlayingCardsFacingUp
{
    NSUInteger count = 0;
    for (Card *card in self.cards) {
        if (card.isPlayable && card.isFaceUp) {
            count++;
        }
    }
    
    return count;
}

- (NSUInteger)countOfCardsInGame
{
    return [self.cards count];
}

- (NSUInteger)countOfCardsInDeck
{
    return [self.deck countOfAvailableCards];
}

- (NSUInteger)countOfUnplayableCards
{
    NSUInteger count = 0;
    for (Card *card in self.cards) {
        if (card.isPlayable == NO) {
            count++;
        }
    }
    
    return count;
}

- (void)clearLastPlayedStatus
{
    for (Card* card in self.cards) {
        card.lastPlayed = NO;
    }
}

- (NSArray*)removeUnplayableCards
{
    NSIndexSet* indexSet = [self.cards indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[Card class]]) {
            Card* card = (Card*)obj;
            if(card.isPlayable == NO) {
                return true;
            }
        }
        return false;
    }];
    
    NSArray *cardsToDelete = [self.cards objectsAtIndexes:indexSet];
    
    NSMutableArray *arrayOfIndexPathsOfDeletedCards = [NSMutableArray array];
    for (Card *card in cardsToDelete) {
        [arrayOfIndexPathsOfDeletedCards addObject:[NSIndexPath indexPathForItem:[self.cards indexOfObject:card] inSection:0]];
    }

    [self.cards removeObjectsAtIndexes:indexSet];
    
    return arrayOfIndexPathsOfDeletedCards;
}

- (void)increaseNumberOfCardsUpTo:(NSUInteger)numberOfCards
{
    for (int i = 0; i < numberOfCards; ++i) {
        Card *drawnCard = [self.deck drawRandomCard];
        if (drawnCard) {
            [self.cards addObject:drawnCard];
        }
    }
}

@end
