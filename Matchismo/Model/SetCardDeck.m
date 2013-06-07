//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Jess Thrysoee on 12/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];

    if (self)
    {
        for (NSUInteger number = 1; number <= 3; number++)
        {
            for (NSUInteger symbol = 1; symbol <= 3; symbol++)
            {
                for (NSUInteger shading = 1; shading <= 3; shading++)
                {
                    for (NSUInteger color = 1; color <= 3; color++)
                    {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;

                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }

    return self;
}


@end
