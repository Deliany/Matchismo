//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Deliany Delirium on 07.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SetCardGameViewController.h"
#import "SetCardCollectionViewCell.h"
#import "CardGame.h"
#import "SetDeck.h"
#import "SetCard.h"
#import "GameResult.h"

@interface SetCardGameViewController () <UIAlertViewDelegate>

@end



@implementation SetCardGameViewController

-(Deck*)createDeck
{
    return [[SetDeck alloc] init];
}

-(NSUInteger) startingCardCount
{
    return 12;
}

- (NSString *)gameName
{
    return @"Set Card Game";
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card*)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell*) cell).setCardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.shading = setCard.shading;
            setCardView.color = setCard.color;
            setCardView.selected = setCard.faceUp;
            setCardView.alpha = setCard.playable ? 1.0 : 0.3;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-set-game.jpg"]]];
    self.numberOfCardsToMatch = 3;
}

@end
