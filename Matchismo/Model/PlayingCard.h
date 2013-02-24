//
//  PlayingCard.h
//  Matchismo
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "Card.h"

/**
 * A PlayingCard object represents a card which is porker card without Joker.
 *
 *  - `suit`: heart is represented as ♥, diamond is represented as ♦, heart is represented as ♠, club is represented as ♣.
 *  - `rank`: rank value is from 1 to 13 which represents one of folloinwg value{ 2 | 3 | 4 | 5 | | 7 | 8 | 9 | 10 | J | Q | K | A }.
 **/
@interface PlayingCard : Card

///---------------------------------------------------------------------------------------
/// @name PlayingCard Attributes
///---------------------------------------------------------------------------------------

/**
 * The value of card suit.
 **/
@property (strong, nonatomic) NSString *suit;

/**
 * The value of card rank
 **/
@property (nonatomic) NSUInteger rank;

///---------------------------------------------------------------------------------------
/// @name Get Valid Values
///---------------------------------------------------------------------------------------

/**
 * Returns an array of valid NSString suit value.
 *
 * @return Returns a an array of suits.
 **/
+(NSArray *) suits;

/**
 * Returns an array of valid NSString ranks value.
 *
 * @return Returns a an array of ranks.
 **/
+(NSArray *) ranks;

/**
 * Returns max value of all possible rank values.
 *
 * @return Returns a max value.
 **/
+(NSUInteger) maxRank;

///---------------------------------------------------------------------------------------
/// @name Designated initiliazer
///---------------------------------------------------------------------------------------

/**
 * Initialiazes PlayingCard object with given suit and rank
 *
 * @warning Here no limitation of suit and rank parameters
 * 
 * @param suit A NSString card suit representation
 * @param rank A NSUInteger card rank representation
 * @return PlayingCard instantiated object with given suit and rank
 **/
- (id)initWithSuit:(NSString *)suit andRank:(NSUInteger)rank;

@end
