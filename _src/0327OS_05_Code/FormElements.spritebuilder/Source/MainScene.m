//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@interface MainScene ()

@property (nonatomic, strong) CCTextField *textField;
@property (nonatomic, strong) CCSlider *slider;

@end
@implementation MainScene

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)onEnter {
    [super onEnter];

    [self.slider setBlock:^(id sender) {
        NSLog(@"Slider");
    }];
    
    [self.textField setBlock:^(id sender) {
        NSLog(@"Text field");
    }];
}

@end
