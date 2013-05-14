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

@interface SetGameViewController ()
@property (readonly, nonatomic) NSUInteger matchCount;
@property (strong, nonatomic) Deck *deck;
@end

@implementation SetGameViewController

#define MATCH_COUNT 3


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


- (Deck *)deck
{
    return [[SetCardDeck alloc] init];
}


@end
