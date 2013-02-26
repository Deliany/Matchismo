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

-(NSUInteger) startingCardsCount
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

- (NSArray*)updateEventMessageViewStatus:(UIView*)view withCards:(NSArray*)cards andScore:(NSInteger)score
{
    NSMutableArray *viewsArray = [NSMutableArray array];
    for (UIView *subView in view.subviews) {
        [subView removeFromSuperview];
    }
    
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    
    BOOL flippedUp;
    CGFloat xOffset = 0;
    for (Card *card in cards) {
        if ([card isKindOfClass:[SetCard class]]) {
            SetCardView *setCardView = [[SetCardView alloc] initWithFrame:CGRectMake(xOffset, 0, iPad ? 50 : 35, view.bounds.size.height)];
            setCardView.opaque = NO;
            [setCardView setBackgroundColor:[UIColor clearColor]];
            
            SetCard *setCard = (SetCard *)card;
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.shading = setCard.shading;
            setCardView.color = setCard.color;
            flippedUp = setCard.faceUp;
            
            [view addSubview:setCardView];
            [viewsArray addObject:setCardView];
            xOffset += setCardView.bounds.size.width + 10;
        }
    }
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, 0, view.bounds.size.width, view.bounds.size.height)];
    
    [textLabel setTextColor:[UIColor blackColor]];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 18.0f]];
    
    if (cards && score == 0) {
        [textLabel setText:[NSString stringWithFormat:@"%@", flippedUp == YES ? @"Selected" : @"Deselected"]];
    }
    else if (score > 0) {
        [textLabel setText:[NSString stringWithFormat:@"Match for %d points!",score]];
    }
    else if (score < 0) {
        [textLabel setText:[NSString stringWithFormat:@"Don't match! %d points penalty",score]];
    }
    
    if (iPad) {
        [view addSubview:textLabel];
        [viewsArray addObject:textLabel];
    }
    
    return viewsArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-set-game.jpg"]]];
    self.countOfCardsToMatch = 3;
}

@end
