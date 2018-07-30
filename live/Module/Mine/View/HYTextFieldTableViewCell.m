//
//  HYTextFieldTableViewCell.m
//  Booking
//
//  Created by Duntech on 2018/4/23.
//  Copyright © 2018年 Duntech. All rights reserved.
//

#import "HYTextFieldTableViewCell.h"

@interface HYTextFieldTableViewCell () <UITextFieldDelegate>

/** 标题 */
@property (nonatomic,strong) UILabel *titleLabel;
/** textField */
@property (nonatomic,strong) UITextField *textField;
/** bottomLine */
@property (nonatomic,strong) UIView *bottomLine;
@property (nonatomic,strong) UIImageView *rightIconImgView;

@end

@implementation HYTextFieldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
    [self addSubview:self.bottomLine];
    [self addSubview:self.rightIconImgView];
    
}

- (void)layoutSubviews{
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(10 * WIDTH_MULTIPLE);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(120 * WIDTH_MULTIPLE);
    }];
    
    [_rightIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self).offset(-10 * WIDTH_MULTIPLE);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(30 * WIDTH_MULTIPLE);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark - Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldCellInput:inputStr:)]) {
        
        [_delegate textFieldCellInput:self inputStr:textField.text];
    }
    
    if (self.inputBlock) {
        
        self.inputBlock(textField.text);
    }
}


#pragma mark - setter
- (void)configWithModel:(id)model{
    
    HYTextFieldCellModel *cellModel = (HYTextFieldCellModel *)model;
    _titleLabel.text = cellModel.title;
    _textField.placeholder = cellModel.placeholderStr;
    _textField.text = cellModel.value;
    
    if (cellModel.inputMode == HYTextFieldCellInputModeInput) {
        
        self.rightIconImgView.hidden = YES;
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.height.equalTo(self.titleLabel);
            make.right.equalTo(self).offset(-20 * WIDTH_MULTIPLE);
            make.left.equalTo(self.titleLabel.mas_right).offset(10 * WIDTH_MULTIPLE);
        }];
    }
    else if(cellModel.inputMode == HYTextFieldCellInputModeSelect){
        self.rightIconImgView.hidden = NO;
        self.textField.userInteractionEnabled = NO;
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.height.equalTo(self.titleLabel);
            make.right.equalTo(self.rightIconImgView.mas_left).offset(-10 * WIDTH_MULTIPLE);
            make.left.equalTo(self.titleLabel.mas_right).offset(10 * WIDTH_MULTIPLE);
        }];
    }
    else if (cellModel.inputMode == HYTextFieldCellInputModeNotEdit){
        
        self.rightIconImgView.hidden = YES;
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.height.equalTo(self.titleLabel);
            make.right.equalTo(self).offset(-20 * WIDTH_MULTIPLE);
            make.left.equalTo(self.titleLabel.mas_right).offset(10 * WIDTH_MULTIPLE);
        }];
        self.textField.userInteractionEnabled = NO;
    }
    
    if (cellModel.keywoardMode == HYTextFieldCellKeyBoardModePhone) {
        _textField.keyboardType = UIKeyboardTypePhonePad;
    }
}

- (void)setTitle:(NSString *)title{
    
    _title = title;
    _titleLabel.text = title;
}

- (void)setPlaceholder:(NSString *)placeholder{
    
    _placeholder = placeholder;
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:KCOLOR(@"b7b7b7"),NSFontAttributeName : KFitFont(14)}];
}

- (void)setValueStr:(NSString *)valueStr{
    
    _valueStr = valueStr;
    self.textField.text = valueStr;
}


#pragma mark - lazyload
- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = KFitFont(13);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = KCOLOR(@"272727");
    }
    return _titleLabel;
}

- (UITextField *)textField{
    
    if (!_textField) {
        
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = KFitFont(14);
        _textField.textColor = KCOLOR(@"7b7b7b");
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.delegate = self;
    }
    return _textField;
}

- (UIView *)bottomLine{
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = KAPP_SEPERATOR_COLOR;
    }
    return _bottomLine;
}

- (UIImageView *)rightIconImgView{
    
    if (!_rightIconImgView) {
        
        _rightIconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow_left"]];
        _rightIconImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightIconImgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation HYTextFieldCellModel

@end
