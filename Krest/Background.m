//
//  Background.m
//  Krest
//
//  Created by ITC on 19.02.13.
//  Copyright 2013 ITC. All rights reserved.
//

#import "Background.h"

#define HEIGHT_OF_LINE_PERC 0.75f
#define SIZE_FIGURE 160

@interface Background()

@end

@implementation Background

- (id)init
{
    if ( self = [super initWithColor:ccc4(255,255,255,255)])
    {
       /* CGSize size = [[CCDirector sharedDirector] winSize];
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

        */

    }
    return self;
}

-(void)draw
{
    [super draw];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    CGSize sizeInPixels = [[CCDirector sharedDirector] winSizeInPixels];
    int pixelsInPoint = sizeInPixels.height/size.height;
    self.figureInPoints = SIZE_FIGURE/pixelsInPoint;
    self.startHeight = size.height*(1 - HEIGHT_OF_LINE_PERC)/2;
    self.startWidth = size.width/2 - size.height*HEIGHT_OF_LINE_PERC/2;
    glLineWidth(10); 
    ccDrawColor4B(0, 0, 0, 255); 
    //draw vertikal line
    for (int i = 0; i < 2; i++) {
        ccDrawLine(ccp(size.width/2 - self.figureInPoints/2 + i*self.figureInPoints , self.startHeight), ccp(size.width/2 - self.figureInPoints/2 + i*self.figureInPoints , size.height - self.startHeight));
    }
    //draw horizont line
    for (int i = 0; i < 2; i++) {
        ccDrawLine(ccp(self.startWidth, size.height/2 - self.figureInPoints/2 + i*self.figureInPoints), ccp(size.width - self.startWidth, size.height/2 - self.figureInPoints/2 + i*self.figureInPoints));
    }
}


@end
