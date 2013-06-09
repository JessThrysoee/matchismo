//
//  MatchGameViewController.m
//  Matchismo
//
//  Created by Jess Thrysoee on 11/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "MatchGameViewController.h"
#import "PlayingCardCollectionViewCell.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface MatchGameViewController ()
@property (readonly, nonatomic) NSUInteger matchCount;
@end

@implementation MatchGameViewController
@synthesize deck = _deck;
@synthesize flipResult = _flipResult;

#define MATCH_COUNT      2
#define START_CARD_COUNT 22

- (NSUInteger)matchCount
{
    return MATCH_COUNT;
}


- (Deck *)deck
{
    if (!_deck)
    {
        _deck = [[PlayingCardDeck alloc] init];
    }

    return _deck;
}


- (FlipResult *)flipResult
{
    if (!_flipResult)
    {
        _flipResult = [[FlipResult alloc] initWithCardRenderer:self];
    }

    return _flipResult;
}


- (NSUInteger)startingCardCount
{
    return START_CARD_COUNT;
}


- (BOOL)removeUnplayable
{
    return NO;
}


- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]])
    {
        PlayingCardView *cardView = ((PlayingCardCollectionViewCell *)cell).cardView;

        if ([card isKindOfClass:[PlayingCard class]])
        {
            PlayingCard *playingCard = (PlayingCard *)card;
            cardView.suit = playingCard.suit;
            cardView.rank = playingCard.rank;
            cardView.faceUp = playingCard.isFaceup;
            cardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}


@end
