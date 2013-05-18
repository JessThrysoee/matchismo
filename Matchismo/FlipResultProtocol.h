//
//  FlipResultProtocol.h
//  Matchismo
//
//  Created by Jess Thrysoee on 18/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@protocol FlipResultProtocol <NSObject>

- (void)addMatchForCard:(Card *)card andCards:(NSArray *)otherCards withScore:(NSUInteger)score;
- (void)addMismatchForCard:(Card *)card andCards:(NSArray *)otherCard withScore:(NSUInteger)score;
- (void)addFlipForCard:(Card *)card;

@end
