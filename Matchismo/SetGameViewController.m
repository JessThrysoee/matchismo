//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Jess Thrysoee on 11/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCard.h"
#import "SetCardDeck.h"
#import "SetCardCollectionViewCell.h"

@interface SetGameViewController ()
@property (readonly, nonatomic) NSUInteger matchCount;
@end

@implementation SetGameViewController
@synthesize deck = _deck;
@synthesize flipResult = _flipResult;

#define MATCH_COUNT      3
#define START_CARD_COUNT 12


- (Deck *)deck
{
    if (!_deck)
    {
        _deck = [[SetCardDeck alloc] init];
    }

    return _deck;
}


- (FlipResult *)flipResult
{
    if (!_flipResult)
    {
        _flipResult = [[FlipResult alloc] initWithCardRenderer:nil];
    }

    return _flipResult;
}


- (NSUInteger)startingCardCount
{
    return START_CARD_COUNT;
}


- (BOOL)removeUnplayable
{
    return YES;
}


- (void)updateUI
{
    [super updateUI];
    [self updateThumbCardViews];
}


- (void)updateThumbCardViews
{
    for (int i = 0; i < 3; i++)
    {
        if (i < [self.flipResult.cards count])
        {
            [self updateCardView:[self.view viewWithTag:i + 1] usingCard:[self.flipResult.cards objectAtIndex:i]];
        }
        else
        {
            [self updateCardView:[self.view viewWithTag:i + 1] usingCard:nil];
        }
    }
}


- (void)updateCardView:(UIView *)view usingCard:(Card *)card
{
    if ([view isKindOfClass:[SetCardView class]])
    {
        SetCardView *cardView = (SetCardView *)view;

        if ([card isKindOfClass:[SetCard class]])
        {
            SetCard *setCard = (SetCard *)card;
            cardView.number = setCard.number;
            cardView.symbol = setCard.symbol;
            cardView.color = setCard.color;
            cardView.shading = setCard.shading;
            cardView.star = setCard.star;

            cardView.faceUp = setCard.isFaceup;
        }
        else
        {
            [cardView blankCard];
        }
    }
}


- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]])
    {
        SetCardView *cardView = ((SetCardCollectionViewCell *)cell).cardView;

        [self updateCardView:cardView usingCard:card];
    }
}


- (NSUInteger)matchCount
{
    return MATCH_COUNT;
}


@end
