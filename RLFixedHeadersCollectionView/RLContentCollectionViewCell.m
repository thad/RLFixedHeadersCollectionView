//
//  RLContentCollectionViewCell.m
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

#import "RLContentCollectionViewCell.h"
#import "NSLayoutConstraint+RLAdditions.h"

static CGFloat const RLCollectionViewCellBorderWidth = .5f;

@interface RLContentCollectionViewCell ()

@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation RLContentCollectionViewCell

- (void)awakeFromNib{
    [self updateAppearance];
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:12.0f];
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.textLabel];
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
}

- (void)updateAppearance{
    if (self.isInSelectedColumn) {
        self.textLabel.textColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.0f;
        self.backgroundColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
    }
    else if(self.isInFirstOrLastColumn){
        self.textLabel.textColor = [UIColor whiteColor];
        self.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        self.layer.borderWidth = RLCollectionViewCellBorderWidth / [[UIScreen mainScreen] scale];
        self.backgroundColor = [UIColor grayColor];
    }
    else {
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        self.layer.borderWidth = RLCollectionViewCellBorderWidth / [[UIScreen mainScreen] scale];
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setText:(NSString *)text{
    _text = text;
    self.textLabel.text = text;
}

- (void)setIsInFirstOrLastColumn:(BOOL)isInFirstOrLastColumn{
    _isInFirstOrLastColumn = isInFirstOrLastColumn;
    
    [self updateAppearance];
}

- (void)setIsInSelectedColumn:(BOOL)isInSelectedColumn{
    _isInSelectedColumn = isInSelectedColumn;
    
    [self updateAppearance];
}

@end
