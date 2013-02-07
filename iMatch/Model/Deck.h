//
//  Deck.h
//  iMatch
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject
{
    @protected
    NSMutableArray *_cards;
}

@property (readonly, nonatomic) NSUInteger numberOfAvailableCards;

- (void) addCard:(Card *)card;
- (Card*) drawRandomCard;

@end
