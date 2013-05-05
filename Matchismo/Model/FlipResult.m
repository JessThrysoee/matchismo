//
//  FlipResult.m
//  Matchismo
//
//  Created by Jess Thrysoee on 5/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "FlipResult.h"

@interface FlipResult ()
@property (strong, nonatomic) NSMutableArray *results;
@end

@implementation FlipResult

- (NSMutableArray *)results
{
    if (!_results)
    {
        _results = [[NSMutableArray alloc] init];
    }
    
    return _results;
}

- (void)addMatchForCard: (Card*)card andCard:(Card*)otherCard withScore:(NSUInteger)score
{
    NSString *result =     [NSString stringWithFormat:@"Matched %@ & %@ for %d points", card.contents, otherCard.contents, score];
    [self.results addObject:result];

}


- (void)addMismatchForCard: (Card*)card andCard:(Card*)otherCard withScore:(NSUInteger)score
{
    NSString *result =[NSString stringWithFormat:@"%@ & %@ don't match! %d point penalty", card.contents, otherCard.contents, score];

    [self.results addObject:result];
    
}

- (void)addFlipForCard: (Card*)card
{
    NSString *result = result = [NSString stringWithFormat:@"Flipped up %@", card.contents];
    [self.results addObject:result];

}

- (NSString*)lastResult
{
    return [self.results lastObject];
}
@end
