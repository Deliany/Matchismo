//
//  SetGame.h
//  iMatch
//
//  Created by Deliany Delirium on 08.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;
@class Deck;

@interface SetGame : NSObject

@property (readonly, nonatomic) int score;
@property (readonly, strong, nonatomic) NSString *lastEventMessage;

- (id) initWithNumberOfCards:(NSUInteger)numOfCards fromCardDeck:(Deck*)deck;

- (void) selectCardAtIndex:(NSUInteger) index;
- (Card*) cardAtIndex:(NSUInteger) index;

@end
