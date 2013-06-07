//
//  SetCardView.h
//  Matchismo
//
//  Created by Jess Thrysoee on 18/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UICollectionViewCell

@property (nonatomic) NSUInteger number;  // [1-3]
@property (nonatomic) NSUInteger symbol;  // [1-3]
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;

@property (nonatomic, readonly, getter=isThumb) BOOL thumb; // is this a thumbnail sized view
@property (nonatomic) BOOL faceUp;

-(void)blankCard;

@end
