//
//  RLFixedHeadersCollectionViewLayout.m
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

#import "RLFixedHeadersCollectionViewLayout.h"

NSString * const RLFixedHeadersSupplementaryViewKind[] = {
    [RLFixedHeadersSupplementaryViewTypeColumnHeader] = @"columnHeader",
    [RLFixedHeadersSupplementaryViewTypeRowHeader] = @"rowHeader"
};

@interface RLFixedHeadersCollectionViewLayout ()

@property (strong, nonatomic) NSMutableDictionary *contentCellsLayoutAttributes;
@property (strong, nonatomic) NSMutableDictionary *columnHeaderLayoutAttributes;
@property (strong, nonatomic) NSMutableArray *rowHeaderLayoutAttributes;
@property (assign, nonatomic) CGRect bounds;
@property (assign, nonatomic) CGSize contentSize;

@end

@implementation RLFixedHeadersCollectionViewLayout

- (void)setItemSize:(CGSize)itemSize{
    if (!CGSizeEqualToSize(_itemSize, itemSize)) {
        
        _itemSize = itemSize;
        
        [self invalidateLayout];
    }
}

- (void)prepareLayout{
    [self prepareContentCellsLayout];
    [self prepareColumnHeaderLayout];
    [self prepareRowHeaderLayout];
}

- (void)prepareContentCellsLayout{
    [self.contentCellsLayoutAttributes removeAllObjects];
    
    NSInteger numberOfRows = [self.collectionView numberOfItemsInSection:0];
    NSInteger numberOfColumns = [self.collectionView numberOfSections];
    CGFloat xPosition = 0.0f;
    CGFloat yPosition = 0.0f;
    //ignore the first row since it's handled by the column header layout code
    for (int rowIndex = 1; rowIndex < numberOfRows; rowIndex++) {
        for (int columnIndex = 0; columnIndex < numberOfColumns; columnIndex++){
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:rowIndex inSection:columnIndex];
            UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            if (columnIndex == 0) {
                xPosition = self.collectionView.contentOffset.x;
                yPosition = self.itemSize.height * rowIndex;
                layoutAttributes.frame = CGRectMake(xPosition, yPosition, RLFixedHeadersRowHeaderWidth, self.itemSize.height);
                layoutAttributes.zIndex = 200;
                
            }
            // make the last column fixed
            else if(columnIndex == numberOfColumns - 1){
                xPosition = (self.collectionView.frame.size.width - self.itemSize.width) + self.collectionView.contentOffset.x;
                yPosition = self.itemSize.height * rowIndex;
                layoutAttributes.frame = CGRectMake(xPosition, yPosition, self.itemSize.width, self.itemSize.height);
                layoutAttributes.zIndex = 200;
            }
            else{
                xPosition = RLFixedHeadersRowHeaderWidth + (self.itemSize.width * (columnIndex - 1));
                yPosition = self.itemSize.height * rowIndex;
                layoutAttributes.frame = CGRectMake(xPosition, yPosition, self.itemSize.width, self.itemSize.height);
                layoutAttributes.zIndex = 100;
            }
            
            [self.contentCellsLayoutAttributes setObject:layoutAttributes forKey:indexPath];
        }
    }
    
    self.contentSize = CGSizeMake((self.itemSize.width * (numberOfColumns - 1)) + RLFixedHeadersRowHeaderWidth, numberOfRows * self.itemSize.height);
}

