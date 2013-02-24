//
//  CardGame.m
//  iMatch
//
//  Created by Deliany Delirium on 03.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "CardGame.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface CardGame ()

@property (strong, nonatomic) NSMutableArray* cards;
@property (readwrite, nonatomic) NSInteger score;
@property (readwrite, strong, nonatomic) NSAttributedString *lastEventMessage;

@end

@implementation CardGame

-(id)init
{
    Deck *deck = [[PlayingCardDeck  alloc] init];
    return [self initWithNumberOfCards:deck.numberOfAvailableCards
                          fromCardDeck:deck
                           andNumberOfCardsToMatch:2];
}

- (id) initWithNumberOfCards:(NSUInteger)numOfCards fromCardDeck:(Deck *)deck andNumberOfCardsToMatch:(NSUInteger)gameType
{
    if(self = [super init])
    {
        // if requested card number is greater than number of cards that deck contains
        if(numOfCards > [deck numberOfAvailableCards])
        {
            return nil;
        }
        
        _lastEventMessage = [[NSAttributedString alloc] initWithString:@""];
        _cards = [NSMutableArray arrayWithCapacity:numOfCards];
        
        _numberOfCardsToMatch = gameType;
        
        for (int i = 0; i < numOfCards; ++i)
        {
            Card *drawnCard = [deck drawRandomCard];
            [_cards addObject:drawnCard];
        }
    }
    
    return self;
}

- (void)clearLastPlayedStatus
{
    for (Card* card in self.cards) {
        card.lastPlayed = NO;
    }
}

#define NOT_MATCH_PENALTY 2
#define FLIP_PENALTY 1

- (void) flipCardAtIndex:(NSUInteger) index
{
    [self clearLastPlayedStatus];
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
        self.score -= FLIP_PENALTY;
        currentCard.faceUp = !currentCard.faceUp;
        currentCard.lastPlayed = YES;
        
        if([self countOfPlayingCardsFacingUp] == self.numberOfCardsToMatch)
        {
            [self matchCardsFacingUp];
        }
    }
}

- (void)matchCardsFacingUp
{
    NSMutableArray* cardsToMatch = [[NSMutableArray alloc] init];
    NSMutableAttributedString *cardsContents = [[NSMutableAttributedString alloc] initWithString:@""];
    
    for (Card* card in self.cards)
    {
        if (card.isFaceUp && card.isPlayable)
        {
            [cardsToMatch addObject:card];
        }
    }
    
    for (Card* matchCard in cardsToMatch)
    {
        [cardsContents appendAttributedString:[matchCard attributedDescription]];
        if (![matchCard isEqual:[cardsToMatch lastObject]])
        {
            [cardsContents appendAttributedString:[[NSAttributedString alloc] initWithString:@" & "]];
        }
        
    matchCard.lastPlayed = YES;
    
    }
    
    Card* card = [cardsToMatch lastObject];
    [cardsToMatch removeObject:card];
    
    
    NSInteger matchScore = [card match:cardsToMatch];
    if (matchScore)
    {
        for (Card* card in cardsToMatch)
        {
            card.playable = NO;
        }
        card.playable = NO;
        self.score += matchScore;
        
        NSMutableAttributedString *msg = [[NSMutableAttributedString alloc] initWithAttributedString:cardsContents];
        [msg appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" match for %d points!", matchScore]]];
        
        self.lastEventMessage = [[NSAttributedString alloc] initWithAttributedString:msg];
    }
    else
    {
        for (Card* card in cardsToMatch)
        {
            card.faceUp = NO;
        }
        card.faceUp = NO;
        self.score -= NOT_MATCH_PENALTY;
        
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
    for (Card *card in self.cards)
    {
        if (card.isPlayable && card.isFaceUp)
        {
            count++;
        }
    }
    
    return count;
}

@end
