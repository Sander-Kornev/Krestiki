//
//  FinalScene.m
//  Krest
//
//  Created by ITC on 26.02.13.
//  Copyright 2013 ITC. All rights reserved.
//

#import "FinalScene.h"


@implementation FinalScene

- (id)init
{
    if ( self = [super init])
    {
        //[self drawing];
    }
    return self;
    
}

-(void)onEnter
{
    [super onEnter];
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCLabelTTF *label = [CCLabelTTF labelWithString:self.title fontName:@"Marker Felt" fontSize:SIZE_OF_TITLE * size.height];
    label.color = ccc3(255, 0, 0);
    label.position = ccp(size.width/2, 0);
    [self addChild:label];
    [CCMenuItemFont setFontSize:size.height * SIZE_OF_MENU * 0.8];
    CCMenuItemFont* main = [CCMenuItemFont itemWithString:@"Go to Main Menu" target:self selector:@selector(mainMenu)];
    CCMenu* menu = [CCMenu menuWithItems:main, nil];
    menu.position = CGPointZero;
    main.position = ccp(size.height * DISTANCE * 2, size.height - size.height * DISTANCE);
    menu.color = ccc3(0, 0, 255);
    [self addChild:menu];
    id actionMove = [CCMoveTo actionWithDuration:2 position:CGPointMake(size.width/2, size.height - size.height * DISTANCE)];
    [label runAction:[CCSequence actions:actionMove, [CCDelayTime actionWithDuration:2],
                      [CCCallFunc actionWithTarget:self selector:@selector(gameOverDone)],
                      nil]];
}

- (void)gameOverDone
{
	[[CCDirector sharedDirector] replaceScene:[GameScene node]] ;
}

- (void)mainMenu
{
    [[CCDirector sharedDirector] popToRootScene];
}

@end
