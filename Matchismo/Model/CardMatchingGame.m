//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Jess Thrysoee on 4/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Deck.h"

#define FLIP_COST        1
#define MATCH_BONUS      4
#define MISMATCH_PENALTY 2

@interface CardMatchingGame ()
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards;
@end


@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards)
    {
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}


- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self)
    {
        for (int i = 0; i < count; i++)
        {
            Card *card = [deck drawRandomCard];
            
            if (!card)
            {
                self = nil;
            }
            else
            {
                self.cards[i] = card;
            }
        }
    }
    
    return self;
}


- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable)
    {
        if (!card.isFaceup)
        {
            for (Card *otherCard in self.cards)
            {
                if (otherCard.isFaceup && !otherCard.isUnplayable)
                {
                    int matchScore = [card match:@[otherCard]];
                    
                    if (matchScore)
                    {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                    }
                    else
                    {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                    }
                }
            }
            
            self.score -= FLIP_COST;
        }
        
        card.faceUp = !card.isFaceup;
    }
}


- (Card *)cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? self.cards[index] : nil;
}


@end
