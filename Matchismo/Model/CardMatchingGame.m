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

@property (strong, nonatomic) NSMutableArray *allCurrenMatches;
@property (nonatomic, assign) NSUInteger currentMatchesIndex;
@end


@implementation CardMatchingGame


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

- (void)updateFaceUpCards:(Card *)card {
    // book keeping
    if (card.isFaceup) {
        [self.faceUpCards addObject:card];
    } else {
        [self.faceUpCards removeObject:card];
    }
}

- (void)addCard:(Card *)card {
    [self.cards addObject:card];
    [self invalidateCurrentMatches];
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
                    [self.faceUpCards removeAllObjects];
                    
                    [self invalidateCurrentMatches];
                } else {
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    
                    score = MISMATCH_PENALTY;
                    self.score += score;
                    
                    [self.flipResult addMismatchForCards:[self.faceUpCards copy] withScore:score];
                    [self.faceUpCards removeAllObjects];
                    [self updateFaceUpCards:card];
                }
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
    [self invalidateCurrentMatches];
}

- (void)removeCardsInArray:(NSArray *)cards {
    [self.cards removeObjectsInArray:cards];
    [self invalidateCurrentMatches];
}

- (void)invalidateCurrentMatches {
    self.currentMatchesIndex = 0;
    self.allCurrenMatches = nil;
}

- (void)findCurrenMatches {
    if ([self.allCurrenMatches count]) {
        return;
    }
    
    NSMutableArray *set = [[NSMutableArray alloc] init];
    
    for (Card *card in self.cards) {
        if (!card.isUnplayable) {
            [set addObject:card];
        }
    }
    
    int len = [set count];
    
    for (int i = 0; i < len; i++) {
        for (int j = i + 1; j < len; j++) {
            for (int k = j + 1; k < len; k++) {
                if ([[set objectAtIndex:i] match:@[[set objectAtIndex:j], [set objectAtIndex:k]]]) {
                    [self.allCurrenMatches addObject:@[ [self cardAtIndex:i], [self cardAtIndex:j], [self cardAtIndex:k] ]];
                }
            }
        }
    }
}

- (void)addStarsToNextMatch {
    if (self.matchCount != 3) {
        return;
    }
    
    [self findCurrenMatches];
    
    if ([self.allCurrenMatches count])
    {
        ((Card *)(self.allCurrenMatches[self.currentMatchesIndex][0])).star = YES;
        ((Card *)(self.allCurrenMatches[self.currentMatchesIndex][1])).star = YES;
        ((Card *)(self.allCurrenMatches[self.currentMatchesIndex][2])).star = YES;
        
        self.currentMatchesIndex = (self.currentMatchesIndex + 1) % [self.allCurrenMatches count];
    }
}

- (void)removeStars {
    for (Card *card in self.cards) {
        card.star = NO;
    }
}

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

- (NSMutableArray *)allCurrenMatches {
    if (!_allCurrenMatches) {
        _allCurrenMatches = [[NSMutableArray alloc] init];
    }
    
    return _allCurrenMatches;
}

@end
