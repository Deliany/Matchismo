//
//  GameScores.m
//  Matchismo
//
//  Created by Deliany Delirium on 15.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "GameResult.h"

@interface GameResult ()

@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;

@end

@implementation GameResult

#define ALL_RESULTS_KEY @"GameResults_ALL"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"
#define GAME_NAME_KEY @"GameName"

- (id)init
{
    return [self initWithGameName:@"" startDate:[NSDate date] endDate:[NSDate date]];
}

- (id)initWithGameName:(NSString *)name
{
    return [self initWithGameName:name startDate:[NSDate date] endDate:[NSDate date]];
}

- (id)initWithGameName:(NSString *)name startDate:(NSDate*)start  endDate:(NSDate*)end
{
    if (self = [super init])
    {
        _gameName = name;
        _start = start;
        _end = end;
    }
    return self;
}

- (id)initWithPropertyList:(id)plist
{
    if(self = [self init])
    {
        if([plist isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *resultDictionaray = (NSDictionary *)plist;
            _start = resultDictionaray[START_KEY];
            _end = resultDictionaray[END_KEY];
            _score = [resultDictionaray[SCORE_KEY] intValue];
            _gameName = resultDictionaray[GAME_NAME_KEY];
        }
    }
    return self;
}

-(id) asPropertyList
{
    return @{ START_KEY : self.start , END_KEY : self.end , SCORE_KEY : @(self.score),GAME_NAME_KEY : self.gameName };
}

- (void)synchronize
{
    NSMutableDictionary *gameResults = [[[NSUserDefaults standardUserDefaults] objectForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!gameResults)
    {
        gameResults = [NSMutableDictionary dictionary];
    }
    gameResults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:gameResults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(NSInteger)score
{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

+ (NSArray *)allGameResults
{
    NSMutableArray *allGameResults = [NSMutableArray array];
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues])
    {
        GameResult *result = [[GameResult alloc] initWithPropertyList:plist];
        [allGameResults addObject:result];
    }
    return allGameResults;
}

+ (void)clearAllGameScores
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
