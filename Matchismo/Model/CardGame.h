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
 * Total score gained by matching cards 
 **/
@property (readonly, nonatomic) NSInteger score;

/**
 * Score gained by last card match
 **/
@property (readonly, nonatomic) NSInteger lastMatchScore;

/**
 * The number of cards, needed to match at once
 **/
@property (nonatomic) NSUInteger countOfCardsToMatch;

/**
 * Message that contains last playing output, 
 * for example which cards was matched together and for how much score they matched
 **/
@property (readonly, strong, nonatomic) NSAttributedString *lastEventMessage;

/**
 * Total amount of cards involved in game
 **/
@property (readonly, nonatomic) NSUInteger countOfCardsInGame;

/**
 * Total amount of cards left in deck
 **/
@property (readonly, nonatomic) NSUInteger countOfCardsInDeck;

/**
 * Number of cards that has status playable = NO
 **/
@property (readonly, nonatomic) NSUInteger countOfUnplayableCards;

/**
 * An array of arrays, each of subarray contains Card objects that participated in matching
 **/
@property (readonly, strong, nonatomic) NSMutableArray *flippedCardsHistoryArray;

/**
 * An array of already matched cards
 **/
@property (readonly, strong, nonatomic) NSMutableArray *matchedCardsArray;

///---------------------------------------------------------------------------------------
/// @name Initializing a CardMatchingGame
///---------------------------------------------------------------------------------------

/**
 * Initialized CardGame object with number of playing cards from given deck and also number of cards needed to match at once.
 *
 * @param numOfCards Cards that will be randomly drawn from given deck
 * @param deck Deck that will be used as source for drawing random cards
 * @param numOfCardsToMatch Accordingly to rules, this number will be used to validate whether cards is ready to match or not
 * @return Instantiated CardGame object
 **/
- (id) initWithNumberOfCards:(NSUInteger)numOfCards
                fromCardDeck:(Deck *)deck
     andNumberOfCardsToMatch:(NSUInteger)numOfCardsToMatch;

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

/**
 * Adds more cards to game from stored deck by specified amount
 * @param numberOfCards Number of cards that will be added to game
 **/
- (void) increaseNumberOfCardsUpTo: (NSUInteger)numberOfCards;

/**
 * Remove all cards that is unplayable from game
 * @return index path of removed cards
 **/
- (NSArray*) removeUnplayableCards;

@end
