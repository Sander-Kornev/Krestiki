//
//  Background.m
//  Krest
//
//  Created by ITC on 19.02.13.
//  Copyright 2013 ITC. All rights reserved.
//

#import "Background.h"


@implementation Background

- (id)init
{
    if ( self = [super initWithColor:ccc4(255,255,255,255)])
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        for (int i = 0; i < 2; i++) {
            CCSprite* vertLine = [[CCSprite alloc] initWithFile:@"vertLine.png"];
            vertLine.position = ccp( 80 * i + 244, size.height/2 );
            [self addChild:vertLine];
        }
        for (int i = 0; i < 2; i++) {
            CCSprite* horLine = [[CCSprite alloc] initWithFile:@"horLine.png"];
            horLine.position = ccp( size.width/2, 80 * i + 120 );
            [self addChild:horLine];
        }
    }
    return self;
}


@end
