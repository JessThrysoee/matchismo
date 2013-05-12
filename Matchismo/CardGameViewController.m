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
@property (strong, nonatomic)IBOutletCollection(UIButton) NSArray * cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) FlipResult *flipResult;
@property (readonly, nonatomic) NSUInteger matchCount;
@property (strong, nonatomic) Deck *deck;
@end

@implementation CardGameViewController


- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                 matchCount:self.matchCount
                                                  usingDeck:self.deck
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
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}


- (IBAction)flipCard:(UIButton *)sender
{
    NSUInteger index = [self.cardButtons indexOfObject:sender];
    
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
        
        [self updateUIForButton:cardButton card:card];
        
        cardButton.selected = card.isFaceup;
        cardButton.enabled = !card.isUnplayable;
        // TODO maybe not for set, but only for playing card
        //cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultLabel.text = self.flipResult.lastResult;
}


- (void)updateUIForButton:(UIButton *)button card:(Card *)card
{
    
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
}

@end
