//
//  LLTableViewAdapter.m
//  Adapter
//
//  Created by yangyl on 16/7/6.
//  Copyright © 2016年 ylin.yang. All rights reserved.
//

#import "LLTableViewAdapter.h"
#import "UITableViewCell+LLModel.h"
#import "NSObject+LLClazz.h"
#import "LLTableSection.h"
#import "LLTableCell.h"
#import "UIView+LLXib.h"

@interface LLTableViewAdapter()

@end

@implementation LLTableViewAdapter

- (instancetype)initWithTableView:(UITableView *)tableView {
    
    self = [self init];
    if (self) {
        self.tableView = tableView;
    }
    return self;
}

- (void)setTableView:(UITableView *)tableView {
    
    if (_tableView == tableView) {
        return;
    }
    _tableView = tableView;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)reloadData {
    
    [super reloadData];
    [self.tableView reloadData];
}

- (LLTableSection *)addNewSection {
    
    return [self addNewSection:LLTableSection.class];
}

- (LLTableSection *)addNewSection:(Class)clazz {
    
    LLTableSection *section = [[clazz alloc] init];
    [self addSection:section];
    return section;
}

- (void)addSection:(__kindof LLTableSection *)section {
    if (!section) {
        return;
    }
    [self.sections addObject:section];
}

#pragma - mark - UITableViewDelegate
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sections.count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sections[section].datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self getCell:tableView cellForRowAtIndexPath:indexPath dequeue:true];
}

- (UITableViewCell *)getCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath dequeue:(BOOL)dequeue {
    
    LLTableCell *celLLModel = self.sections[indexPath.section].datas[indexPath.row];
    celLLModel.indexPath = indexPath;
    UITableViewCell *cell;
    /// 是否重用
    if (dequeue) {
        cell = [tableView dequeueReusableCellWithIdentifier:[celLLModel.cellClazz className]];
        if (!cell) {
            switch (celLLModel.loadType) {
                case CellLoadTypeInner:
                    [tableView registerClass:celLLModel.cellClazz forCellReuseIdentifier:celLLModel.cellIdentity];
                    break;
                case CellLoadTypeNib:
                    [tableView registerNib:[UINib nibWithNibName:celLLModel.cellNibName bundle:nil] forCellReuseIdentifier:celLLModel.cellIdentity];
                    break;
                case CellLoadTypeOri:
                    [tableView registerClass:celLLModel.cellClazz forCellReuseIdentifier:celLLModel.cellIdentity];
                    break;
                    
                default:
                    break;
            }
            cell = [tableView dequeueReusableCellWithIdentifier:celLLModel.cellIdentity];
        }
    } else {
        switch (celLLModel.loadType) {
            case CellLoadTypeInner:
                cell = [[celLLModel.cellClazz alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:celLLModel.cellIdentity];
                break;
            case CellLoadTypeNib:{
                cell = [celLLModel.cellClazz loadViewFromXibName:celLLModel.cellNibName];
            }
                break;
            case CellLoadTypeOri:
                cell = [[celLLModel.cellClazz alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:celLLModel.cellIdentity];
                break;
                
            default:
                break;
        }
    }
    //cell.selectionStyle = celLLModel.selectionStyle;
    cell.accessoryType = celLLModel.accessoryType;
    cell.model = celLLModel;
    return cell;
}

/**
 *    cell 的点击事件/
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LLTableCell *celLLModel = self.sections[indexPath.section].datas[indexPath.row];
    celLLModel.indexPath = indexPath;
    if (celLLModel.LDeSelectionStyle == LDeSelectionStyleNow) {
        [tableView deselectRowAtIndexPath:indexPath animated:true];
    }
    if (celLLModel.cellClick) {
        celLLModel.cellClick(celLLModel, indexPath);
    }
}
//设置每个cell 的高度;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:_cmd]) {
        CGFloat height = [self.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
        if (UITableViewAutomaticDimension != height) {
            return height;
        }
    }
    LLTableCell *celLLModel = self.sections[indexPath.section].datas[indexPath.row];
    celLLModel.indexPath = indexPath;
    //[self getCell:tableView cellForRowAtIndexPath:indexPath dequeue:false];
    if (celLLModel.cellHeight == UITableViewAutomaticDimension) {
        return celLLModel.cellHeight;
    }
    return celLLModel.cellHeight+celLLModel.cellSpaceMargin.top+celLLModel.cellSpaceMargin.bottom;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:_cmd]) {
        return [self.tableViewDelegate tableView:tableView viewForHeaderInSection:section];
    }
    LLTableSection *sectionModel = self.sections[section];
    return sectionModel.sectionHeaderView ? sectionModel.sectionHeaderView : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:_cmd]) {
        return [self.tableViewDelegate tableView:tableView heightForHeaderInSection:section];
    }
    LLTableSection *sectionModel = self.sections[section];
    return sectionModel.sectionHeaderHeight != 0 ? sectionModel.sectionHeaderHeight : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:_cmd]) {
        return [self.tableViewDelegate tableView:tableView viewForFooterInSection:section];
    }
    LLTableSection *sectionModel = self.sections[section];
    return sectionModel.sectionFooterView ? sectionModel.sectionFooterView : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:_cmd]) {
        return [self.tableViewDelegate tableView:tableView heightForFooterInSection:section];
    }
    LLTableSection *sectionModel = self.sections[section];
    return sectionModel.sectionFooterHeight != 0 ? sectionModel.sectionFooterHeight : 0;
}

#pragma - mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![self.tableViewDelegate respondsToSelector:_cmd]) {
        return;
    }
    [self.tableViewDelegate scrollViewDidScroll:scrollView];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    if (![self.tableViewDelegate respondsToSelector:_cmd]) {
        return;
    }
    [self.tableViewDelegate scrollViewDidZoom:scrollView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (![self.tableViewDelegate respondsToSelector:_cmd]) {
        return;
    }
    [self.tableViewDelegate scrollViewWillBeginDragging:scrollView];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (![self.tableViewDelegate respondsToSelector:_cmd]) {
        return;
    }
    [self.tableViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
    if (![self.tableViewDelegate respondsToSelector:_cmd]) {
        return;
    }
    [self.tableViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    if (![self.tableViewDelegate respondsToSelector:_cmd]) {
        return;
    }
    [self.tableViewDelegate scrollViewWillBeginDecelerating:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (![self.tableViewDelegate respondsToSelector:_cmd]) {
        return;
    }
    [self.tableViewDelegate scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (![self.tableViewDelegate respondsToSelector:_cmd]) {
        return;
    }
    [self.tableViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
}
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    if (![self.tableViewDelegate respondsToSelector:_cmd]) {
        return nil;
    }
    return [self.tableViewDelegate viewForZoomingInScrollView:scrollView];
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view{
    
    if (![self.tableViewDelegate respondsToSelector:_cmd]) {
        return;
    }
    [self.tableViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    
    if (![self.tableViewDelegate respondsToSelector:_cmd]) {
        return;
    }
    [self.tableViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    
    if (![self.tableViewDelegate respondsToSelector:_cmd]) {
        return false;
    }
    return [self.tableViewDelegate scrollViewShouldScrollToTop:scrollView];
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    
    if (![self.tableViewDelegate respondsToSelector:_cmd]) {
        return;
    }
    [self.tableViewDelegate scrollViewDidScrollToTop:scrollView];
}

@end
