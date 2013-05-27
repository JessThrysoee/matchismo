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

@interface CardGameViewController : UIViewController <CardRendererProtocol>

// TODO remove
//- (void)updateUIForButton:(UIButton *)button card:(Card *)card;

-(Deck*)createDeck;  // abstract
@property (nonatomic) NSUInteger startingCardCount;   // abstract
-(void)updateCell:(UICollectionViewCell*)cell usingCard:(Card*)card;   // abstract

@end
