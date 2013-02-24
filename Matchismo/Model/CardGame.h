//
//  CardGame.h
//  Matchismo
//
//  Created by Deliany Delirium on 03.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;
@class Deck;

/**
 * A CardMatchingGame object contains all game playing logic. It also caculates score and hold game states.
 *
 **/
@interface CardGame : NSObject

///---------------------------------------------------------------------------------------
/// @name CardMatchingGame Attributes
///---------------------------------------------------------------------------------------

/**
 * The value of game score.
 **/
@property (readonly, nonatomic) NSInteger score;

/**
 * The number of cards, needed to match at once
 **/
@property (nonatomic) NSUInteger numberOfCardsToMatch;

/**
 * Message that contains last playing output, 
 * for example which cards was matched together and for how much score they matched
 **/
@property (readonly, strong, nonatomic) NSAttributedString *lastEventMessage;

///---------------------------------------------------------------------------------------
/// @name Initializing a CardMatchingGame
///---------------------------------------------------------------------------------------

/**
 * Initialized CardGame object with number of playing cards from given deck and also number of cards needed to match at once.
 *
 * @param numOfCards Cards that will be randomly drawn from given deck
 * @param deck Deck that will be used as source for drawing random cards
 * @param numberOfCards Accordingly to rules, this number will be used to validate whether cards is ready to match or not
 * @return Instantiated CardGame object
 **/
- (id) initWithNumberOfCards:(NSUInteger)numOfCards fromCardDeck:(Deck *)deck andNumberOfCardsToMatch:(NSUInteger)numberOfCards;

///---------------------------------------------------------------------------------------
/// @name Game Playing Actions
///---------------------------------------------------------------------------------------

/**
 * Perform a card flipping game play.
 * @param index value of card index in the Deck object.
 **/
- (void) flipCardAtIndex:(NSUInteger)index;

/**
 * Get card of the index.
 * @param index value of card index in the Deck object.
 * @return a Card object of the index.
 **/
- (Card*) cardAtIndex:(NSUInteger)index;

@end