- (void)prepareColumnHeaderLayout{
    [self.columnHeaderLayoutAttributes removeAllObjects];
    //ingnore the first column since it's handled by the row header layout code
    NSInteger numberOfColumns = [self.collectionView numberOfSections];
    CGFloat xPosition = 0.0f;
    CGFloat yPosition = 0.0f;
    for (int rowIndex = 0; rowIndex < 1; rowIndex++) {
        xPosition = RLFixedHeadersRowHeaderWidth;
        for (int columnIndex = 1; columnIndex < numberOfColumns; columnIndex++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:rowIndex inSection:columnIndex];
            UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:RLFixedHeadersSupplementaryViewKind[RLFixedHeadersSupplementaryViewTypeColumnHeader] withIndexPath:indexPath];
            
            // make the last column fixed
            if (columnIndex == numberOfColumns - 1) {
                xPosition = (self.collectionView.frame.size.width - self.itemSize.width) + self.collectionView.contentOffset.x;
                yPosition = (self.itemSize.height * rowIndex) + self.collectionView.contentOffset.y;
                layoutAttributes.frame = CGRectMake(xPosition, yPosition, self.itemSize.width, self.itemSize.height);
                layoutAttributes.zIndex = 400;
            }
            else{
                yPosition = (self.itemSize.height * rowIndex) + self.collectionView.contentOffset.y;
                layoutAttributes.frame = CGRectMake(xPosition, yPosition, self.itemSize.width, self.itemSize.height);
                layoutAttributes.zIndex = 300;
            }
            
            [self.columnHeaderLayoutAttributes setObject:layoutAttributes forKey:indexPath];
            
            xPosition += self.itemSize.width;
        }
    }
}

- (void)prepareRowHeaderLayout{
    [self.rowHeaderLayoutAttributes removeAllObjects];
    // layout headers for the first row
    CGFloat xPosition = 0.0f;
    CGFloat yPosition = 0.0f;
    for (int rowIndex = 0; rowIndex < 1; rowIndex++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:rowIndex inSection:0];
        UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:RLFixedHeadersSupplementaryViewKind[RLFixedHeadersSupplementaryViewTypeRowHeader] withIndexPath:indexPath];
        xPosition = self.collectionView.contentOffset.x;
        yPosition = (self.itemSize.height * rowIndex) + self.collectionView.contentOffset.y;
        layoutAttributes.frame = CGRectMake(xPosition, yPosition, RLFixedHeadersRowHeaderWidth, self.itemSize.height);
        layoutAttributes.zIndex = 400;
        
        [self.rowHeaderLayoutAttributes addObject:layoutAttributes];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    [[self.contentCellsLayoutAttributes allValues] enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [layoutAttributes addObject:attributes];
        }
    }];
    
    [[self.columnHeaderLayoutAttributes allValues] enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [layoutAttributes addObject:attributes];
        }
    }];
    
    [self.rowHeaderLayoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [layoutAttributes addObject:attributes];
        }
    }];
    
    return [layoutAttributes copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 1 && indexPath.section > 0) {
        return [self.columnHeaderLayoutAttributes objectForKey:indexPath];
    }
    else if(indexPath.row < 1 && indexPath.section == 0){
        return [self.rowHeaderLayoutAttributes objectAtIndex:indexPath.row];
    }
    else{
        return [self.contentCellsLayoutAttributes objectForKey:indexPath];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:RLFixedHeadersSupplementaryViewKind[RLFixedHeadersSupplementaryViewTypeColumnHeader]]) {
        return [self.columnHeaderLayoutAttributes objectForKey:indexPath];
    }
    else if([kind isEqualToString:RLFixedHeadersSupplementaryViewKind[RLFixedHeadersSupplementaryViewTypeRowHeader]]){
        return [self.rowHeaderLayoutAttributes objectAtIndex:indexPath.row];
    }
    return nil;
}

- (CGSize)collectionViewContentSize{
    return self.contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    if (!CGRectEqualToRect(self.bounds, newBounds)) {
        
        self.bounds = newBounds;
        
        [self invalidateLayout];
        
        return YES;
    }
    
    return NO;
}

- (NSMutableDictionary *)contentCellsLayoutAttributes{
    if (_contentCellsLayoutAttributes == nil) {
        _contentCellsLayoutAttributes = [NSMutableDictionary dictionary];
    }
    return _contentCellsLayoutAttributes;
}

- (NSMutableDictionary *)columnHeaderLayoutAttributes{
    if (_columnHeaderLayoutAttributes == nil) {
        _columnHeaderLayoutAttributes = [NSMutableDictionary dictionary];
    }
    return _columnHeaderLayoutAttributes;
}

- (NSMutableArray *)rowHeaderLayoutAttributes{
    if (_rowHeaderLayoutAttributes == nil) {
        _rowHeaderLayoutAttributes = [NSMutableArray array];
    }
    return _rowHeaderLayoutAttributes;
}

@end
