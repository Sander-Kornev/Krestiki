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
@end

@implementation GameScene


- (id)init
{
    if ( self = [super init])
    {
        Background* background = [Background node];
        [self addChild:background];
        self.numberOfPlayers = [[[NSUserDefaults standardUserDefaults] valueForKey: @"NumberOfPlayers"] integerValue];
        self.player = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Player"] integerValue];
        self.number = 0;
        self.computerMoved = NO;
        for (int i = 0; i < 9; i++) {
            self.items[i] = 0;
        }
        self.items = [NSMutableArray new];
        self.items = [[NSMutableArray alloc] initWithCapacity: 3];
        for (int i = 0; i < 3; i++) {
            [self.items insertObject:[NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil] atIndex:i];
        }
        if (self.numberOfPlayers == 0)
        {
            [self schedule:@selector(makeMotion) interval:1 ];
        } else if (self.numberOfPlayers == 1)
        {
            if (self.player == 1)
            {
                [self touchEnable];
            } else if (self.player == 2)
            {
                [self schedule:@selector(makeMotion) interval:0 repeat:0 delay:1];
            }
        } else if (self.numberOfPlayers == 2)
        {
            [self touchEnable];
        }

    }
    return self;

}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace: touch];
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            CGRect rect = CGRectMake(164 + i * 80, 38 + j * 80, 80, 80);
            if (CGRectContainsPoint(rect, location) && [self.items[i][j] integerValue] == 0) {
                [self drawFigureeWithI:i J:j];
                break;
            }
        }
    }
    return YES;
}

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
    figure.position = ccp( 204 + i * 80  , 78 + j * 80 );
    [self addChild:figure];
    [self checkForWinOrDrawForI:i J:j];
    self.number++;
    if (self.numberOfPlayers == 1 && self.computerMoved) {
        [self touchEnable];
        self.computerMoved = NO;
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
    CCLabelTTF *label = [CCLabelTTF labelWithString:title fontName:@"Marker Felt" fontSize:64];
    label.color = ccc3(255, 0, 0);
    label.position = ccp(300, 0);
    [self addChild:label];
    //[CCMenuItemFont setFontSize:30];
    CCMenuItemFont* main = [CCMenuItemFont itemWithString:@"Go to Main Menu" target:self selector:@selector(mainMenu)];
    CCMenu* menu = [CCMenu menuWithItems:main, nil];
    menu.position = CGPointZero;
    main.position = ccp(100, 150);
    menu.color = ccc3(0, 0, 255);
    [self addChild:menu];
    id actionMove = [CCMoveTo actionWithDuration:2 position:CGPointMake(300, 280)];
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
    [[CCDirector sharedDirector] popScene];
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

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.number %2 == 1 && self.player == 1 && self.numberOfPlayers == 1) {
        [self touchDisable];
        [self schedule:@selector(makeMotion) interval:0 repeat:0 delay:1];
    } else if (self.number %2 == 0 && self.player == 2 && self.numberOfPlayers == 1) {
        [self touchDisable];
        [self schedule:@selector(makeMotion) interval:0 repeat:0 delay:1];
    }
}

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
    //[NSThread sleepForTimeInterval:1];
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

- (void)onExit
{
    [super onExit];
    [self touchDisable];
}


@end