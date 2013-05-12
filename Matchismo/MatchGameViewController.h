//
//  MatchGameViewController.h
//  Matchismo
//
//  Created by Jess Thrysoee on 11/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "CardGameViewController.h"

@interface MatchGameViewController : CardGameViewController

- (void)updateUI;
- (void)updateUIForButton:(UIButton *)button card:(Card *)card;

@end
