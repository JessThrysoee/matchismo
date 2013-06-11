//
//  SetCardView.m
//  Matchismo
//
//  Created by Jess Thrysoee on 18/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "SetCardView.h"


@interface SetCardView ()
@property (nonatomic) UIColor *uicolor;

@property (nonatomic) CGFloat cardW;
@property (nonatomic) CGFloat cardH;
@property (nonatomic) CGFloat topPad;
@property (nonatomic) CGFloat symbolW;
@property (nonatomic) CGFloat symbolH;
@property (nonatomic) CGFloat padding;

@end

@implementation SetCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        [self setup];
    }

    return self;
}


- (void)awakeFromNib
{
    [self setup];
}


- (void)setup
{
}


- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self update];
}


- (BOOL)isThumb
{
    return NO;
}


- (BOOL)valid:(NSUInteger)val
{
    return val == 0 || val == 1 || val == 2 || val == 3;
}


- (void)setNumber:(NSUInteger)number
{
    if ([self valid:number])
    {
        _number = number;
    }

    [self update];
}


- (void)setSymbol:(NSUInteger)symbol
{
    if ([self valid:symbol])
    {
        _symbol = symbol;
    }

    [self update];
}


- (void)setShading:(NSUInteger)shading
{
    if ([self valid:shading])
    {
        _shading = shading;
    }

    [self update];
}


- (void)setColor:(NSUInteger)color
{
    if ([self valid:color])
    {
        _color = color;

        switch (color)
        {
            case 0:
                // empty card
                break;

            case 1:
                // purple
                self.uicolor = [UIColor colorWithRed:0.6 green:0 blue:0.8 alpha:1];
                break;

            case 2:
                // green
                self.uicolor = [UIColor colorWithRed:0.25 green:0.59 blue:0.26 alpha:1];
                break;

            case 3:
                // red
                self.uicolor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
                break;

            default:
                assert(NULL);
                break;
        }
    }

    [self update];
}


- (void)blankCard
{
    self.number = 0;
    self.symbol = 0;
    self.color = 0;
    self.shading = 0;
    self.faceUp = NO;
}


- (void)update
{
    self.cardH = [self bounds].size.height;
    self.cardW = [self bounds].size.width;

    self.topPad = 0.15 * self.cardH;
    self.symbolW = 0.15 * self.cardW;
    self.symbolH = 0.7 * self.cardH;

    self.padding = ((self.cardW - (self.number * self.symbolW)) / (self.number + 1) );

    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctxt = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctxt);
    
    [self cardClip];

    if (self.symbol == 0)
    {
        return;
    }

    UIBezierPath *path = [UIBezierPath bezierPath];

    path.lineWidth = 5;

    if (self.isThumb)
    {
        path.lineWidth = 2;
    }

    path.lineJoinStyle = kCGLineJoinRound;

    [self.uicolor setStroke];
    [[UIColor clearColor] setFill];

    [self symbolPath:path];
    [path stroke];
    [path addClip];

    [self shadePath:path];
    [path stroke];

    if (self.isThumb)
    {
        self.alpha = 1;
    }
    else
    {
        self.alpha = self.faceUp ? 0.5 : 1.0;
    }
    
    CGContextRestoreGState(ctxt);
    
    [self drawStar];
}

