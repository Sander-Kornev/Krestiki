//
//  GameScene.m
//  Krest
//
//  Created by ITC on 18.02.13.
//  Copyright 2013 ITC. All rights reserved.
//

#import "GameScene.h"
@interface GameScene()
@property int number;
@property NSMutableArray* items;
@property int player;
@property int numberOfPlayers;
@property BOOL computerMoved;
@property Background* background;
@end

@implementation GameScene


- (id)init
{
    if ( self = [super init])
    {
        [self loadDefault];
        [self startGame];
    }
    return self;
}

- (void)loadDefault
{
    self.background = [Background node];
    [self addChild:self.background];
    self.numberOfPlayers = [[[NSUserDefaults standardUserDefaults] valueForKey: @"NumberOfPlayers"] integerValue];
    self.player = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Player"] integerValue];
    self.number = 0;
    self.computerMoved = NO;
    self.items = [NSMutableArray new];
    self.items = [[NSMutableArray alloc] initWithCapacity: 3];
    for (int i = 0; i < 3; i++) {
        [self.items insertObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil] atIndex:i];
    }
}

- (void)startGame
{
    if (self.numberOfPlayers == 0)//user choose computer game
    {
        [self schedule:@selector(makeMotion) interval:1 ];
    } else if (self.numberOfPlayers == 1)//user choose 1 player
    {
        if (self.player == 1)// user is 1-st player
        {
            [self touchEnable];
        } else if (self.player == 2)// user is 2-st player
        {
            [self schedule:@selector(makeMotion) interval:0 repeat:0 delay:1];
        }
    } else if (self.numberOfPlayers == 2)//user will play with another user
    {
        [self touchEnable];
    }
}

- (void)onExit
{
    [super onExit];
    [self touchDisable];
}

#pragma mark - CCTouchOneByOneDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace: touch];
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            CGRect rect = CGRectMake(self.background.startWidth + self.background.figureInPoints * i, self.background.startHeight + self.background.figureInPoints * j, self.background.figureInPoints, self.background.figureInPoints);
            if (CGRectContainsPoint(rect, location) && [self.items[i][j] integerValue] == 0) {
                [self drawFigureeWithI:i J:j];
                break;
            }
        }
    }
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.number %2 == 1 && self.player == 1 && self.numberOfPlayers == 1) {
        [self touchDisable];
        [self schedule:@selector(makeMotion) interval:0 repeat:0 delay:1];
    } else if (self.number %2 == 0 && self.player == 2 && self.numberOfPlayers == 1) {
        [self touchDisable];
        [self schedule:@selector(makeMotion) interval:0 repeat:0 delay:1];
    }
}

- (void)touchEnable
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)touchDisable
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

#pragma mark - Drawing

- (void)drawFigureeWithI:(int)i J:(int)j
{
    CCSprite* figure;
    if (self.number %2 == 0)
    {
        figure = [[CCSprite alloc] initWithFile: @"krest.png"];
        self.items[i][j] = [NSNumber numberWithInt: 1];
    } else {
        figure = [[CCSprite alloc] initWithFile: @"krug.png"];
         self.items[i][j] = [NSNumber numberWithInt: -1];
    }
    CGPoint point = ccp(self.background.startWidth + self.background.figureInPoints * (i + 0.5)  , self.background.startHeight + self.background.figureInPoints * (j + 0.5));
    [figure setPosition:point];
    [self addChild:figure];
    [self checkForWinOrDrawForI:i J:j];
    self.number++;
    if (self.numberOfPlayers == 1 && self.computerMoved) {
        [self touchEnable];
        self.computerMoved = NO;
    }
}

#pragma mark - Checking for result

- (void)checkForWinOrDrawForI:(int)i J:(int)j
{
    int player = self.number%2 +1;
    NSString* winTable = Nil;
    if ([self winPlayer:player ForI:i J:j inArray:self.items]) {
        if (player == 1) {
            winTable = @"Krestik win";
        } else {
            winTable = @"Nolik win";
        }
    };
    if (winTable)
    {
        [self showFinalTitle:winTable];
    } else if ([self checkForDraw])
    {
        [self showFinalTitle:@"Draw"];
    }
}

