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
@property (strong, nonatomic) Deck *deck;
@end

@implementation SetGameViewController

#define MATCH_COUNT 3
#define START_CARD_COUNT 12


- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}


- (NSUInteger)startingCardCount
{
    return START_CARD_COUNT;
}

-(void)updateCell:(UICollectionViewCell*)cell usingCard:(Card*)card
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]])
    {
        SetCardView *cardView = ((SetCardCollectionViewCell *)cell).cardView;
        if ([card isKindOfClass: [SetCard class]]) {
            SetCard *setCard = (SetCard*)card;
            cardView.number = setCard.number;
            cardView.symbol = setCard.symbol;
            cardView.color = setCard.color ;
            cardView.shading = setCard.shading;
            
            cardView.faceUp = setCard.isFaceup;
            //cardView.alpha = setCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

- (NSUInteger)matchCount
{
    return MATCH_COUNT;
}



@end
