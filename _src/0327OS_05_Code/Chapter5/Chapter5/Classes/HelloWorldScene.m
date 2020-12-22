//
//  HelloWorldScene.m
//  Chapter5
//
//  Created by Ben Trengrove on 11/08/2014.
//  Copyright Ben Trengrove 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------
@interface HelloWorldScene ()

@property (nonatomic, assign) BOOL dragging;
@property (nonatomic, assign) CGPoint dragOffset;

@end

@implementation HelloWorldScene
{
    CCSprite *_sprite;
    CCNodeColor *touchNode;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Add a sprite
    _sprite = [CCSprite spriteWithImageNamed:@"Icon-72.png"];
    _sprite.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    _sprite.anchorPoint = ccp(0.5, 0.5);
    [self addChild:_sprite z:1];

    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];

    touchNode = [CCNodeColor nodeWithColor:[CCColor blueColor] width:_sprite.boundingBox.size.width height:_sprite.boundingBox.size.height];
    touchNode.position = ccp(0, 0);
    [self addChild:touchNode z:2];
    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    CGPoint touchOffset = [touch locationInNode:_sprite];
    
    if (CGRectContainsPoint(_sprite.boundingBox, touchLoc)) {
        self.dragging = YES;
        NSLog(@"Start dragging");
        self.dragOffset = touchOffset;
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    if (self.dragging) {
        touchNode.position = touchLoc;
        
        CGPoint offsetPosition = ccpSub(touchLoc, self.dragOffset);
        CGPoint anchorPointOffset = CGPointMake(_sprite.anchorPoint.x * _sprite.boundingBox.size.width, _sprite.anchorPoint.y * _sprite.boundingBox.size.height);
        CGPoint positionWithAnchorPoint = ccpAdd(offsetPosition, anchorPointOffset);
        _sprite.position = positionWithAnchorPoint;
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    self.dragging = NO;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
