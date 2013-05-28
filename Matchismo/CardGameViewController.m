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
#import "PlayingCardCollectionViewCell.h"
#import "PlayingCardView.h"
#import "SetCardCollectionViewCell.h"

@interface CardGameViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) FlipResult *flipResult;
@property (readonly, nonatomic) NSUInteger matchCount;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@end

@implementation CardGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self cardCollectionView].collectionViewLayout.section
}

#define MARGIN 20

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(MARGIN, MARGIN,MARGIN,MARGIN);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // TODO
    return self.startingCardCount; // return [myDataModel count];
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    
    return cell;
}

-(Deck*)createDeck
{
    // abstract
    return nil;
}

-(void)updateCell:(UICollectionViewCell*)cell usingCard:(Card*)card
{
    // abstract
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                 matchCount:self.matchCount
                                                  usingDeck:[self createDeck]
                                                 flipResult:self.flipResult];
    }
    
    return _game;
}


- (FlipResult *)flipResult
{
    if (!_flipResult)
    {
        _flipResult = [[FlipResult alloc] initWithCardRenderer:self];
    }
    
    return _flipResult;
}


- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath * indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath)
    {
        [self.game flipCardAtIndex:indexPath.item];
        [self updateUI];
        
    }
}



- (void)updateUI
{
    
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells])
    {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
        
        
    }
//    for (UIButton *cardButton in self.cardButtons)
//    {
//        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
//        
//        cardButton.selected = card.isFaceup;
//        cardButton.enabled = !card.isUnplayable;
//        
//        [self updateUIForButton:cardButton card:card];
//    }
//    
//    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
//    self.resultLabel.attributedText = self.flipResult.lastResult;
//    self.resultLabel.textAlignment = NSTextAlignmentCenter;
}


- (void)updateUIForButton:(UIButton *)button card:(Card *)card
{
}


- (void)reset
{
    self.game = nil;
    self.flipResult = nil;
    [self updateUI];
}


- (IBAction)deal
{
    [self reset];
}


- (NSAttributedString *)renderCard:(Card *)card
{
    return [[NSAttributedString alloc] initWithString:card.contents];
}


@end
