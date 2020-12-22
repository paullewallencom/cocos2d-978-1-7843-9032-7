//
//  MenuScene.m
//  Chapter2
//
//  Created by Ben Trengrove on 15/06/2014.
//  Copyright 2014 Ben Trengrove. All rights reserved.
//

#import "MenuScene.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "IntroScene.h"

@implementation MenuScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (MenuScene *)scene
{
	return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        CCPositionType positionType = CCPositionTypeMake(CCPositionUnitNormalized, CCPositionUnitNormalized, CCPositionReferenceCornerBottomLeft);
        
        CCButton *button = [CCButton buttonWithTitle:@"Start"];
        button.positionType = positionType;
        button.position = ccp(0.5, 0.5);
        [button setBlock:^(id sender) {
            [[CCDirector sharedDirector] pushScene:[IntroScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.33]];
        }];
        [self addChild:button];
    }
    return self;
}

@end