- (BOOL)winPlayer:(int)player ForI:(int)i J:(int)j inArray:(NSMutableArray*)items
{
    NSMutableArray* array = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        NSMutableArray* row = [items objectAtIndex:i];
        [array insertObject:[row mutableCopy] atIndex:i];
    }
    int number = [self numberForPlayer:player];
    array[i][j] = [NSNumber numberWithInt:number];
    //check row
    for (int i = 0; i < 3; i++) {
        if ([array[i][0] isEqual:array[i][1]] && [array[i][0] isEqual:array[i][2]])
        {
            if ([array[i][0] integerValue] == number)
            {
                return YES;
            }
        }
    }
    //check column
    for (int i = 0; i < 3; i++) {
        if ([array[0][i] isEqual:array[1][i]] && [array[0][i] isEqual:array[2][i]])
        {
            if ([array[0][i] integerValue] == number)
            {
                return YES;
            }
        }
    }
    //check diagonal
    if (([array[0][0] isEqual:array[1][1]] && [array[0][0] isEqual:array[2][2]])||
        ([array[0][2] isEqual:array[1][1]] && [array[0][2] isEqual:array[2][0]]))
    {
        if ([array[1][1] integerValue] == number)
        {
            return YES;
        }
    }
    array = nil;
    return NO;
}

- (BOOL)checkForDraw
{
    BOOL draw = YES;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            draw &= ([self.items[i][j] integerValue] != 0);
        }
    }
    return draw;
}

- (void)showFinalTitle:(NSString*)title
{
    [self unscheduleAllSelectors];
    [self touchDisable];
    FinalScene* background = [FinalScene node];
    background.title = title;
    [self addChild:background];
}

/*- (void)checkWarning:(int)alien
{
   
    for (int i = 0; i < 3; i++) {
        int sum = 0;
        for (int j = 0; j < 3; j++) {
            if ([self.items[i][j] integerValue] == alien)
            {
                sum++;
            }
        }
        NSLog(@"for column %i %i",i,sum);
    }
}*/

#pragma mark - Computer Brain

- (void)makeMotion
{
    self.computerMoved = YES;
    if (self.numberOfPlayers == 0)
    {
        if (self.number %2 == 0) {
            [self makeMotionForPlayer:1];
        } else if (self.number %2 == 1) {
           [self makeMotionForPlayer:2];
        } else {
            NSLog(@"something wrong in makeMotion");
        }
    } else if (self.numberOfPlayers == 1)
    {
        [self makeMotionForPlayer:[self anotherPlayer:self.player]];
    }
}

- (void)makeMotionForPlayer:(int)player
{
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            //if I can win
            if ([self.items[i][j] integerValue] == 0 && [self winPlayer:player ForI:i J:j inArray:self.items]) {
                [self drawFigureeWithI:i J:j];
                NSLog(@"I win");
                return;
            }
        }
    }
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            //if I can lose
            if ([self.items[i][j] integerValue] == 0 && [self winPlayer:[self anotherPlayer:player] ForI:i J:j inArray:self.items]) {
                [self drawFigureeWithI:i J:j];
                NSLog(@"I can't lose");
                return;
            }
        }
    }
    //make move to center
    if ([self.items[1][1] integerValue] == 0) {
        [self drawFigureeWithI:1 J:1];
        NSLog(@"Go to center");
        return;
    }
    //move to corner
    for (int count = 0 ;count < 10 ;count++) {
        int i = [self change1to2:(arc4random() % 2)];
        int j = [self change1to2:(arc4random() % 2)];
        if ([self.items[i][j] integerValue] == 0)
        {
            [self drawFigureeWithI:i J:j];
            NSLog(@"Go to corner");
            return;
        }
    }
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            //go anywhere
            if ([self.items[i][j] integerValue] == 0) {
                [self drawFigureeWithI:i J:j];
                NSLog(@"Go anywhere");
                return;
            }
        }
    }
    NSLog(@"Something wrong in MakeMotionForPlayer");
    return;
}

#pragma mark - small functions

- (int)anotherPlayer:(int)player
{
    if (player == 1) {
        return 2;
    } else if (player == 2)
    {
        return 1;
    }
    NSLog(@"Something wrong in AbotherPlayer");
    return nil;
}

- (int)change1to2:(int)in
{
    if(in == 0)
    {
        return 0;
    } else if (in == 1) {
        return 2;
    }
    NSLog(@"Error in function Change1to2. In is %i",in);
    return nil;
}

- (int)numberForPlayer:(int)player
{
    int alien = 0;
    if (player == 1) {
        return alien = 1;
    } else if (player == 2)
    {
        return alien = -1;
    }
    NSLog(@"Error in function NumberForPlayer. Player is %i",player);
    return nil;
}

@end
