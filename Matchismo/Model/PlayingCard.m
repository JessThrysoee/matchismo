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


- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if (otherCards.count == 1)
    {
        PlayingCard *secondCard = [otherCards lastObject];
        
        if ([secondCard.suit isEqualToString:self.suit])
        {
            // suit-suit ~ 24%
            score = 4;
        }
        else if (secondCard.rank == self.rank)
        {
            // rank-rank ~ 6%
            score = 16;
        }
    }
    
    if (otherCards.count == 2)
    {
        PlayingCard *secondCard = [otherCards objectAtIndex:0];
        PlayingCard *thirdCard = [otherCards objectAtIndex:1];
        
        if (secondCard.rank == self.rank && thirdCard.rank == self.rank)
        {
            // rank-rank-rank ~ 0.2 %
            score = 256;
        }
        else if ([secondCard.suit isEqualToString:self.suit] && [thirdCard.suit isEqualToString:self.suit])
        {
            // suit-suit-suit ~ 5%
            score = 16;
        }
        else if (secondCard.rank == self.rank || thirdCard.rank == self.rank || secondCard.rank == thirdCard.rank)
        {
            // rank-rank-? ~ 17%
            score = 4;
        }
        else if ([secondCard.suit isEqualToString:self.suit] || [thirdCard.suit isEqualToString:self.suit] || [secondCard.suit isEqualToString:thirdCard.suit])
        {
            // suit-suit-? ~ 73%
            score = 1;
        }
    }
    
    return score;
}


- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}


+ (NSArray *)validSuits
{
    static NSArray *validSuits = nil;
    
    if (!validSuits)
    {
        validSuits = @[@"♥", @"♦", @"♠", @"♣"];
    }
    
    return validSuits;
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
