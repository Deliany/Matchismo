//
//  SetCard.h
//  iMatch
//
//  Created by Deliany Delirium on 07.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger rank;
@property (readonly, strong, nonatomic) NSString *rankString;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSDictionary *shading;
@property (strong, nonatomic) NSDictionary *color;

- (id)initWithRank:(NSUInteger)rank
              symbol:(NSString *)symbol
             shading:(NSDictionary *)shading
               color:(NSDictionary *)color;

+ (NSArray *)symbols;
+ (NSArray *)ranks;
+ (NSUInteger)maxRank;
+ (NSArray *)shadings;
+ (NSArray *)colors;

@end
