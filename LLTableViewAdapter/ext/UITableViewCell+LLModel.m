//
//  UITableViewCell+LLModel.m
//  Adapter
//
//  Created by ylin on 16/6/12.
//  Copyright © 2016年 ylin. All rights reserved.
//

#import "UITableViewCell+LLModel.h"
#import "objc/runtime.h"
#import "LLTableCell.h"
#import "Masonry.h"

static NSInteger kCellSelectTag = 1000221;
static NSString *celLLModelkey = @"celLLModelkey";
@implementation UITableViewCell (LLModel)

- (void)setModel:(LLTableCell *)model {
    objc_setAssociatedObject(self, &celLLModelkey, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateCellUI];
}

- (LLTableCell *)model {
    
    return objc_getAssociatedObject(self, &celLLModelkey);
}

- (BOOL)resetCellFrame {
    return true;
}

- (void)updateCellUI {
    __weak typeof(self) weakSelf = self;
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf).offset(weakSelf.model.cellSpaceMargin.left);
        make.trailing.equalTo(weakSelf).offset(-weakSelf.model.cellSpaceMargin.right);
        make.top.equalTo(weakSelf).offset(weakSelf.model.cellSpaceMargin.top);
        make.bottom.equalTo(weakSelf).offset(-weakSelf.model.cellSpaceMargin.bottom);
    }];
    
    if ([NSStringFromClass(self.class) isEqualToString:@"UITableViewCell"]) {
        self.textLabel.text = self.model.title;
        self.detailTextLabel.text = self.model.subTitle;
        NSString *img = self.model.image;
        if ([img hasPrefix:@"http://"]||[img hasPrefix:@"https://"]) {
            //[self.imageView setImageURL:[NSURL URLWithString:img]];
        } else if (img.length > 0) {
            self.imageView.image = [UIImage imageNamed:img];
        }
    }
    //分割线
    UIView *contentView = self.contentView;
    NSInteger tag = 123154;
    if (self.model.separatorStyle == LTableViewCellSeparatorStyleNone) {
        UIView *separ = [contentView viewWithTag:tag];
        [separ setHidden:true];
    } else {
        UIView *separ = [contentView viewWithTag:tag];
        if (!separ) {
            separ = [[UIView alloc] init];
            separ.tag = tag;
            [contentView addSubview:separ];
        }
        [separ setHidden:false];
        UIColor *defaultColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
        UIColor *color = self.model.separatorColor;
        if (!color) {
            color = defaultColor;
        }
        
        if (self.model.separatorStyle == LTableViewCellSeparatorStyleInner) {
            [separ setBackgroundColor:defaultColor];
        } else {
            [separ setBackgroundColor:color];
        }
        [separ mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(contentView).offset(weakSelf.model.separatorInset.left);
            make.trailing.equalTo(contentView).offset(-weakSelf.model.separatorInset.right);
            make.bottom.equalTo(contentView).offset(-weakSelf.model.separatorInset.bottom);
            make.height.mas_equalTo(0.3f);
        }];
    }
    
    /// 选中背景色
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.tag = kCellSelectTag;
    self.selectedBackgroundView = selectedBackgroundView;
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    selectedBackgroundView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    self.selectionStyle = self.model.selectionStyle;
    /// 透传数据
    [self.model.kvcExt enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [weakSelf setValue:obj forKeyPath:key];
    }];
}

- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];
    if (subview.tag == kCellSelectTag) {
        __weak typeof(self) weakSelf = self;
        if (self.selectedBackgroundView.superview) {
            [self.selectedBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.equalTo(weakSelf.selectedBackgroundView.superview).offset(weakSelf.model.cellSpaceMargin.left);
                make.trailing.equalTo(weakSelf.selectedBackgroundView.superview).offset(-weakSelf.model.cellSpaceMargin.right);
                make.top.equalTo(weakSelf.selectedBackgroundView.superview).offset(weakSelf.model.cellSpaceMargin.top);
                make.bottom.equalTo(weakSelf.selectedBackgroundView.superview).offset(-weakSelf.model.cellSpaceMargin.bottom);
            }];
            self.selectedBackgroundView.backgroundColor = weakSelf.model.selectionColor;
        }
    }
}

@end