//
//  SetCardView.m
//  Matchismo
//
//  Created by Deliany Delirium on 24.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)setStarred:(BOOL)starred
{
    _starred = starred;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12.0];
    [roundedRect addClip]; //prevents filling corners, i.e. sharp corners not included in roundedRect
    
    if (self.isSelected) {
        [[UIColor lightGrayColor] setFill];
        UIRectFill(self.bounds);
    } else {
        [[UIColor whiteColor] setFill];
        UIRectFill(self.bounds);
    }
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawCards];
    if (self.starred) {
        [self drawStar];
    }
}

#define SYMBOL_SCALE_X 2
#define SYMBOL_SCALE_Y 4.5
#define SIZE_OF_OVAL_CURVE 10
#define DIAMOND_ARM_SCALE 0.8
#define Y_OFFSET_FOR_NUMBER_2 2.7
#define Y_OFFSET_FOR_NUMBER_3 1.7

- (void)drawCards
{
    if ([self.symbol isEqualToString:@"diamond"]) {
        [self drawDiamond];
    } else if ([self.symbol isEqualToString:@"squiggle"]) {
        [self drawSquiggle];
    } else if ([self.symbol isEqualToString:@"oval"]) {
        [self drawOval];
    }
}

- (void)drawSquiggle
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint start = CGPointMake(middle.x + (middle.x / SYMBOL_SCALE_X), middle.y - (middle.y / SYMBOL_SCALE_Y));
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:start];
    [path addQuadCurveToPoint:CGPointMake(start.x, middle.y + (middle.y / SYMBOL_SCALE_Y)) controlPoint:CGPointMake(start.x + SIZE_OF_OVAL_CURVE, middle.y)];
    [path addCurveToPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X), middle.y + (middle.y / SYMBOL_SCALE_Y)) controlPoint1:CGPointMake(middle.x, middle.y + (middle.y / SYMBOL_SCALE_Y) + (middle.y / SYMBOL_SCALE_Y)) controlPoint2:CGPointMake(middle.x, middle.y)];
    [path addQuadCurveToPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X), start.y) controlPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X) - SIZE_OF_OVAL_CURVE, middle.y)];
    [path addCurveToPoint:CGPointMake(start.x, start.y) controlPoint1:CGPointMake(middle.x, middle.y - (middle.y / SYMBOL_SCALE_Y) - (middle.y / SYMBOL_SCALE_Y)) controlPoint2:CGPointMake(middle.x, middle.y)];
    
    [self drawAttributesFor:path];
}

- (void)drawOval
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint start = CGPointMake(middle.x + (middle.x / SYMBOL_SCALE_X), middle.y - (middle.y / SYMBOL_SCALE_Y));
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:start];
    [path addQuadCurveToPoint:CGPointMake(start.x, middle.y + (middle.y / SYMBOL_SCALE_Y)) controlPoint:CGPointMake(start.x + SIZE_OF_OVAL_CURVE, middle.y)];
    [path addLineToPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X), middle.y + (middle.y / SYMBOL_SCALE_Y))];
    [path addQuadCurveToPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X), start.y) controlPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X) - SIZE_OF_OVAL_CURVE, middle.y)];
    [path closePath];
    
    [self drawAttributesFor:path];
}

- (void)drawDiamond
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint start = CGPointMake(middle.x, middle.y - (middle.y / SYMBOL_SCALE_Y));
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:start];
    [path addLineToPoint:CGPointMake(middle.x + (middle.x / (SYMBOL_SCALE_X * DIAMOND_ARM_SCALE)), middle.y)];
    [path addLineToPoint:CGPointMake(middle.x, middle.y + (middle.y / SYMBOL_SCALE_Y))];
    [path addLineToPoint:CGPointMake(middle.x - (middle.x / (SYMBOL_SCALE_X * DIAMOND_ARM_SCALE)), middle.y)];
    [path closePath];
    
    [self drawAttributesFor:path];
}

- (void)drawAttributesFor:(UIBezierPath *)path
{
    [[UIColor valueForKey:self.color] setStroke];
    
    if ([self.shading isEqualToString:@"striped"]) {
        [[[UIColor valueForKey:self.color] colorWithAlphaComponent:0.3] setFill];
    } else if ([self.shading isEqualToString:@"solid"]) {
        [[UIColor valueForKey:self.color] setFill];
    } else {
        
    }
    
    if (self.number == 2) {
        CGFloat yOffset = self.bounds.size.height/2/Y_OFFSET_FOR_NUMBER_2;
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
        
        transform = CGAffineTransformMakeTranslation(0, yOffset * 2);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
    } else if (self.number == 3) {
        CGFloat yOffset = self.bounds.size.height/2/Y_OFFSET_FOR_NUMBER_3;
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
        
        transform = CGAffineTransformMakeTranslation(0, yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
        
        transform = CGAffineTransformMakeTranslation(0, yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
    } else {
        [path stroke];
        [path fill];
    }
}

- (void)drawStar
{
    CGPoint start = CGPointMake(self.bounds.size.width*0.75, self.bounds.size.width*0.1);
    
    //// Star Drawing
    UIBezierPath* starPath = [UIBezierPath bezierPath];
    [starPath moveToPoint: CGPointMake(start.x+5, start.y-0)];
    [starPath addLineToPoint: CGPointMake(start.x+3.25, start.y+2.59)];
    [starPath addLineToPoint: CGPointMake(start.x+0.24, start.y+3.45)];
    [starPath addLineToPoint: CGPointMake(start.x+2.17, start.y+5.92)];
    [starPath addLineToPoint: CGPointMake(start.x+2.06, start.y+9.05)];
    [starPath addLineToPoint: CGPointMake(start.x+5, start.y+7.97)];
    [starPath addLineToPoint: CGPointMake(start.x+7.94, start.y+9.05)];
    [starPath addLineToPoint: CGPointMake(start.x+7.83, start.y+5.92)];
    [starPath addLineToPoint: CGPointMake(start.x+9.76, start.y+3.45)];
    [starPath addLineToPoint: CGPointMake(start.x+6.75, start.y+2.59)];
    [starPath closePath];
    [[UIColor yellowColor] setFill];
    [starPath fill];
    [[UIColor blackColor] setStroke];
    starPath.lineWidth = 0.5;
    [starPath stroke];

}

@end
