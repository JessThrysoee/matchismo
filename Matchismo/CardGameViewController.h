//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Jess Thrysoee on 1/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "CardRenderer.h"

@interface CardGameViewController : UIViewController <CardRenderer>

- (void)updateUIForButton:(UIButton *)button card:(Card *)card;

@end
