//
//  Card.m
//  iMatch
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
        self.playable = YES;
        self.faceUp = NO;
    }
    return self;
}


- (int)match:(NSArray *)otherCards
{
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.description isEqualToString:self.description])
        {
            score += 1;
        }
    }
    return score;
}

@end
