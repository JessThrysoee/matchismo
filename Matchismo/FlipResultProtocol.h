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

- (void)addMatchForCards:(NSArray *)cards withScore:(NSInteger)score;
- (void)addMismatchForCards:(NSArray *)cards withScore:(NSInteger)score;
- (void)addFlipForCards:(NSArray *)cards;

@end
