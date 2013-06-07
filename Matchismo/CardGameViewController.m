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
@property (weak, nonatomic) IBOutlet UIButton *drawButton;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) FlipResult *flipResult;
@property (readonly, nonatomic) NSUInteger matchCount;
@property (strong, nonatomic) NSMutableArray *selectedCards;
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
    NSLog(@"Section index %d, cardCount %d", section, self.game.cardCount);
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


- (FlipResult *)flipResult
{
    if (!_flipResult)
    {
        _flipResult = [[FlipResult alloc] initWithCardRenderer:self];
    }

    return _flipResult;
}


- (NSMutableArray *)selectedCards
{
    if (!_selectedCards)
    {
        _selectedCards = [[NSMutableArray alloc] init];
    }

    return _selectedCards;
}


- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];

    if (indexPath)
    {
        [self.game flipCardAtIndex:indexPath.item];

        for (int i = 0; i < [self.game cardCount]; i++)
        {
        }

        Card *card = [self.game cardAtIndex:indexPath.item];

        if (card.isUnplayable)
        {
            [self.selectedCards removeAllObjects];
        }
        else if ([self.selectedCards count] - 1 == self.matchCount && card.isFaceup)
        {
            [self.selectedCards removeAllObjects];
        }

        if (card.isFaceup)
        {
            [self.selectedCards addObject:card];
        }
        else
        {
            [self.selectedCards removeObject:card];
        }

        [self updateUI];
    }
}


- (void)updateUI
{
    for (UICollectionViewCell *cell in[self.cardCollectionView visibleCells])
    {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];

        if (card.isUnplayable)
        {
            // TODO only for set cards -- it should be in child class
            [self.game removeCardAtIndex:indexPath.item];
            [self.cardCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
        else
        {
            [self updateCell:cell usingCard:card];
        }
    }

    for (int i = 0; i < 3; i++)
    {
        if (i < [self.selectedCards count])
        {
            [self updateCardView:[self.view viewWithTag:i + 1] usingCard:[self.selectedCards objectAtIndex:i]];
        }
        else
        {
            [self updateCardView:[self.view viewWithTag:i + 1] usingCard:nil];
        }
    }

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultLabel.attributedText = self.flipResult.lastResult;
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
}


- (void)resetSelectedCardViews
{
    self.selectedCards = nil;

    for (int i = 0; i < 3; i++)
    {
        [self updateCardView:[self.view viewWithTag:i + 1] usingCard:nil];
    }
}


- (void)reset
{
    self.deck = nil;
    self.game = nil;
    self.flipResult = nil;
    self.drawButton.enabled = YES;

    [self resetSelectedCardViews];

    [self.cardCollectionView
     performBatchUpdates: ^{
         NSMutableArray *indexPaths = [[NSMutableArray alloc] init];

         for (int i = self.startingCardCount; i < [self.cardCollectionView
                                                  numberOfItemsInSection:0]; i++)
         {
            [indexPaths addObject:[NSIndexPath indexPathForItem:i
                                                      inSection:0]];
         }

         [self.cardCollectionView
          deleteItemsAtIndexPaths:indexPaths];
     }


              completion:nil];

    [self updateUI];
}


#define DRAW_NUMBER_OF_CARDS 7

- (IBAction)drawCards:(UIButton *)sender
{
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
                self.drawButton.userInteractionEnabled = NO;
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
              }


    ];
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