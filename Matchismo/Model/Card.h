//
//  Card.h
//  Matchismo
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A Card object represents a card abstract concept in matching game.
 * This is abstract class of Card in game. It can be any kind of card.
 *
 **/
@interface Card : NSObject <NSCopying>

///------------------------------------------------------------------
/// @name Card attributes
///------------------------------------------------------------------

/**
 * A Boolean value that determines whether the Card object is facing up or not.
 *
 **/
@property (nonatomic, getter = isFaceUp) BOOL faceUp;

/**
 * A Boolean value that determines whether the Card object can be flip or not.
 **/
@property (nonatomic, getter = isPlayable) BOOL playable;

/**
 * A Boolean value that determines whether the Card object played(participated) last time in matching
 **/
@property (nonatomic, getter = isLastPlayed) BOOL lastPlayed;

///---------------------------------------------------------------------------------------
/// @name Comparing Card
///---------------------------------------------------------------------------------------

/**
 * Returns a match score of this Card object and other cards.
 *
 * This is usually a abtstract implementation. It returns 1 when card is matcted with any card that in cards array.
 *
 * @param otherCards A Card array to compared with.
 * @return Returns comparing score.
 **/
- (NSInteger)match:(NSArray *)otherCards;

///---------------------------------------------------------------------------------------
/// @name Card Text Description
///---------------------------------------------------------------------------------------

/**
 * Returns card text description
 *
 * This is usually a abtstract implementation. It returns empty string in base implementation.
 *
 * @return Returns card text description.
 **/
- (NSString *)description;

/**
 * Returns attributed card text description
 *
 * This is usually a abtstract implementation. In base implementation it returns allocated attributed string with description method
 *
 * @return Returns attributed card text description.
 * @see description
 **/
- (NSAttributedString *) attributedDescription;

@end
