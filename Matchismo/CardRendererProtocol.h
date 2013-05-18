//
//  CardRenderer.h
//  Matchismo
//
//  Created by Jess Thrysoee on 13/5-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@protocol CardRendererProtocol <NSObject>
- (NSAttributedString *)renderCard:(Card *)card;
@end
