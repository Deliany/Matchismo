//
//  Deck.h
//  Matchismo
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

/**
 * A Deck object represents a collection of Card objects handles Card abstract concept in game.
 *
 **/
@interface Deck : NSObject

///---------------------------------------------------------------------------------------
/// @name Deck Attributes
///---------------------------------------------------------------------------------------

/**
 * A NSUInteger number of available cards in Deck object
 **/
@property (readonly, nonatomic) NSUInteger countOfAvailableCards;

///---------------------------------------------------------------------------------------
/// @name Add & remove cards from deck
///---------------------------------------------------------------------------------------

/**
 * Inserts a given card in the bottom of the Deck.
 *
 * @param card Card object that will be inserted.
 **/
- (void) addCard:(Card *)card;

/**
 * Returns a random card from the Deck object and remove it from the Deck object.
 *
 * @return Returns a Card object.
 **/
- (Card*) drawRandomCard;

@end
