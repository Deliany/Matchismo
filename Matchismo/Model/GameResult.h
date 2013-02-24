//
//  GameScores.h
//  Matchismo
//
//  Created by Deliany Delirium on 15.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A GameResult objects handles persistence score.
 */
@interface GameResult : NSObject

///---------------------------------------------------------------------------------------
/// @name GameResult Attributes
///---------------------------------------------------------------------------------------

/**
 * The name of game.
 **/
@property (readwrite, nonatomic) NSString *gameName;

/**
 * The start time of game.
 **/
@property (readonly, nonatomic) NSDate *start;

/**
 * The end time of game.
 **/
@property (readonly, nonatomic) NSDate *end;

/**
 * The duration of the game in sec.
 **/
@property (readonly, nonatomic) NSTimeInterval duration;

/**
 * The score of the game.
 **/
@property (nonatomic) NSInteger score;

///---------------------------------------------------------------------------------------
/// @name Convenience Initializer
///---------------------------------------------------------------------------------------

/**
 * Initializer to Create game result
 * @param name Name of the game (for example, Set Card Game)
 **/
- (id)initWithGameName:(NSString *)name;

///---------------------------------------------------------------------------------------
/// @name GameResult methods
///---------------------------------------------------------------------------------------

/**
 * All games results, fetched from NSUserDefaults class
 **/
+ (NSArray*)allGameResults;

/**
 * Erase all game scores from NSUserDefaults class
 **/
+ (void)clearAllGameScores;

@end
