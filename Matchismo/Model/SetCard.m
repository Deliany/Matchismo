//
//  SetCard.m
//  Matchismo
//
//  Created by Deliany Delirium on 07.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

-(id)init
{
    return [self initWithNumber:0 symbol:@"?" shading:[[self class] shadings][0] color:[[self class] colors][0]];
}

- (id)initWithNumber:(NSUInteger)number symbol:(NSString *)symbol shading:(NSString *)shading color:(NSString *)color
{
    if (self = [super init])
    {
        _number = number;
        _symbol = symbol;
        _shading = shading;
        _color = color;
    }
    
    return self;
}

- (NSInteger)match:(NSArray *)otherCards
{
    NSInteger score = 0;
    
    // match exactly with two other cards
    if([otherCards count] == 2)
    {
        // rules corresponds to
        // http://en.wikipedia.org/wiki/Set_(game)
        
        NSMutableArray *cards = [otherCards mutableCopy];
        [cards addObject:self];
        
        NSCountedSet *bag = [NSCountedSet set];
        for (id obj in cards)
        {
            if ([obj isKindOfClass:[SetCard class]])
            {
                SetCard *card = (SetCard*)obj;
                [bag addObject:@(card.number)];
                [bag addObject:card.symbol];
                [bag addObject:card.shading];
                [bag addObject:card.color];
            }
        }
        
        for (id item in bag)
        {
            NSUInteger itemCount = [bag countForObject:item];
            
            if (itemCount == 1)
            {
                score += 10;
            }
            else if (itemCount == 2) // accordingly to rules, this is not set
            {
                score = 0;
                break;
            }
            else if (itemCount == 3)
            {
                score += 5;
            }
        }
    }
    return score;
}

- (NSString *)numberString
{
    return [[self class] numbers][self.number];
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[[self class] symbols] containsObject:symbol])
    {
        _symbol = symbol;
    }
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [[self class] maxNumber])
    {
        _number = number;
    }
}

- (void)setShading:(NSString *)shading
{
    if ([[[self class] shadings] containsObject:shading])
    {
        _shading = shading;
    }
}

- (void)setColor:(NSString *)color
{
    if ([[[self class] colors] containsObject:color])
    {
        _color = color;
    }
}

+ (NSArray *)symbols
{
    static NSArray *symbols = nil;
    if (!symbols) {
        symbols = @[@"diamond",@"squiggle",@"oval"];
    }
    return symbols;
}

+ (NSArray *)numbers
{
    static NSArray *numbers = nil;
    if (!numbers) {
        numbers = @[@"?", @"1", @"2", @"3"];
    }
    return numbers;
}

+ (NSUInteger)maxNumber
{
    return [[[self class] numbers] count] - 1;
}

+ (NSArray *)shadings
{
    static NSArray *shadings = nil;
    if (!shadings) {
        shadings = @[@"solid",@"striped",@"open"];
    }
    return shadings;
}

+ (NSArray *)colors
{
    static NSArray *colors = nil;
    if (!colors) {
        colors = @[@"redColor",@"greenColor",@"purpleColor"];
    }
    return colors;
}

- (NSString *)description
{
    
    return [NSString stringWithFormat:@"%@%@%@%@", self.numberString, self.symbol, self.shading, self.color];
}

- (NSAttributedString *)attributedDescription
{
    return [[NSAttributedString alloc] initWithString:[self description]];
}

@end
