//
//  Deck.m
//  Matchismo
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "Deck.h"
#import "Card.h"

@interface Deck ()

@property (readwrite, strong, nonatomic) NSMutableArray *cards;

@end




@implementation Deck

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [NSMutableArray array];
    }
    
    return _cards;
}

- (NSUInteger)countOfAvailableCards
{
    return [self.cards count];
}

- (void)addCard:(Card *)card
{
    if (card) {
        [self.cards addObject:card];
    }
}

- (Card *)drawRandomCard
{
    Card *drawnCard = nil;
    if(self.countOfAvailableCards > 0)
    {
        unsigned randPos = arc4random() % [self.cards count];
        drawnCard = self.cards[randPos];
        
        // remove card from cards array
        [self.cards removeObjectAtIndex:randPos];
    }
    return drawnCard;
}

@end
