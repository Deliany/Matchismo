//
//  Card.m
//  Matchismo
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "Card.h"

@implementation Card

- (id)init
{
    if(self = [super init])
    {
        _playable = YES;
        _faceUp = NO;
        _lastPlayed = NO;
    }
    return self;
}


- (NSInteger)match:(NSArray *)otherCards
{
    NSInteger score = 0;
    for (id obj in otherCards)
    {
        if([obj isKindOfClass:[Card class]])
        {
            Card *card = (Card*)obj;
            if ([[card description] isEqualToString:[self description]])
            {
                score += 1;
            }
        }
    }
    return score;
}

-(NSString *)description
{
    return @"";
}

-(NSAttributedString *)attributedDescription
{
    return [[NSAttributedString alloc] initWithString:[self description]];
}

#pragma mark -
#pragma NSCopying protocol methods

- (id)copyWithZone:(NSZone *)zone
{
    Card *cardCopy = [[[self class] allocWithZone:zone] init];
    if (cardCopy) {
        cardCopy.playable = self.isPlayable;
        cardCopy.faceUp = self.isFaceUp;
        cardCopy.lastPlayed = self.isLastPlayed;
    }
    return cardCopy;
}

@end
