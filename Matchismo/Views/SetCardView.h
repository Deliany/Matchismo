//
//  SetCardView.h
//  Matchismo
//
//  Created by Deliany Delirium on 24.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView
/*
 *  - `number` : { 1 | 2 | 3 }
 *  - `symbol` : { diamond | squiggle | oval }
 *  - `shading` : { solid | striped | open }
 *  - `color` : { red | green | purple }
 */
@property (nonatomic) NSUInteger number;
@property (nonatomic,strong) NSString* symbol;
@property (nonatomic,strong) NSString* shading;
@property (nonatomic,strong) NSString* color;
@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic) BOOL starred;

@end
