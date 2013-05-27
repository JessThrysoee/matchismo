//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Jess Thrysoee on 1/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "CardRendererProtocol.h"

@interface CardGameViewController : UIViewController <CardRendererProtocol>
@property (readonly, nonatomic) NSString * reuseIdentifier;

- (void)updateUIForButton:(UIButton *)button card:(Card *)card;

@end
