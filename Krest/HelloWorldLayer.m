//
//  HelloWorldLayer.m
//  Krest
//
//  Created by ITC on 18.02.13.
//  Copyright ITC 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

@interface  HelloWorldLayer()

@property CCMenuItem* item1Player;
@property CCMenuItem* item2Players;
@property CCMenuItem* itemComputers;
@property (nonatomic)  CCMenuItem* itemNolik;
@property (nonatomic)  CCMenuItem* itemKrestik;
@property BOOL optionShow;
@property CCMenu* menu;
@property CGSize size;
@end



#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( self=[super initWithColor:ccc4(255,255,0,145)]) {
        self.optionShow = NO;
        self.size = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Krestiki-Noliki" fontName:@"Marker Felt" fontSize:64];
        
        
        
        label.position =  ccp( self.size.width /2 , self.size.height - 30 );
        [self addChild: label];
        
        
        [CCMenuItemFont setFontSize:28];
        self.item1Player = [CCMenuItemFont itemWithString:@"1 player" target:self selector:@selector(press1Player)];
        
        self.item2Players = [CCMenuItemFont itemWithString:@"2 players" block:^(id sender) {
            [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"NumberOfPlayers"];
            [self touchDisable];
            AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
            [[app director] pushScene:[GameScene node]];
        }];
        self.itemComputers = [CCMenuItemFont itemWithString:@"Bot vs Bot" block:^(id sender) {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"NumberOfPlayers"];
            [self touchDisable];
            AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
            [[app director] pushScene:[GameScene node]];
        }];
        
        self.menu = [CCMenu menuWithItems:self.item1Player,self.item2Players, self.itemComputers, nil];
        
        self.menu.position = CGPointZero;
        self.menu.color = ccc3(0, 255, 0);
        self.item1Player.position = ccp( self.size.width/2,self.size.height - 80);
        self.item2Players.position = ccp(  self.size.width/2,self.size.height - 130);
        self.itemComputers.position = ccp( self.size.width/2,self.size.height - 180);
        [self addChild: self.menu];
        
        CCLabelTTF *autor = [CCLabelTTF labelWithString:@"by Sander" fontName:@"Marker Felt" fontSize:30];
        [autor setPosition:ccp( self.size.width/2 + 200, self.size.height/2 - 130)];
        [self addChild:autor];
        
        CCMenu *menuOption = [CCMenu menuWithItems:self.itemKrestik, self.itemNolik, nil];
        menuOption.position = CGPointZero;
        [self addChild:menuOption];
        
	}
	return self;
}



- (CCMenuItem*)itemNolik
{
    if (!_itemNolik) {
        _itemNolik = [CCMenuItemFont itemWithString:@"Nolik" block:^(id sender) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"NumberOfPlayers"];
            [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"Player"];
            [self touchDisable];
            AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
            [[app director] pushScene:[GameScene node]];
        }];
        
        _itemNolik.position = ccp(self.size.width/2, -50);
    }
    return _itemNolik;
}

- (CCMenuItem*)itemKrestik
{
    if (!_itemKrestik) {
        _itemKrestik = [CCMenuItemFont itemWithString:@"Krestik" block:^(id sender) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"NumberOfPlayers"];
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"Player"];
            [self touchDisable];
            AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
            [[app director] pushScene:[GameScene node]];
        }];
        _itemKrestik.position = ccp(self.size.width/2, -50);
    }
    return _itemKrestik;
}

- (void)press1Player
{
    if (!self.optionShow) {
        [self stopAllActions];
        self.optionShow = YES;
        id actionMove1 = [CCMoveTo actionWithDuration:0.3 position:ccp(self.size.width/2, self.size.height - 130)];
        id actionMove2 = [CCMoveTo actionWithDuration:0.5 position:ccp(self.size.width/2, self.size.height - 180)];
        [self.itemKrestik runAction:actionMove1];
        [self.itemNolik runAction:actionMove2];
        id actionMove3 = [CCMoveTo actionWithDuration:0.7 position:ccp(-50, self.size.height - 130)];
        id actionMove4 = [CCMoveTo actionWithDuration:0.8 position:ccp(self.size.width + 60, self.size.height - 180)];
        [self.item2Players runAction:actionMove3];
        [self.itemComputers runAction: [CCSequence actions:actionMove4, [CCCallBlock actionWithBlock:^{
            [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        }], nil]];
        
        self.menu.color = ccc3(255,255,255);
        self.itemKrestik.color = ccc3(0, 255, 0);
        self.itemNolik.color = ccc3(0, 255, 0);
    }
    
}

- (void)stopActions
{
    [self.item2Players stopAllActions];
    [self.itemComputers stopAllActions];
    [self.itemKrestik stopAllActions];
    [self.itemNolik stopAllActions];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

    [self stopAllActions];
    [self undoPress1Player];
    return YES;
}

- (void)undoPress1Player
{
    id actionMove1 = [CCMoveTo actionWithDuration:0.3 position:ccp(self.size.width/2, -30)];
    id actionMove2 = [CCMoveTo actionWithDuration:0.5 position:ccp(self.size.width/2, -30)];
    [self.itemKrestik runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.3], actionMove2, nil]];
    [self.itemNolik runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.3], actionMove1, nil]];
    id actionMove3 = [CCMoveTo actionWithDuration:0.5 position:ccp(self.size.width/2, self.size.height - 130)];
    id actionMove4 = [CCMoveTo actionWithDuration:0.7 position:ccp(self.size.width/2, self.size.height - 180)];
    [self.item2Players runAction:actionMove3];
    [self.itemComputers runAction:actionMove4];
    self.itemNolik.color = ccc3(255, 255, 255);
    self.itemKrestik.color = ccc3(255, 255, 255);
    self.menu.color = ccc3(0, 255, 0);
    self.optionShow = NO;
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

- (void)touchDisable
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

- (void)onEnter
{
    [super onEnter];
    if (self.optionShow) {
        [self undoPress1Player];
    }
}


- (void) dealloc
{
	[super dealloc];
}

@end
