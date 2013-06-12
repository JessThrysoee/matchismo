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
#import "PlayingCardCollectionViewCell.h"
#import "PlayingCardView.h"
#import "SetCardCollectionViewCell.h"

@interface CardGameViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *drawButton;
@property (strong, nonatomic) CardMatchingGame *game;
@property (readonly, nonatomic) NSUInteger matchCount;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@end

@implementation CardGameViewController

#define MARGIN 20

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.game.cardCount;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];

    [self updateCell:cell usingCard:card];

    return cell;
}


- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    // abstract
}


- (void)updateCardView:(UIView *)view usingCard:(Card *)card
{
    //abstract
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
                                                  usingDeck:self.deck
                                                 flipResult:self.flipResult];
    }

    return _game;
}


- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];

    if (indexPath)
    {
        [self.game flipCardAtIndex:indexPath.item];
        [self updateUI];
    }
}


- (void)updateUI
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSMutableArray *unplayableCards = [[NSMutableArray alloc] init];

    for (int i = 0; i < [self.game cardCount]; i++)
    {
        Card *card = [self.game cardAtIndex:i];

        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];

        if (self.removeUnplayable && card.isUnplayable)
        {
            [unplayableCards addObject:[self.game cardAtIndex:i]];
            [indexPaths addObject:indexPath];
        }
        else
        {
            [self updateCell:[self.cardCollectionView cellForItemAtIndexPath:indexPath] usingCard:card];
        }
    }

    if ([indexPaths count])
    {
        [self.game removeCardsInArray:unplayableCards];
        [self.game removeStars];

        [self.cardCollectionView deleteItemsAtIndexPaths:indexPaths];
    }

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultLabel.attributedText = self.flipResult.lastResult;
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
}


- (void)reset
{
    self.deck = nil;
    self.game = nil;
    self.flipResult = nil;
    self.drawButton.enabled = YES;
    [self.cardCollectionView reloadData];
    [self updateUI];
}


#define DRAW_NUMBER_OF_CARDS 7

- (IBAction)drawCards:(UIButton *)sender
{
    if (![self.deck count])
    {
        self.drawButton.enabled = NO;
        return;
    }

    [self.cardCollectionView
     performBatchUpdates: ^{
         int cardCount = self.game.cardCount;
         NSMutableArray *indexPaths = [[NSMutableArray alloc] init];

         for (int i = cardCount; i < cardCount + DRAW_NUMBER_OF_CARDS; i++)
         {
            Card *card = [self.deck drawRandomCard];

            if (card)
            {
                [self.game
                 addCard:card];
                [indexPaths addObject:[NSIndexPath indexPathForItem:i
                                                          inSection:0]];
            }
            else
            {
                self.drawButton.enabled = NO;
            }
         }

         [self.cardCollectionView
          insertItemsAtIndexPaths:indexPaths];
     }


              completion: ^(BOOL finished) {
                  if (self.game.cardCount > 0)
                  {
                  NSIndexPath *lastItem = [NSIndexPath indexPathForItem:self.game.cardCount - 1
                                                        inSection:0];
                  [self.cardCollectionView
                   scrollToItemAtIndexPath:lastItem
                          atScrollPosition:UICollectionViewScrollPositionTop
                                  animated:YES];
                  }
              }];
}


- (IBAction)deal
{
    [self reset];
}


- (IBAction)cheat
{
    [self.game removeStars];
    [self.game addStarsToNextMatch];
    [self updateUI];
}


- (NSAttributedString *)renderCard:(Card *)card
{
    return [[NSAttributedString alloc] initWithString:card.contents];
}


@end