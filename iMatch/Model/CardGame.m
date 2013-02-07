//
//  CardGame.m
//  iMatch
//
//  Created by Deliany Delirium on 03.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "CardGame.h"

@interface CardGame ()

@property (strong, nonatomic) NSMutableArray* cards;
@property (readwrite, nonatomic) int score;
@property (readwrite, strong, nonatomic) NSString *lastEventMessage;

@end

@implementation CardGame

-(id)init
{
    Deck *deck = [[PlayingDeck  alloc] init];
    return [self initWithNumberOfCards:deck.numberOfAvailableCards
                          fromCardDeck:deck
                           andGameType:0];
}

- (id) initWithNumberOfCards:(NSUInteger)numOfCards fromCardDeck:(Deck *)deck andGameType:(NSUInteger)gameType
{
    if(self = [super init])
    {
        // if requested card number is greater than number of cards that deck contains
        if(numOfCards > [deck numberOfAvailableCards])
        {
            return nil;
        }
        
        self.lastEventMessage = @"";
        self.cards = [NSMutableArray arrayWithCapacity:numOfCards];
        
        self.gameType = gameType;
        
        for (int i = 0; i < numOfCards; ++i)
        {
            Card *drawnCard = [deck drawRandomCard];
            [self.cards addObject:drawnCard];
        }
    }
    
    return self;
}

#define NOT_MATCH_PENALTY 2
#define MATCH_MULTIPLIER 4
#define FLIP_PENALTY 1

- (void) flipCardAtIndex:(NSUInteger) index
{
    Card *currentCard = [self cardAtIndex:index];
        
    if (currentCard.isPlayable)
    {
        if (!currentCard.isFaceUp)
        {
            self.lastEventMessage = [NSString stringWithFormat:@"Flipped up %@",currentCard];
            
            NSPredicate *condition = [NSPredicate predicateWithFormat:@"isFaceUp == YES AND isPlayable == YES"];
            NSArray *matchedCards = [self.cards filteredArrayUsingPredicate:condition];
            
            switch ([matchedCards count])
            {
                case 1:
                {
                    Card *matchedCard = [matchedCards lastObject];
                    
                    int matchScore = [currentCard match:matchedCards];
                    if(matchScore == 0)
                    {
                        self.score -= NOT_MATCH_PENALTY;
                        
                        // put one card face down
                        matchedCard.faceUp = NO;
                        self.lastEventMessage = [NSString stringWithFormat:@"%@ and %@ don't match! %d point penalty!",currentCard, matchedCard, NOT_MATCH_PENALTY];
                    }
                    else
                    {
                        self.score += matchScore;
                        self.lastEventMessage = [NSString stringWithFormat:@"Matched %@ and %@ for %d points", currentCard, matchedCard, matchScore];
                        
                        // game type of 2-cards only, so make these cards unplayable
                        if (self.gameType == 0)
                        {
                            matchedCard.playable = currentCard.playable = NO;
                        }
                    }
                }
                    break;
                    
                case 2:
                {
                    int matchScore = [currentCard match:matchedCards];
                    if(matchScore == 0)
                    {
                        self.score -= NOT_MATCH_PENALTY*2;
                        
                        // put two cards face down
                        [matchedCards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            [obj setFaceUp:NO];
                        }];
                        self.lastEventMessage = [NSString stringWithFormat:@"Some cards don't match! %d point penalty!", NOT_MATCH_PENALTY*2];
                    }
                    else
                    {
                        self.score += matchScore * MATCH_MULTIPLIER;
                        
                        currentCard.playable = NO;
                        [matchedCards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            [obj setPlayable:NO];
                        }];
                        self.lastEventMessage = [NSString stringWithFormat:@"Matched 3 cards for %d points", matchScore * MATCH_MULTIPLIER];
                    }
                    
                }
                    break;
                    
                default:
                    break;
            }
            self.score -= FLIP_PENALTY;
        }
        currentCard.faceUp = !currentCard.faceUp;
    }
}

- (Card*) cardAtIndex:(NSUInteger) index
{
    return index < [self.cards count] ? self.cards[index] : nil;
}

@end
