//
//  SetDeck.m
//  iMatch
//
//  Created by Deliany Delirium on 08.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck

-(id)init
{
    if (self = [super init])
    {
        for (int number = 1; number <=3; ++number)
        {
            for (NSString *symbol in [SetCard symbols])
            {
                for (NSDictionary *shading in [SetCard shadings])
                {
                    for (NSDictionary *color in [SetCard colors])
                    {
                        SetCard *card = [[SetCard alloc] initWithRank:number symbol:symbol shading:shading color:color];
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
