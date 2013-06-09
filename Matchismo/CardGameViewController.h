//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Jess Thrysoee on 1/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardRendererProtocol.h"
#import "Deck.h"
#import "FlipResult.h"

@interface CardGameViewController : UIViewController <CardRendererProtocol>

@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) FlipResult *flipResult;

- (void)updateUI;

@property (nonatomic) NSUInteger startingCardCount;   // abstract
@property (nonatomic) BOOL removeUnplayable;   // abstract

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card;   // abstract
- (void)updateCardView:(UIView *)view usingCard:(Card *)card;  //abstract

@end
