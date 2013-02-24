//
//  SetCard.m
//  iMatch
//
//  Created by Deliany Delirium on 07.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

-(id)init
{
    return [self initWithRank:0 symbol:@"?" shading:[[self class] shadings][0] color:[[self class] colors][0]];
}

- (id)initWithRank:(NSUInteger)rank symbol:(NSString *)symbol shading:(NSDictionary *)shading color:(NSDictionary *)color
{
    if (self = [super init])
    {
        _rank = rank;
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
                [bag addObject:@(card.rank)];
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
            else if (itemCount == 2) // due to rules, this is not set
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

- (NSString *)rankString
{
    return [[self class] ranks][self.rank];
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[[self class] symbols] containsObject:symbol])
    {
        _symbol = symbol;
    }
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [[self class] maxRank])
    {
        _rank = rank;
    }
}

- (void)setShading:(NSDictionary *)shading
{
    if ([[[self class] shadings] containsObject:shading])
    {
        _shading = shading;
    }
}

- (void)setColor:(NSDictionary *)color
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
        symbols = @[@"▲",@"●",@"■"];
    }
    return symbols;
}

+ (NSArray *)ranks
{
    static NSArray *numbers = nil;
    if (!numbers) {
        numbers = @[@"?", @"1", @"2", @"3"];
    }
    return numbers;
}

+ (NSUInteger)maxRank
{
    return [[[self class] ranks] count] - 1;
}

+ (NSArray *)shadings
{
    static NSArray *shadings = nil;
    if (!shadings) {
        shadings = @[@{NSStrokeWidthAttributeName: @0, NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)},
                     @{NSStrokeWidthAttributeName: @5, NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)},
                     @{NSStrokeWidthAttributeName: @2, NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    }
    return shadings;
}

+ (NSArray *)colors
{
    static NSArray *colors = nil;
    if (!colors) {
        colors = @[@{NSStrokeColorAttributeName : [UIColor redColor], NSForegroundColorAttributeName : [UIColor redColor]},
                   @{NSStrokeColorAttributeName : [UIColor greenColor], NSForegroundColorAttributeName : [UIColor greenColor]},
                   @{NSStrokeColorAttributeName : [UIColor purpleColor], NSForegroundColorAttributeName : [UIColor purpleColor]}];
    }
    return colors;
}

- (NSString *)description
{
    
    return [NSString stringWithFormat: @"%u%@%@%@", self.rank, self.symbol, self.shading, self.color];
}

- (NSAttributedString *)attributedDescription
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithDictionary:self.color];
    [attributes addEntriesFromDictionary:self.shading];
    
    NSMutableString *feature = [[NSMutableString alloc] initWithCapacity:self.rank];
    
    for (int i = 0; i < self.rank; ++i) {
        [feature appendString:self.symbol];
    }
    
    NSMutableAttributedString *coloredFeature = [[NSMutableAttributedString alloc] initWithString:feature attributes:attributes];
    return coloredFeature;
}

@end
