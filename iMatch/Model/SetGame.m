//
//  SetGame.m
//  iMatch
//
//  Created by Deliany Delirium on 08.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "SetGame.h"
#import "SetDeck.h"
#import "SetCard.h"

@interface SetGame ()

@property (strong, nonatomic) NSMutableArray* cards;
@property (readwrite, nonatomic) int score;
@property (readwrite, strong, nonatomic) NSString *lastEventMessage;

@end

@implementation SetGame

- (id)init
{
    Deck *deck = [[SetDeck  alloc] init];
    return [self initWithNumberOfCards:deck.numberOfAvailableCards fromCardDeck:deck];
}

- (id)initWithNumberOfCards:(NSUInteger)numOfCards fromCardDeck:(Deck *)deck
{
    if(self = [super init])
    {
        // if requested card number is greater than number of cards that deck contains
        if(numOfCards > [deck numberOfAvailableCards])
        {
            return nil;
        }
        
        _lastEventMessage = @"";
        _cards = [NSMutableArray arrayWithCapacity:numOfCards];
        
        for (int i = 0; i < numOfCards; ++i)
        {
            Card *drawnCard = [deck drawRandomCard];
            [self.cards addObject:drawnCard];
        }
    }
    
    return self;
}

#define NOT_MATCH_PENALTY 6
#define MATCH_MULTIPLIER 4
#define SELECT_PENALTY 2

- (void)selectCardAtIndex:(NSUInteger)index
{
    Card *currentCard = [self cardAtIndex:index];
    
    if (currentCard.isPlayable)
    {
        if (!currentCard.isFaceUp)
        {
            self.lastEventMessage = [NSString stringWithFormat:@"Selected %@",currentCard];
            
            NSPredicate *condition = [NSPredicate predicateWithFormat:@"isFaceUp == YES AND isPlayable == YES"];
            NSArray *matchedCards = [self.cards filteredArrayUsingPredicate:condition];
            
                 
            if ([matchedCards count] == 2)
            {
                int matchScore = [currentCard match:matchedCards];
                if(matchScore == 0)
                {
                    self.score -= NOT_MATCH_PENALTY*2;
                    
                    // in the end it turn face down
                    currentCard.faceUp = YES;
                    
                    // put two cards face down
                    [matchedCards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [obj setFaceUp:NO];
                    }];
                    self.lastEventMessage = [NSString stringWithFormat:@"Cannot match %@ & %@ & %@! %d point penalty!", currentCard, matchedCards[0], matchedCards[1], NOT_MATCH_PENALTY*2];
                }
                else
                {
                    self.score += matchScore * MATCH_MULTIPLIER;
                    
                    currentCard.playable = NO;
                    [matchedCards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [obj setPlayable:NO];
                    }];
                    self.lastEventMessage = [NSString stringWithFormat:@"Matched set of %@ & %@ & %@ for %d points", currentCard, matchedCards[0], matchedCards[1], matchScore * MATCH_MULTIPLIER];
                }
                
            }
            self.score -= SELECT_PENALTY;
        }
        currentCard.faceUp = !currentCard.faceUp;
    }

}

- (Card*) cardAtIndex:(NSUInteger) index
{
    return index < [self.cards count] ? self.cards[index] : nil;
}

@end
