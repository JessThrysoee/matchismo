//
//  SetCard.h
//  Matchismo
//
//  Created by Jess Thrysoee on 12/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;  // [1-3]
@property (nonatomic) NSUInteger symbol;  // [1-3]
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;

- (int)match:(NSArray *)otherCards;

@end
