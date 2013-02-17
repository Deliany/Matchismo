//
//  Card.m
//  iMatch
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "Card.h"

@implementation Card


-(id)init
{
    if(self = [super init])
    {
        self.playable = YES;
        self.faceUp = NO;
    }
    return self;
}


-(NSInteger)match:(NSArray *)otherCards
{
    NSInteger score = 0;
    for (id obj in otherCards)
    {
        // instrospection
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

@end
