//
//  SetCard.m
//  Matchismo
//
//  Created by Jess Thrysoee on 12/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

#define FEATURE_MAX_SUM 6

- (BOOL)matchFeature:(NSString *)feature cards:(NSArray *)cards
{
    NSUInteger myVal, val0, val1;
    
    myVal = [[self valueForKey:feature] unsignedIntegerValue];
    val0 = [[cards[0] valueForKey:feature] unsignedIntegerValue];
    val1 = [[cards[1] valueForKey:feature] unsignedIntegerValue];
    
    if (val0 == val1)
    {
        // if two values are equal then the so must the third
        return myVal == val0;
    }
    else
    {
        // if two values are different then the third must be the last available
        return myVal == FEATURE_MAX_SUM - val1 - val0;
    }
}


- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if (otherCards.count == 2)
    {
        if ([self matchFeature:@"number" cards:otherCards] &&
            [self matchFeature:@"symbol" cards:otherCards] &&
            [self matchFeature:@"shading" cards:otherCards] &&
            [self matchFeature:@"color" cards:otherCards])
        {
            score = 1;
        }
    }
    
    return score;
}


- (BOOL)valid:(NSUInteger)val
{
    return val == 1 || val == 2 || val == 3;
}


- (void)setNumber:(NSUInteger)number
{
    if ([self valid:number])
    {
        _number = number;
    }
}


- (void)setSymbol:(NSUInteger)symbol
{
    if ([self valid:symbol])
    {
        _symbol = symbol;
    }
}


- (void)setShading:(NSUInteger)shading
{
    if ([self valid:shading])
    {
        _shading = shading;
    }
}


- (void)setColor:(NSUInteger)color
{
    if ([self valid:color])
    {
        _color = color;
    }
}


- (NSString *)contents
{
    return [NSString stringWithFormat:@"%d-%d-%d-%d", self.number, self.symbol, self.shading, self.color];
}


@end
