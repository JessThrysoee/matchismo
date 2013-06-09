//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Jess Thrysoee on 4/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Deck.h"
#import "FlipResultProtocol.h"

#define FLIP_COST        -1
#define MISMATCH_PENALTY -2

@interface CardMatchingGame ()
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards;
@property (weak, nonatomic) id <FlipResultProtocol> flipResult;
@property (readonly, nonatomic) NSString *flipResultCount;
@property (strong, nonatomic) NSMutableArray *faceUpCards;
@property (nonatomic) NSUInteger matchCount;
@end


@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

- (NSMutableArray *)faceUpCards {
    if (!_faceUpCards) {
        _faceUpCards = [[NSMutableArray alloc] init];
    }
    
    return _faceUpCards;
}

- (void)updateFaceUpCards:(Card *)card {
    // book keeping
    if (card.isFaceup) {
        [self.faceUpCards addObject:card];
    } else {
        [self.faceUpCards removeObject:card];
    }
}

- (id)initWithCardCount:(NSUInteger)count
             matchCount:(NSUInteger)matchCount
              usingDeck:(Deck *)deck
             flipResult:(id <FlipResultProtocol>)flipResult {
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        
        self.matchCount = matchCount;
        self.flipResult = flipResult;
    }
    
    return self;
}

- (void)addCard:(Card *)card {
    [self.cards addObject:card];
}

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    NSUInteger score = 0;
    
    if (!card.isUnplayable) {
        card.faceUp = !card.isFaceup;
        
        NSArray *otherCards = [self.faceUpCards copy];
        [self updateFaceUpCards:card];
        
        if (card.isFaceup) {
            if ([otherCards count] == self.matchCount - 1) {
                int matchScore = [card match:otherCards];
                
                if (matchScore) {
                    for (Card *faceUps in self.faceUpCards) {
                        faceUps.unplayable = YES;
                    }
                    
                    score = matchScore;
                    self.score += score;
                    
                    [self.flipResult addMatchForCards:[self.faceUpCards copy] withScore:score];
                } else {
                    for (Card *faceUps in self.faceUpCards) {
                        faceUps.faceUp = NO;
                    }
                    
                    score = MISMATCH_PENALTY;
                    self.score += score;
                    
                    [self.flipResult addMismatchForCards:[self.faceUpCards copy] withScore:score];
                }
                
                [self.faceUpCards removeAllObjects];
            }
            
            
            self.score += FLIP_COST;
        }
        
        if (!score) {
            // no match or mismatch
            [self.flipResult addFlipForCards:[self.faceUpCards copy]];
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return index < [self.cards count] ? self.cards[index] : nil;
}

- (NSUInteger)cardCount {
    return [self.cards count];
}

- (void)removeCardAtIndex:(NSUInteger)index {
    [self.cards removeObjectAtIndex:index];
}

@end
