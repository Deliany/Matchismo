//
//  CardGame.h
//  iMatch
//
//  Created by Deliany Delirium on 03.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;
@class Deck;

@interface CardGame : NSObject

@property (readonly, nonatomic) NSInteger score;
@property (nonatomic) NSUInteger numberOfCardsToMatch;
@property (readonly, strong, nonatomic) NSAttributedString *lastEventMessage;

- (id) initWithNumberOfCards:(NSUInteger)numOfCards fromCardDeck:(Deck *)deck andNumberOfCardsToMatch:(NSUInteger)gameType;

- (void) flipCardAtIndex:(NSUInteger) index;
- (Card*) cardAtIndex:(NSUInteger) index;

@end
