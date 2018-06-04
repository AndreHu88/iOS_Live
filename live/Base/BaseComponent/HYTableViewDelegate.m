//
//  HYTableViewDelegate.m
//  Booking
//
//  Created by Duntech on 2018/4/19.
//  Copyright © 2018年 Duntech. All rights reserved.
//

#import "HYTableViewDelegate.h"
#import "HYBaseCellModel.h"

@implementation HYTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellHeight = 0;
    if (self.rowHeightBlock) {
        cellHeight = self.rowHeightBlock(tableView,indexPath);
    }
    else{
        if (self.dataSource) {
            NSArray *sectionArray = self.dataSource[indexPath.section];
            HYBaseCellModel * model = sectionArray[indexPath.row];
            if ([model isKindOfClass:[HYBaseCellModel class]]) {
                cellHeight = model.cellHeight;
            }
        }
    }
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat headerHeight = 0.000001;
    if (self.headerHeightBlock) {
        headerHeight = self.headerHeightBlock(tableView,section);
    }
    return headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat footerHeight = 0.000001;
    if (self.footerHeightBlock) {
        footerHeight = self.footerHeightBlock(tableView,section);
    }
    return footerHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectedBlock) {
        self.didSelectedBlock(tableView,indexPath);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.headerViewBlock) {
        return self.headerViewBlock(tableView,section);
    }
    else{
        UIView *headerView = [UIView new];
        headerView.backgroundColor = KAPP_TableView_BgColor;
        return headerView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (self.footerViewBlock) {
        return self.footerViewBlock(tableView,section);
    }
    else{
        return [[UIView alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.willDisplayBlock) {
        self.willDisplayBlock(tableView,cell,indexPath);
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.scrollViewDidScrill) {
        self.scrollViewDidScrill(scrollView);
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.editActionBlock) {
        self.editActionBlock(tableView, indexPath);
    }
    return nil;
}

@end
