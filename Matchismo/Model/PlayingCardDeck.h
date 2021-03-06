//
//  PlayingDeck.h
//  Matchismo
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "Deck.h"

/**
 * A PlayingCardDeck object represents a deck with 52 PlaygingCard in it.
 *
 **/
@interface PlayingCardDeck : Deck

/** 
 * How many cards could possibly be in Deck
 **/
+ (NSUInteger)maxCardsAmount;

@end
