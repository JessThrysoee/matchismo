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

@property (strong, nonatomic) Deck* deck;
@property (nonatomic) NSUInteger startingCardCount;   // abstract
-(void)updateCell:(UICollectionViewCell*)cell usingCard:(Card*)card;   // abstract

@end
