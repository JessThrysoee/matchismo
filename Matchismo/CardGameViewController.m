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
#import "FlipResult.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchCountControl;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic) int flipCount;
@property (strong, nonatomic)IBOutletCollection(UIButton) NSArray * cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) FlipResult *flipResult;
@end

@implementation CardGameViewController


- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                 matchCount:self.matchCountControl.selectedSegmentIndex == 0 ? 2:3
                                                  usingDeck:[[PlayingCardDeck alloc] init]
                                                 flipResult:self.flipResult];
    }
    
    return _game;
}


- (FlipResult *)flipResult
{
    if (!_flipResult)
    {
        _flipResult = [[FlipResult alloc] init];
    }
    
    return _flipResult;
}


- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"%3d", self.flipCount];
}


- (IBAction)flipCard:(UIButton *)sender
{
    NSUInteger index = [self.cardButtons indexOfObject:sender];
    
    self.matchCountControl.enabled = NO;
    [self.game flipCardAtIndex:index];
    
    if ([self.game cardAtIndex:index].isFaceup)
    {
        self.flipCount++;
    }
    
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
    self.resultLabel.text = self.flipResult.lastResult;
    
    // slider
    if (self.flipResult.count)
    {
        self.slider.maximumValue = self.flipResult.count;
        self.slider.value = self.slider.maximumValue;
        self.slider.enabled = YES;
        self.resultLabel.alpha = 1;
    }
    else
    {
        self.slider.maximumValue = 0;
        self.slider.value = 0;
        self.slider.enabled = NO;
    }
}


- (void)reset
{
    self.game = nil;
    self.flipResult = nil;
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


- (IBAction)sliderChanged:(UISlider *)sender
{
    int value;
    
    value = lroundf(sender.value);
    self.resultLabel.alpha = value < sender.maximumValue ? 0.5 : 1;
    
    if (value)
    {
        self.resultLabel.text = [self.flipResult resultAtIndex:value - 1];
    }
    else
    {
        self.resultLabel.text = @"";
    }
}


@end
