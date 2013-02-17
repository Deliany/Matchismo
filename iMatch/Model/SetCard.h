//
//  SetCard.h
//  iMatch
//
//  Created by Deliany Delirium on 07.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "Card.h"

/**
 * A SetGameCard object is varying in four features: number (1, 2, or 3); symbol (diamond, squiggle, oval); shading (solid, striped, or open); and color (red, green, or purple).
 *
 *  - `number` : { 1 | 2 | 3 }
 *  - `symbol` : { diamond | squiggle | oval }
 *  - `shading` : { solid | striped | open }
 *  - `color` : { red | green | purple }
 *
 *  Following are rules that defines a 'set':
 *
 *  - They all have the same number, or they have three different numbers.
 *
 *  - They all have the same symbol, or they have three different symbols.
 *
 *  - They all have the same shading, or they have three different shadings.
 *
 *  - They all have the same color, or they have three different colors.
 *
 *  The rules of Set are summarized by: If you can sort a group of three cards into "Two of X and one of Y,"
 *  then it is not a set.
 *  @warning *Note:* Any value can passed into attributed. However, class will ignore invalid values. reccomend use convenience initializer to create SetCard object;
 **/
@interface SetCard : Card

/**
 * The value of number.
 **/
@property (nonatomic) NSUInteger rank;

/**
 * NSString representation of number.
 **/
@property (readonly, strong, nonatomic) NSString *rankString;

/**
 * The value of symbol.
 **/
@property (strong, nonatomic) NSString *symbol;

/**
 * The value of shading.
 **/
@property (strong, nonatomic) NSDictionary *shading;

/**
 * The value of color.
 **/
@property (strong, nonatomic) NSDictionary *color;

///---------------------------------------------------------------------------------------
/// @name Convenience Initializer
///---------------------------------------------------------------------------------------

/**
 * Returns a newly initialized SetGameCard object with value specified.
 * @param rank Number of set card
 * @param symbol Symbols of set card
 * @param shading Shading of set card (dictionary with attributed values)
 * @param color Color of set card (dictionary with attributed values)
 * @return Instantited SetCard object
 **/
- (id)initWithRank:(NSUInteger)rank
              symbol:(NSString *)symbol
             shading:(NSDictionary *)shading
               color:(NSDictionary *)color;

///---------------------------------------------------------------------------------------
/// @name Get Valid Values
///---------------------------------------------------------------------------------------

/**
 * Gets the number of SetGameCard object
 * @return array of numbers in string representation.
 **/
+ (NSArray *)ranks;

/**
 * Returns max number in set card game
 * @return maximum possible number of set card
 **/
+ (NSUInteger)maxRank;

/**
 * Gets the symbol of SetGameCard object
 * @return array of symbols in string representation.
 **/
+ (NSArray *)symbols;

/**
 * Gets the shading of SetGameCard object
 * @return array of dictionaries of possible shadings.
 **/
+ (NSArray *)shadings;

/**
 * Gets the color of SetGameCard object
 * @return array of dictionaries of possible colors.
 **/
+ (NSArray *)colors;

@end
