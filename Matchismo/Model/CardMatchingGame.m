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
#define MISMATCH_PENALTY -2

@interface CardMatchingGame ()
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards;
@property (weak, nonatomic) FlipResult *flipResult;
@property (readonly, nonatomic) NSString *flipResultCount;
@property (nonatomic) NSUInteger matchCount;
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
             matchCount:(NSUInteger)matchCount
              usingDeck:(Deck *)deck
             flipResult:(FlipResult *)flipResult
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
        
        self.matchCount = matchCount;
        self.flipResult = flipResult;
    }
    
    return self;
}


- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSUInteger score = 0;
    NSMutableArray *otherCards = [[NSMutableArray alloc] init];
    
    if (!card.isUnplayable)
    {
        if (!card.isFaceup)
        {
            for (Card *otherCard in self.cards)
            {
                if (otherCard.isFaceup && !otherCard.isUnplayable)
                {
                    [otherCards addObject:otherCard];
                }
            }
            
            if (otherCards.count == self.matchCount - 1)
            {
                int matchScore = [card match:otherCards];
                
                if (matchScore)
                {
                    for (Card *otherCard in otherCards)
                    {
                        otherCard.unplayable = YES;
                    }
                    
                    card.unplayable = YES;
                    score = matchScore;
                    self.score += score;
                    [self.flipResult addMatchForCard:card andCards:otherCards withScore:score];
                }
                else
                {
                    for (Card *otherCard in otherCards)
                    {
                        otherCard.faceUp = NO;
                    }
                    
                    score = MISMATCH_PENALTY;
                    self.score += score;
                    [self.flipResult addMismatchForCard:card andCards:otherCards withScore:score];
                }
            }
            
            if (!score)
            {
                // no match or mismatch
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
