//
//  PlayingCardCollectionViewCell.h
//  iMatch
//
//  Created by Deliany Delirium on 20.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
