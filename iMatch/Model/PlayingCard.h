//
//  PlayingCard.h
//  iMatch
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+(NSArray *) suits;
+(NSArray *) ranks;
+(NSUInteger) maxRank;

- (id)initWithSuit:(NSString *)suit andRank:(NSUInteger)rank;

@end
