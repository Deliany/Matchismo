//
//  PlayingCard.m
//  Matchismo
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (id)initWithSuit:(NSString *)suit andRank:(NSUInteger)rank
{
    if (self = [super init])
    {
        _suit = suit;
        _rank = rank;
    }
    return self;
}

- (void)setRank:(NSUInteger)rank
{
    if(rank <= [[self class] maxRank])
    {
        _rank = rank;
    }
}

- (void)setSuit:(NSString *)suit
{
    if ([[[self class] suits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)description
{
    NSString *stringRank = [[self class] ranks][self.rank];
    return [NSString stringWithFormat:@"%@%@", stringRank, self.suit];
}

#define SCORE_FOR_MATCHED_SUIT 4
#define MULTIPLIER_FOR_MATCHED_RANK 2.5

- (NSInteger)match:(NSArray *)otherCards
{
    NSInteger score = 0;
    for (id obj in otherCards)
    {
        if ([obj isKindOfClass:[PlayingCard class]])
        {
            PlayingCard *card = (PlayingCard*)obj;
            if([card.suit isEqualToString:self.suit])
            {
                score += SCORE_FOR_MATCHED_SUIT;
            }
            else if (card.rank == self.rank)
            {
                // rank = 1 for "2", rank = 2 for "3" and so on
                score += self.rank * MULTIPLIER_FOR_MATCHED_RANK;
            }
            else
            {
                score = 0;
                break;
            }
        }
    }
    
    return score;
}

+ (NSArray *) ranks
{
    static NSArray *ranks = nil;
    if(!ranks) {
        ranks = @[@"?", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", @"A"];
    }
    return ranks;
}

+ (NSUInteger) maxRank
{
    return [[[self class] ranks] count] - 1;
}

+ (NSArray *) suits
{
    static NSArray *suits = nil;
    if(!suits) {
        suits = @[@"♠",@"♣",@"♥",@"♦"];
    }
    return suits;
}

#pragma mark -
#pragma NSCopying protocol methods

- (id)copyWithZone:(NSZone *)zone
{
    PlayingCard *cardCopy = [[[self class] allocWithZone:zone] initWithSuit:[self.suit copy] andRank:self.rank];
    if (cardCopy) {
        cardCopy.playable = self.isPlayable;
        cardCopy.faceUp = self.isFaceUp;
        cardCopy.lastPlayed = self.isLastPlayed;
    }
    return cardCopy;
}

@end
