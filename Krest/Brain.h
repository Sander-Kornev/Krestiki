//
//  Brai.h
//  Krest
//
//  Created by ITC on 01.03.13.
//  Copyright 2013 ITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"
@class GameScene;

@interface Brain : CCLayer {
}
@property (strong) GameScene* gameScene;

- (BOOL)fieldIsEmptyOnI:(int)i J:(int)j;
- (void)nextMove;
- (void)drawFigureeWithI:(int)i J:(int)j;
- (void)startGame;

@end
