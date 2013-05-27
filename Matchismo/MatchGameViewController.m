//
//  MatchGameViewController.m
//  Matchismo
//
//  Created by Jess Thrysoee on 11/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "MatchGameViewController.h"
//#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardCollectionViewCell.h"
#import "PlayingCardView.h"

@interface MatchGameViewController ()
@property (readonly, nonatomic) NSUInteger matchCount;
@property (strong, nonatomic) Deck *deck;
@end

@implementation MatchGameViewController

#define MATCH_COUNT 2

- (NSUInteger)matchCount
{
    return MATCH_COUNT;
}


- (Deck *)deck
{
    return [[PlayingCardDeck alloc] init];
}


-(NSString*)reuseIdentifier
{
    return @"Card";
}

- (void)updateUIForButton:(UIButton *)button card:(Card *)card
{
    NSLog(@"not a button TODO");
//    if ([card isKindOfClass:[PlayingCard class]])
//    {
//        [button setTitle:card.contents forState:UIControlStateSelected];
//        [button setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
//        
//        UIImage *cardBackImage = [UIImage imageNamed:@"cardBack.png"];
//        UIImage *cardFrontImage = [[UIImage alloc] init];
//        [button setImage:cardBackImage forState:UIControlStateNormal];
//        [button setImage:cardFrontImage forState:UIControlStateSelected];
//        [button setImage:cardFrontImage forState:UIControlStateSelected | UIControlStateDisabled];
//        
//        button.alpha = card.isUnplayable ? 0.3 : 1.0;
//    }
}


@end
