//
//  FlipResult.m
//  Matchismo
//
//  Created by Jess Thrysoee on 5/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "FlipResult.h"

@interface FlipResult ()
@property (strong, nonatomic) NSMutableArray *results;
@property (weak, nonatomic) id <CardRenderer> renderer;
@end

@implementation FlipResult

- (id)initWithCardRenderer:(id<CardRenderer>)renderer
{
    self = [super init];
    
    if (self)
    {
        _renderer = renderer;
    }
    
    return self;
}


- (NSMutableArray *)results
{
    if (!_results)
    {
        _results = [[NSMutableArray alloc] init];
    }
    
    return _results;
}


- (void)appendString:(NSString *)str to:(NSMutableAttributedString *)attrStr
{
    NSAttributedString *tmp = [[NSAttributedString alloc] initWithString:str];
    
    [attrStr appendAttributedString:tmp];
}


- (void)addMatchForCard:(Card *)card andCards:(NSArray *)otherCards withScore:(NSUInteger)score
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    [self appendString:@"Matched " to:result];
    
    [result appendAttributedString:[self.renderer renderCard:card]];
    
    for (Card *otherCard in otherCards)
    {
        [self appendString:@" & " to:result];
        [result appendAttributedString:[self.renderer renderCard:otherCard]];
    }
    
    [self appendString:[NSString stringWithFormat:@" for %d points", score] to:result];
    
    [self.results addObject:result];
}


- (void)addMismatchForCard:(Card *)card andCards:(NSArray *)otherCards withScore:(NSUInteger)score
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    [result appendAttributedString:[self.renderer renderCard:card]];
    
    for (Card *otherCard in otherCards)
    {
        [self appendString:@" & " to:result];
        [result appendAttributedString:[self.renderer renderCard:otherCard]];
    }
    
    [self appendString:[NSString stringWithFormat:@" don't match! %d point penalty", score] to:result];
    
    [self.results addObject:result];
}


- (void)addFlipForCard:(Card *)card
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    [self appendString:@"Flipped up " to:result];
    
    [result appendAttributedString:[self.renderer renderCard:card]];
    
    [self.results addObject:result];
}


- (NSAttributedString *)lastResult
{
    return [self.results lastObject];
}


- (NSUInteger)count
{
    return self.results.count;
}


- (NSAttributedString *)resultAtIndex:(NSUInteger)index
{
    NSAttributedString *result;
    
    if (index < self.results.count)
    {
        result = [self.results objectAtIndex:index];
    }
    
    return result;
}


@end
