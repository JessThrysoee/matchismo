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


- (NSUInteger)startingCardCount
{
    return START_CARD_COUNT;
}


- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]])
    {
        SetCardView *cardView = ((SetCardCollectionViewCell *)cell).cardView;
        
        if ([card isKindOfClass:[SetCard class]])
        {
            SetCard *setCard = (SetCard *)card;
            cardView.number = setCard.number;
            cardView.symbol = setCard.symbol;
            cardView.color = setCard.color;
            cardView.shading = setCard.shading;
            
            cardView.faceUp = setCard.isFaceup;
        }
    }
}


- (NSUInteger)matchCount
{
    return MATCH_COUNT;
}


@end
