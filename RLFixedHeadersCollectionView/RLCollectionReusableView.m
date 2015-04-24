//
//  RLCollectionReusableView.m
//
//  Created by Thad McDowell
//  Copyright (c) 2015 Roaming Logic LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RLCollectionReusableView.h"
#import "NSLayoutConstraint+RLAdditions.h"

static CGFloat const RLCollectionReusableViewBorderWidth = .5f;

@interface RLCollectionReusableView ()

@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation RLCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.font = [UIFont systemFontOfSize:12.0f];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;

        
        [self addSubview:self.textLabel];
        
        NSDictionary *views = @{@"textLabel":self.textLabel};
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[textLabel]-4-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[textLabel]-4-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        
        [self addConstraints:constraints];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        [self updateAppearance];
    }
    
    return self;
}

- (void)updateAppearance{
    
    if (self.isInSelectedColumn) {
        self.textLabel.textColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.0f;
        self.backgroundColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
    }
    else{
        self.textLabel.textColor = [UIColor whiteColor];
        self.layer.borderWidth = RLCollectionReusableViewBorderWidth / [[UIScreen mainScreen] scale];
        self.backgroundColor = [UIColor darkGrayColor];
    }
}

- (void)setIsInSelectedColumn:(BOOL)isInSelectedColumn{
    _isInSelectedColumn = isInSelectedColumn;
    
    [self updateAppearance];
}

- (void)setText:(NSString *)text{
    _text = text;
    self.textLabel.text = text;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
    if ([self.delegate respondsToSelector:@selector(didSelectReusableViewCell:)]) {
        [self.delegate didSelectReusableViewCell:self];
    }
}

@end
