//
//  HYTableViewDataSource.m
//  Booking
//
//  Created by Duntech on 2018/4/19.
//  Copyright © 2018年 Duntech. All rights reserved.
//

#import "HYTableViewDataSource.h"

@implementation HYTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger sectionCount = 0;
    if (self.dataSource.count) {
        sectionCount = self.dataSource.count;
    }
    return sectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * sectionDataSource = self.dataSource[indexPath.section];
    id rowDataSource = sectionDataSource[indexPath.row];
    NSString * cellIdientifier = [rowDataSource valueForKey:@"cellIdientifier"];
    HYBaseTableViewCell *baseCell;
    if (cellIdientifier.length > 0) {
        baseCell = (HYBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdientifier];
    }
    else{
        baseCell = [[HYBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdientifier];
        
    }
    [baseCell configWithModel:rowDataSource];
    if (self.bindingCellBlock) {
        self.bindingCellBlock(tableView,rowDataSource,baseCell,indexPath);
    }
    return baseCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rowCount = 0;
    if (section < self.dataSource.count) {
        
        NSArray *sectionArray = self.dataSource[section];
        if (sectionArray.count)
            rowCount = sectionArray.count;
    }
    return rowCount;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.CellCanEditBlock) {
        return self.CellCanEditBlock(tableView,indexPath);
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.CommitEditingBlock) {
        self.CommitEditingBlock(tableView, editingStyle, indexPath);
    }
}


@end
