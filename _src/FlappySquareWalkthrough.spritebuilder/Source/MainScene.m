//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

- (void)start {
    CCScene *gameplay = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] pushScene:gameplay withTransition:[CCTransition transitionFadeWithDuration:0.33]];
}

@end
