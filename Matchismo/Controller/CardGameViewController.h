//
//  ViewController.h
//  Matchismo
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

@property (nonatomic) NSUInteger startingCardsCount;
@property (nonatomic) NSUInteger countOfCardsToMatch;

- (Deck*)createDeck; // abstract
- (NSString *)gameName; // abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card*)card animate:(BOOL)animate; // abstract
- (NSArray*)updateEventMessageViewStatus:(UIView*)view withCards:(NSArray*)cards andScore:(NSInteger)score; // abstract

@end
