//
//  PlayingDeck.m
//  iMatch
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "PlayingDeck.h"

@implementation PlayingDeck

-(id)init
{
    if (self = [super init])
    {
        for (int suit = 1; suit < [[PlayingCard suits] count]; ++suit)
        {
            for (int rank = 1; rank < [[PlayingCard ranks] count]; ++rank)
            {
                PlayingCard *card = [[PlayingCard alloc] initWithSuit:[PlayingCard suits][suit] andRank:rank];
                [self addCard:card];
            }
        }
    }
    
    return self;
}

@end
