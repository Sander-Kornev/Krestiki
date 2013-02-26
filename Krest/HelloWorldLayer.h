//
//  HelloWorldLayer.h
//  Krest
//
//  Created by ITC on 18.02.13.
//  Copyright ITC 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "GameScene.h"

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
