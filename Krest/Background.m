//
//  Background.m
//  Krest
//
//  Created by ITC on 19.02.13.
//  Copyright 2013 ITC. All rights reserved.
//

#import "Background.h"



@interface Background()

@end

@implementation Background

- (id)init
{
    if ( self = [super initWithColor:ccc4(255,255,255,255)])
    {
    }
    return self;
}

-(void)draw
{
    [super draw];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    int sizeFigure = SIZE_FIGURE*size.height;
    self.figureInPoints = sizeFigure;
    self.startHeight = size.height*(1 - HEIGHT_OF_LINE_PERC)/2;
    self.startWidth = size.width/2 - size.height*HEIGHT_OF_LINE_PERC/2;
    glLineWidth(SIZE_LINE*size.height);
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
