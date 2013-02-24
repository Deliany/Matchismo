//
//  ViewController.h
//  iMatch
//
//  Created by Deliany Delirium on 02.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController <UIAlertViewDelegate>

-(Deck*)createDeck; // abstract
@property (nonatomic) NSUInteger startingCardCount; // abstract

@end
