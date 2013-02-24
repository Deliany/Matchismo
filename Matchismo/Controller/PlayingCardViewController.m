//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by Deliany Delirium on 20.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@interface PlayingCardViewController ()

@end

@implementation PlayingCardViewController

-(Deck*)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(NSUInteger) startingCardCount
{
    return 22;
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card*)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell*) cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            if (animate) {
                [UIView transitionWithView:playingCardView
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    playingCardView.rank = playingCard.rank;
                                    playingCardView.suit = playingCard.suit;
                                    playingCardView.faceUp = playingCard.faceUp;
                                    playingCardView.alpha = playingCard.playable ? 1.0 : 0.3;
                                }
                                completion:NULL];
            }
            else {
                playingCardView.rank = playingCard.rank;
                playingCardView.suit = playingCard.suit;
                playingCardView.faceUp = playingCard.faceUp;
                playingCardView.alpha = playingCard.playable ? 1.0 : 0.3;
            }
        }
    }
}

-(NSString *)gameName
{
    return @"Playing Card Game";
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-card-game.jpg"]]];
    self.numberOfCardsToMatch = 2;
}

@end
