//
//  FlipResult.m
//  Matchismo
//
//  Created by Jess Thrysoee on 5/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "FlipResult.h"

@interface FlipResult ()
@property (readwrite, nonatomic) NSAttributedString *lastResult;
@property (weak, nonatomic) id <CardRendererProtocol> renderer;

@property (strong, nonatomic) NSArray *cards;
@property (nonatomic) NSInteger score;
@end

@implementation FlipResult


- (NSAttributedString *)lastResult {
    if (!_lastResult) {
        _lastResult = [[NSAttributedString alloc] init];
    }
    return _lastResult;
}

- (id)initWithCardRenderer:(id<CardRendererProtocol>)renderer {
    self = [super init];
    
    if (self) {
        _renderer = renderer;
    }
    
    return self;
}

- (void)addMatchForCards:(NSArray *)cards withScore:(NSInteger)score {
    self.cards = cards;
    self.score = score;
    
    [self updateResultWithMatch];
}

- (void)addMismatchForCards:(NSArray *)cards withScore:(NSInteger)score {
    self.cards = cards;
    self.score = score;
    
    [self updateResultWithMismatch];
}

- (void)addFlipForCards:(NSArray *)cards {
    self.cards = cards;
    self.score = 0;
    
    [self updateResultWithFlip];
}

- (void)appendString:(NSString *)str to:(NSMutableAttributedString *)attrStr {
    NSAttributedString *tmp = [[NSAttributedString alloc] initWithString:str];
    
    [attrStr appendAttributedString:tmp];
}

- (void)updateResultWithMatch {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    if (!self.renderer)
    {
        [self appendString:[NSString stringWithFormat:@"Match! %d points", self.score] to:result];
    }
    else
    {
        [self appendString:@"Matched " to:result];
        
        NSString *delim = @"";
        for (Card *card in self.cards) {
            [self appendString:delim to:result];
            [result appendAttributedString:[self.renderer renderCard:card]];
            delim = @" & ";
        }
        
        [self appendString:[NSString stringWithFormat:@" for %d points", self.score] to:result];
    }
    
    self.lastResult = result;
}

- (void)updateResultWithMismatch {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    if (!self.renderer)
    {
        [self appendString:[NSString stringWithFormat:@"Not a match! %d point penalty", self.score] to:result];
    }
    else
    {
        NSString *delim = @"";
        for (Card *card in self.cards) {
            [self appendString:delim to:result];
            [result appendAttributedString:[self.renderer renderCard:card]];
            delim = @" & ";
        }
        
        [self appendString:[NSString stringWithFormat:@" don't match! %d point penalty", self.score] to:result];
    }
    
    self.lastResult = result;
}

- (void)updateResultWithFlip {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    if (self.renderer && [self.cards count])
    {
        [self appendString:@"Flipped up " to:result];
        
        [result appendAttributedString:[self.renderer renderCard:[self.cards lastObject]]];
    }
    
    self.lastResult = result;
}

@end
