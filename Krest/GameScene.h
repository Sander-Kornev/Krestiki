//
//  GameScene.h
//  Krest
//
//  Created by ITC on 18.02.13.
//  Copyright 2013 ITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCTouchDispatcher.h"
#import "Background.h"
#import "HelloWorldLayer.h"
#import "FinalScene.h"
#import "Brain.h"

@interface GameScene : CCScene <CCTouchOneByOneDelegate>
- (void)drawFigureeWithI:(int)i J:(int)j forPlayer:(int)player;
- (void)showFinalTitle:(NSString*)title;
@end
