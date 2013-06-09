//
//  FlipResult.h
//  Matchismo
//
//  Created by Jess Thrysoee on 5/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardRendererProtocol.h"
#import "Card.h"
#import "FlipResultProtocol.h"


@interface FlipResult : NSObject <FlipResultProtocol>

- (id)initWithCardRenderer:(id<CardRendererProtocol>)renderer;

@property (readonly, nonatomic) NSAttributedString *lastResult;
@property (readonly, nonatomic) NSArray *cards;

@end
