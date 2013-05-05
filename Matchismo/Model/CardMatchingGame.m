//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Jess Thrysoee on 4/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Deck.h"
#import "FlipResult.h"

#define FLIP_COST        -1
#define MATCH_BONUS      4
#define MISMATCH_PENALTY -2

@interface CardMatchingGame ()
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) FlipResult *flipResult;
@end


@implementation CardMatchingGame

- (FlipResult *)flipResult
{
    if (!_flipResult)
    {
        _flipResult = [[FlipResult alloc] init];
    }
    
    return _flipResult;
}

-(NSString *)lastFlipResult
{
    return self.flipResult.lastResult;
}


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
    NSUInteger score = 0;
    NSString *result;
    
    if (!card.isUnplayable)
    {
        if (!card.isFaceup)
        {
            result = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            
            for (Card *otherCard in self.cards)
            {
                if (otherCard.isFaceup && !otherCard.isUnplayable)
                {
                    int matchScore = [card match:@[otherCard]];
                    
                    if (matchScore)
                    {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        score = matchScore * MATCH_BONUS;
                        self.score += score;
                        [self.flipResult addMatchForCard:card andCard:otherCard withScore:score];
                    }
                    else
                    {
                        otherCard.faceUp = NO;
                        score = MISMATCH_PENALTY;
                        self.score += score;
                        [self.flipResult addMismatchForCard:card andCard:otherCard withScore:score];
                    }
                }
            }
            
            if (!score)
            {
                [self.flipResult addFlipForCard:card];
            }
            self.score += FLIP_COST;
        }
        
        card.faceUp = !card.isFaceup;
    }
}


- (Card *)cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? self.cards[index] : nil;
}


@end
