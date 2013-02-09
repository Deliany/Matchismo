//
//  PlayingDeck.m
//  iMatch
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

-(id)init
{
    if (self = [super init])
    {
        for (NSString *suit in [PlayingCard suits])
        {
            // rank from 1 because PlayingCard ranks contains "?" element as first object
            for (int rank = 1; rank <= [PlayingCard maxRank]; ++rank)
            {
                PlayingCard *card = [[PlayingCard alloc] initWithSuit:suit andRank:rank];
                [self addCard:card];
            }
        }
    }
    
    return self;
}

@end
