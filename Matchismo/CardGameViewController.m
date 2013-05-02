//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Jess Thrysoee on 1/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck *playingCardDeck;
@end

@implementation CardGameViewController

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}


- (IBAction)flipCard:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        [sender setTitle:[[self.playingCardDeck drawRandomCard] contents] forState:UIControlStateSelected];
    }
    
    self.flipCount++;
}


- (PlayingCardDeck *)playingCardDeck
{
    if (!_playingCardDeck)
    {
        _playingCardDeck = [[PlayingCardDeck alloc] init];
    }
    
    return _playingCardDeck;
}


@end
