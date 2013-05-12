//
//  FlipResult.h
//  Matchismo
//
//  Created by Jess Thrysoee on 5/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardRenderer.h"
#import "Card.h"


@interface FlipResult : NSObject

- (id)initWithCardRenderer:(id<CardRenderer>)renderer;

@property (readonly, nonatomic) NSAttributedString *lastResult;
@property (readonly, nonatomic) NSUInteger count;

- (void)addMatchForCard:(Card *)card andCards:(NSArray *)otherCards withScore:(NSUInteger)score;
- (void)addMismatchForCard:(Card *)card andCards:(NSArray *)otherCard withScore:(NSUInteger)score;
- (void)addFlipForCard:(Card *)card;
- (NSString *)resultAtIndex:(NSUInteger)index;


@end
