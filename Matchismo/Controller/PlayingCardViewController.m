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

#define PLAYING_CARDS_AMOUNT_KEY @"Playing_cards_amount"

-(NSUInteger) startingCardsCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:PLAYING_CARDS_AMOUNT_KEY];
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card*)card starred:(BOOL)starred animate:(BOOL)animate
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
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCardView *playingCardView = [[PlayingCardView alloc] initWithFrame:CGRectMake(xOffset, 0, iPad ? 50 : 35, view.bounds.size.height)];
            playingCardView.opaque = NO;
            [playingCardView setBackgroundColor:[UIColor clearColor]];
            
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            flippedUp = playingCard.faceUp;
            playingCardView.faceUp = YES;
            
            [view addSubview:playingCardView];
            [viewsArray addObject:playingCardView];
            xOffset += playingCardView.bounds.size.width + 10;
        }
    }
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, 0, view.bounds.size.width, view.bounds.size.height)];
                                                                   
    [textLabel setTextColor:[UIColor blackColor]];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 18.0f]];
    
    if (cards && score == 0 ) {
        [textLabel setText:[NSString stringWithFormat:@"Flipped %@", flippedUp == YES ? @"up" : @"down"]];
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

-(NSString *)gameName
{
    return @"Playing Card Game";
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-card-game.jpg"]]];
    self.countOfCardsToMatch = 2;
}

@end
