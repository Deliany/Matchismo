//
//  GameScores.h
//  iMatch
//
//  Created by Deliany Delirium on 15.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

@property (readwrite, nonatomic) NSString *gameName;
@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) NSInteger score;

- (id)initWithGameName:(NSString *)name;
+ (NSArray*)allGameResults;
+ (void)clearAllGameScores;

@end