-(void)drawStar
{
    if (!self.star)
    {
        return;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIFont *font = [UIFont systemFontOfSize:18];
    
    UIColor *yellow = [UIColor colorWithRed:155/255.0 green:135/255.0 blue:21/255.0 alpha:1];
    NSAttributedString *star = [[NSAttributedString alloc] initWithString:@"★" attributes:@{NSForegroundColorAttributeName:yellow,  NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName:font }];
    
    [star drawAtPoint:CGPointMake(self.cardW - 22, 2)];
}


- (void)symbolPath:(UIBezierPath *)path
{
    switch (self.symbol)
    {
        case 1:
            [self squigglePath:path];
            break;

        case 2:
            [self diamondPath:path];
            break;

        case 3:
            [self ovalPath:path];
            break;

        default:
            //assert(NULL);
            break;
    }
}


- (void)shadePath:(UIBezierPath *)path
{
    switch (self.shading)
    {
        case 1:
            [self shadeStripedPath:path];
            break;

        case 2:
            [self.uicolor setFill];
            [path fill];
            break;

        case 3:
            break;

        default:
            //assert(NULL);
            break;
    }
}


- (void)diamondPath:(UIBezierPath *)path
{
    for (int i = 0; i < self.number; i++)
    {
        [path moveToPoint:CGPointMake(((i + 1) * self.padding) + i * self.symbolW + 0.5 * self.symbolW, self.topPad)];
        [path addLineToPoint:CGPointMake(((i + 1) * self.padding) + i * self.symbolW  + self.symbolW, self.topPad + 0.5 * self.symbolH)];
        [path addLineToPoint:CGPointMake(((i + 1) * self.padding) + i * self.symbolW  + 0.5 * self.symbolW, self.topPad + self.symbolH)];
        [path addLineToPoint:CGPointMake(((i + 1) * self.padding) + i * self.symbolW, self.topPad + 0.5 * self.symbolH)];
        [path closePath];
    }
}


- (void)ovalPath:(UIBezierPath *)path
{
    for (int i = 0; i < self.number; i++)
    {
        CGRect roundedRect = CGRectMake(((i + 1) * self.padding) + (i * self.symbolW), self.topPad, self.symbolW, self.symbolH);
        [path appendPath:[UIBezierPath bezierPathWithRoundedRect:roundedRect cornerRadius:20]];
    }
}


- (void)squigglePath:(UIBezierPath *)path
{
    CGFloat slope = -4;
    CGFloat length = self.symbolH * 0.3;

    for (int i = 0; i < self.number; i++)
    {
        CGPoint p1 = CGPointMake(((i + 1) * self.padding) + i * self.symbolW, self.topPad + 0.17 * self.symbolH);
        CGPoint p2 = CGPointMake(((i + 1) * self.padding) + i * self.symbolW + self.symbolW, self.topPad + 0.25 * self.symbolH);
        CGPoint p3 = CGPointMake(((i + 1) * self.padding) + i * self.symbolW + self.symbolW, self.topPad + 0.83 * self.symbolH);
        CGPoint p4 = CGPointMake(((i + 1) * self.padding) + i * self.symbolW, self.topPad + 0.75 * self.symbolH);
        CGPoint p5 = p1;

        CGPoint p1_cp1 = prevPoint(p1, slope, length);
        CGPoint p1_cp2 = prevPoint(p2, slope, length);

        CGPoint p2_cp1 = nextPoint(p2, slope, length);
        CGPoint p2_cp2 = prevPoint(p3, slope, length);

        CGPoint p3_cp1 = nextPoint(p3, slope, length);
        CGPoint p3_cp2 = nextPoint(p4, slope, length);

        CGPoint p4_cp1 = prevPoint(p4, slope, length);
        CGPoint p4_cp2 = nextPoint(p5, slope, length);

        [path moveToPoint:p1];
        [path addCurveToPoint:p2 controlPoint1:p1_cp1 controlPoint2:p1_cp2];
        [path addCurveToPoint:p3 controlPoint1:p2_cp1 controlPoint2:p2_cp2];
        [path addCurveToPoint:p4 controlPoint1:p3_cp1 controlPoint2:p3_cp2];
        [path addCurveToPoint:p5 controlPoint1:p4_cp1 controlPoint2:p4_cp2];
    }
}


- (void)shadeStripedPath:(UIBezierPath *)path
{
    CGFloat cardH = [self bounds].size.height;
    CGFloat cardW = [self bounds].size.width;

    path.lineWidth = 1;

    CGFloat countLines = 20;

    if (self.isThumb)
    {
        countLines = 10;
    }

    CGFloat lineHeight = cardH / countLines;

    for (int i = 0; i < countLines; i++)
    {
        CGPoint p1 = CGPointMake(0, i * lineHeight);
        CGPoint p2 = CGPointMake(cardW, i * lineHeight);

        [path moveToPoint:p1];
        [path addLineToPoint:p2];
    }

    [path stroke];
}


- (void)cardClip
{
    NSUInteger cornerRadius = 12;

    UIBezierPath *border = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];

    [[UIColor colorWithRed:0.99 green:0.99 blue:0.96 alpha:1] setFill];
    [border fill];

    if (self.isThumb)
    {
        [[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1] setStroke];
        [border stroke];
    }

    [border addClip];
}


CGPoint prevPoint(CGPoint p, CGFloat slope, CGFloat length)
{
    CGFloat sign = (0 < slope) - (slope < 0);

    CGFloat a = sqrt( (length * length) / (1 + (slope * slope)) );
    CGFloat b = a * slope;

    return CGPointMake(p.x - a, p.y - (sign * b));
}


CGPoint nextPoint(CGPoint p, CGFloat slope, CGFloat length)
{
    CGFloat sign = (0 < slope) - (slope < 0);

    CGFloat a = sqrt( (length * length) / (1 + (slope * slope)) );
    CGFloat b = a * slope;

    return CGPointMake(p.x + a, p.y + (sign * b));
}


@end
