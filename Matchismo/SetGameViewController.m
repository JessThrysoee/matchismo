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
#import <QuartzCore/QuartzCore.h>
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
        // TODO
        //cardCell.cardView.suit = @"K";
        //cardCell.cardView.rank = 2;
    }
}

- (void)updateUIForButton:(UIButton *)button card:(Card *)card
{
    if ([card isKindOfClass:[SetCard class]])
    {
        SetCard *setCard = (SetCard *)card;
        NSAttributedString *buttonTitle = [self renderCard:setCard];
        
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.cornerRadius = 10.0f;
        
        [button setAttributedTitle:buttonTitle forState:UIControlStateNormal];
        
        button.alpha = card.isUnplayable ? 0 : 1;
        
        if (card.isFaceup)
        {
            button.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        }
        else
        {
            button.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.1];
        }
    }
}


- (NSAttributedString *)renderCard:(Card *)plainCard
{
    NSString *plain = @"";
    
    SetCard *card = (SetCard *)plainCard;
    
    // solid
    UIColor *stroke = [self colors][card.color - 1];
    UIColor *fill = stroke;
    
    if (card.shading == 2)
    {
        // striped
        fill = [UIColor grayColor];
    }
    else if (card.shading == 3)
    {
        // open
        fill = [UIColor clearColor];
    }
    
    for (NSUInteger number = 0; number < card.number; number++)
    {
        plain = [plain stringByAppendingString:[self symbols][card.symbol - 1]];
    }
    
    return [[NSAttributedString alloc] initWithString:plain
                                           attributes:@{ NSForegroundColorAttributeName: fill,
                           NSStrokeColorAttributeName: stroke,
                           NSStrokeWidthAttributeName: @ - 10 }];
}


- (NSArray *)symbols
{
    static NSArray *symbols = nil;
    
    if (!symbols)
    {
        symbols = @[@"▲", @"●", @"■"]; // diamond, squiggle, oval
    }
    
    return symbols;
}


- (NSArray *)colors
{
    static NSArray *colors = nil;
    
    if (!colors)
    {
        colors = @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor]];  //(red, green, or purple)
    }
    
    return colors;
}


- (NSUInteger)matchCount
{
    return MATCH_COUNT;
}



@end
