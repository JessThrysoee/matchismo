//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Jess Thrysoee on 4/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "FlipResult.h"

@interface CardMatchingGame : NSObject

@property (readonly, nonatomic) int score;
@property (nonatomic, readonly) NSUInteger cardCount;

// designated initializer
- (id)initWithCardCount:(NSUInteger)cardCount
             matchCount:(NSUInteger)matchCount
              usingDeck:(Deck *)deck
             flipResult:(FlipResult *)flipResult;

- (void)flipCardAtIndex:(NSUInteger)index;

- (void)addCard:(Card *)card;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)removeCardAtIndex:(NSUInteger)index;
- (void)removeCardsInArray:(NSArray *)cards;

- (void)  addStarsToNextMatch;
- (void)  removeStars;

@end
