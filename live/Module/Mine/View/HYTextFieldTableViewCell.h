//
//  HYTextFieldTableViewCell.h
//  Booking
//
//  Created by Duntech on 2018/4/23.
//  Copyright © 2018年 Duntech. All rights reserved.
//

#import "HYBaseTableViewCell.h"

typedef NS_ENUM(NSUInteger, HYTextFieldCellInputMode) {
    HYTextFieldCellInputModeInput = 0,   //输入
    HYTextFieldCellInputModeSelect,      //选择
    HYTextFieldCellInputModeNotEdit      //不能编辑
};

typedef NS_ENUM(NSUInteger, HYTextFieldCellKeyBoardMode) {
    HYTextFieldCellKeyBoardModeDefault = 10,
    HYTextFieldCellKeyBoardModePhone,
    HYTextFieldCellKeyBoardModeEmail,
};

@interface HYTextFieldCellModel : HYBaseCellModel

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *placeholderStr;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,assign) HYTextFieldCellInputMode inputMode;
@property (nonatomic,assign) HYTextFieldCellKeyBoardMode keywoardMode;

@end

@class HYTextFieldTableViewCell;
@protocol HYTextFieldCellDelegate <NSObject>

//textView刷新tableViewCell
- (void)textFieldCellInput:(HYTextFieldTableViewCell *)cell inputStr:(NSString *)inputStr;

@end

typedef void(^CellInputBlock)(NSString *inputStr);

@interface HYTextFieldTableViewCell : HYBaseTableViewCell

/** title */
@property (nonatomic,copy) NSString *title;
/** 占位显示 */
@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,copy) NSString *valueStr;
/** delegate */
@property (nonatomic,weak) id <HYTextFieldCellDelegate>delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,copy)  CellInputBlock inputBlock;

@end
