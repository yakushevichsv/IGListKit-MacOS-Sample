//
//  StatusBarView.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 12/28/16.
//  Copyright © 2016 Siarhei Yakushevich. All rights reserved.
//

#import "StatusBarView.h"

@implementation StatusBarView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (BOOL)wantsUpdateLayer {
    return YES;  // Tells NSView to call `updateLayer` instead of `drawRect:`
}

- (void)updateLayer {
    self.layer.backgroundColor = [NSColor controlColor].CGColor;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.wantsLayer = YES;
    [self setup];
}

- (void)setup {
    if (self.piActivityIndicator == nil) {
        NSProgressIndicator *pIndicator = [NSProgressIndicator new];
        pIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        pIndicator.style = NSProgressIndicatorSpinningStyle;
        pIndicator.controlTint = NSDefaultControlTint;
        pIndicator.displayedWhenStopped = NO;
        pIndicator.controlSize = NSControlSizeSmall;
        [self addSubview:pIndicator];
        [pIndicator sizeToFit];
        self.piActivityIndicator = pIndicator;
    }
    
    self.piActivityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    __block BOOL found = false;
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.firstItem == self.piActivityIndicator || obj.secondItem == self.piActivityIndicator) {
            found = YES;
            *stop = YES;
            
        }
    }];
    
    if (!found) {
        [self.piActivityIndicator.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        [self.piActivityIndicator.centerXAnchor constraintEqualToAnchor:self.trailingAnchor constant: -CGRectGetMaxX(self.piActivityIndicator.bounds)].active = YES;
    }
}

@end
