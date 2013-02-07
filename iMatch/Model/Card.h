//
//  Card.h
//  iMatch
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isPlayable) BOOL playable;

- (int) match:(NSArray *)otherCards;

@end
