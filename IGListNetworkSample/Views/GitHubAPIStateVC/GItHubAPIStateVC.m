//
//  GItHubAPIStateVC.m
//  IGListNetworkSample
//
//  Created by Siarhei Yakushevich on 1/4/17.
//  Copyright © 2017 Siarhei Yakushevich. All rights reserved.
//

#import "GItHubAPIStateVC.h"

@interface GItHubAPIStateVC ()
@property (nonatomic, weak) IBOutlet NSTextField* lblApiName;
@property (nonatomic, weak) IBOutlet NSTextField* lblApiStatus;
@property (nonatomic, weak) IBOutlet NSTextField* lblResetDiff;

@end

@implementation GItHubAPIStateVC

@synthesize searchTotalLimit = _searchTotalLimit;
@synthesize searchLeftLimit = _searchLeftLimit;
@synthesize timeLeftToReset = _timeLeftToReset;
@synthesize dateToReset = _dateToReset;

- (void)setSearchTotalLimit:(NSInteger)searchTotalLimit {
    if (_searchTotalLimit != searchTotalLimit) {
        _searchTotalLimit = searchTotalLimit;
        [self defineAPIStatusLabel];
    }
}

- (void)setSearchLeftLimit:(NSInteger)searchLeftLimit {
    if (_searchLeftLimit != searchLeftLimit) {
        _searchLeftLimit = searchLeftLimit;
        [self defineAPIStatusLabel];
    }
}

- (void)setDateToReset:(NSDate *)dateToReset {
    //if (![_dateToReset isEqualToDate:dateToReset]) {
        _dateToReset = dateToReset;
        NSTimeInterval diff = [dateToReset timeIntervalSinceDate:[NSDate date]];
        [self setTimeLeftToReset:(NSInteger)floor(diff)];
    //}
}

- (void)setTimeLeftToReset:(NSInteger)timeLeftToReset {
    if (_timeLeftToReset != timeLeftToReset) {
        _timeLeftToReset = timeLeftToReset;
        [self defineResetDiffLabel];
    }
}

- (void)defineAPIStatusLabel {
    if (!self.isViewLoaded) return ;
    
    NSMutableString *templateStr = [NSLocalizedString(@"Used requests", @"") mutableCopy];
    NSString *separator = @":";
    NSString *pair = [NSString stringWithFormat:@"%ld/%ld", (long)self.searchLeftLimit, (long)self.searchTotalLimit];
    NSString *fString = [[templateStr stringByAppendingString: separator] stringByAppendingString:pair];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString: fString];
    
    NSRange sRange = [fString rangeOfString:separator];
    NSRange fRange = [fString rangeOfString:@"/"];
    
    [str setAttributes:@{NSForegroundColorAttributeName: [NSColor redColor] } range:NSMakeRange(NSMaxRange(sRange) - 1, NSMaxRange(fRange) - NSMaxRange(sRange))];
    
    NSRange range2 = NSMakeRange(NSMaxRange(fRange) , str.length - NSMaxRange(fRange));
    
    [str setAttributes:@{NSFontAttributeName: [NSFont boldSystemFontOfSize:self.lblApiStatus.font.pointSize] } range: range2];
    
    self.lblApiStatus.attributedStringValue = str;
}

- (void)defineResetDiffLabel {
    if (!self.isViewLoaded) return ;
    
    NSString *timeLeft = NSLocalizedString(@"Time left", @"");
    NSInteger diff = MAX(self.timeLeftToReset,0);
    
    NSInteger remainder = diff % 60;
    NSInteger minutes = diff/60;
    
    NSString *separator = @" ";
    NSMutableString *str = [NSMutableString stringWithString:separator];
    
    if (minutes != 0 ) {
        [str appendString:[NSString stringWithFormat:@"%ld", (long)minutes]];
        [str appendString:separator];
        [str appendString:NSLocalizedString(@"minute", @"")];
        if (minutes > 1)
            [str appendString:@"s"];
        
        self.lblResetDiff.stringValue = [timeLeft stringByAppendingString:str];
    }
    else if (remainder != 0 ){
        [str appendString:[NSString stringWithFormat:@"%ld", (long)remainder]];
        [str appendString:separator];
        [str appendString:NSLocalizedString(@"second", @"")];
        if (remainder > 1)
            [str appendString:@"s"];
    
        self.lblResetDiff.stringValue = [timeLeft stringByAppendingString:str];
    }
    else  {
        self.lblResetDiff.stringValue = @"";
    }
}

- (void)defineAPINameLabel {
    if (!self.isViewLoaded) return ;
    
    self.lblApiName.stringValue = NSLocalizedString(@"GitHub Search API status", @"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self defineAPINameLabel];
    [self defineResetDiffLabel];
    [self defineAPIStatusLabel];
}



@end
