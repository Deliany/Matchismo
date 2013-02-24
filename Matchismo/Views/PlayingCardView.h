//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Deliany Delirium on 19.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString* suit;
@property (nonatomic) BOOL faceUp;

-(void)pinch:(UIPinchGestureRecognizer*)gesture;

@end
