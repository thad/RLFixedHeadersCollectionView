//
//  RLFixedHeadersCollectionViewController.m
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

#import "RLFixedHeadersCollectionViewController.h"
#import "RLFixedHeadersCollectionViewLayout.h"
#import "RLContentCollectionViewCell.h"
#import "RLCollectionReusableView.h"

typedef NS_ENUM(NSInteger, RLFixedHeaderCollectionViewRow) {
    RLFixedHeaderCollectionViewRowHeader = 0,
    RLFixedHeaderCollectionViewRowContent
};

static CGFloat const RLFixedHeaderCollectionViewCellHeight = 50.0f;
static CGFloat const RLFixedHeaderCollectionViewCellMaxWidth = 50.0f;
static NSInteger const RLFixedHeaderCollectionViewSectionCount = 20;
static NSInteger const RLFixedHeaderCollectionViewRowCount = 25;

@interface RLFixedHeadersCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, RLCollectionReusableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) RLFixedHeadersCollectionViewLayout *collectionViewLayout;
@property (nonatomic) CGFloat collectionCellWidth;
@property (nonatomic) NSInteger currentSelectedColumn;

@end

@implementation RLFixedHeadersCollectionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.currentSelectedColumn = -1;
    [self setupCollectionViewLayout];
    [self updateLayoutItemSize];
}

- (void)setupCollectionViewLayout{
    self.collectionViewLayout = (RLFixedHeadersCollectionViewLayout *)self.collectionView.collectionViewLayout;
    
    [self.collectionView registerClass:[RLCollectionReusableView class] forSupplementaryViewOfKind:RLFixedHeadersSupplementaryViewKind[RLFixedHeadersSupplementaryViewTypeColumnHeader] withReuseIdentifier:RLCollectionReusableViewCellIdentifier];
    
    [self.collectionView registerClass:[RLCollectionReusableView class] forSupplementaryViewOfKind:RLFixedHeadersSupplementaryViewKind[RLFixedHeadersSupplementaryViewTypeRowHeader] withReuseIdentifier:RLCollectionReusableViewCellIdentifier];
}

- (void)updateLayoutItemSize{
    self.collectionCellWidth = MAX((self.collectionView.bounds.size.width - RLFixedHeadersRowHeaderWidth) / RLFixedHeaderCollectionViewSectionCount,RLFixedHeaderCollectionViewCellMaxWidth);
    self.collectionViewLayout.itemSize = CGSizeMake(self.collectionCellWidth, RLFixedHeaderCollectionViewCellHeight);
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return RLFixedHeaderCollectionViewSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return RLFixedHeaderCollectionViewRowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RLContentCollectionViewCell *cell = (RLContentCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RLContentCollectionViewCellIdentifier forIndexPath:indexPath];
    
    cell.isInFirstOrLastColumn = (indexPath.section == 0) ||
                                 (indexPath.section == RLFixedHeaderCollectionViewSectionCount - 1);
    cell.isInSelectedColumn = (_currentSelectedColumn == indexPath.section);
    
    if (indexPath.section == 0) {
        cell.text = [NSString stringWithFormat:@"R:%@ Header",@(indexPath.item)];
    }
    else if(indexPath.section == RLFixedHeaderCollectionViewSectionCount - 1){
        cell.text = [NSString stringWithFormat:@"T:%@",@(indexPath.item)];
    }
    else{
        cell.text = [NSString stringWithFormat:@"R:%@ C:%@",@(indexPath.item),@(indexPath.section)];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    RLCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:RLCollectionReusableViewCellIdentifier
                                                                                forIndexPath:indexPath];
    view.delegate = self;
    view.text = @"";
    view.isInSelectedColumn = (_currentSelectedColumn == indexPath.section);
    
    if (indexPath.row == RLFixedHeaderCollectionViewRowHeader) {
        if (indexPath.section == 0) {
            view.text = @"COLUMN";
        }
        else if(indexPath.section == RLFixedHeaderCollectionViewSectionCount - 1){
            view.text = @"TOT";
        }
        else{
            view.text = [NSString stringWithFormat:@"%@",@(indexPath.section)];
        }
    }
    return view;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > 0 & indexPath.section < RLFixedHeaderCollectionViewSectionCount - 1) {
        self.currentSelectedColumn = indexPath.section;
    }
}

#pragma mark - Private

- (void)setCurrentSelectedColumn:(NSInteger)currentSelectedColumn{
    _currentSelectedColumn = currentSelectedColumn;
    [self.collectionView reloadData];
}

#pragma mark - <RLCollectionReusableViewDelegate>

- (void)didSelectReusableViewCell:(RLCollectionReusableView *)reusableViewCell{
    
    NSArray *attributesArray = [self.collectionViewLayout layoutAttributesForElementsInRect:reusableViewCell.frame];
    UICollectionViewLayoutAttributes *attributes = [attributesArray lastObject];
    NSIndexPath *indexPath = attributes.indexPath;
    if (indexPath.section > 0 & indexPath.section < RLFixedHeaderCollectionViewSectionCount - 1) {
        self.currentSelectedColumn = indexPath.section;
    }
}


#pragma mark - Orientation Chagnes

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self updateLayoutItemSize];
}

@end
