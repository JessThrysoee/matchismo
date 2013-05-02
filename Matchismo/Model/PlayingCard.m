//
//  PlayingCard.m
//  Matchismo
//
//  Created by Jess Thrysoee on 1/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard
@synthesize suit = _suit;

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}


+ (NSArray *)validSuits
{
    return @[@"♥", @"♦", @"♠", @"♣"];
}


- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}


- (NSString *)suit
{
    return _suit ? _suit : @"?";
}


+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}


+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}


- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
    {
        _rank = rank;
    }
}


- (NSString *)description
{
    return [self contents];
}


@end
