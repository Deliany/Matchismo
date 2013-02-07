//
//  CardGame.h
//  iMatch
//
//  Created by Deliany Delirium on 03.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingDeck.h"

@interface CardGame : NSObject

@property (readonly, nonatomic) int score;
@property (nonatomic) NSUInteger gameType; // 0 - 2-card game, 1 - 3-card game
@property (readonly, strong, nonatomic) NSString *lastEventMessage;

- (id) initWithNumberOfCards:(NSUInteger)numOfCards fromCardDeck:(Deck *)deck andGameType:(NSUInteger) gameType;

- (void) flipCardAtIndex:(NSUInteger) index;
- (Card*) cardAtIndex:(NSUInteger) index;

@end
