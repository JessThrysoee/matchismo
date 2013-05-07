//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Jess Thrysoee on 1/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchCountControl;
@property (nonatomic) int flipCount;
@property (strong, nonatomic)IBOutletCollection(UIButton) NSArray * cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController


- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                 matchCount:self.matchCountControl.selectedSegmentIndex == 0 ? 2:3
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
    }
    
    return _game;
}


- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"%3d", self.flipCount];
}


- (IBAction)flipCard:(UIButton *)sender
{
    self.matchCountControl.enabled = NO;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}


- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}


- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
        
        UIImage *cardBackImage = [UIImage imageNamed:@"cardBack.png"];
        UIImage *cardFrontImage = [[UIImage alloc] init];
        [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        [cardButton setImage:cardFrontImage forState:UIControlStateSelected];
        [cardButton setImage:cardFrontImage forState:UIControlStateSelected | UIControlStateDisabled];
        
        cardButton.selected = card.isFaceup;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%3d", self.game.score];
    self.resultLabel.text = self.game.lastFlipResult;
}


- (void)reset
{
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
}


- (IBAction)deal
{
    [self reset];
    self.matchCountControl.enabled = YES;
}


- (IBAction)changeMatchCount:(UISegmentedControl *)sender
{
    [self reset];
}


@end
