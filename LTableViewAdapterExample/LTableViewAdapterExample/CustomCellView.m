//
//  CustomCellView.m
//  LTableViewAdapterExample
//
//  Created by ylin on 17/6/7.
//  Copyright © 2017年 ylin.yang. All rights reserved.
//

#import "CustomCellView.h"
#import <UITableViewCell+LModel.h>
#import "LTableCell.h"
#import <Masonry.h>

@implementation CustomCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellUI {
    __weak typeof(self) weakSelf = self;
    [super updateCellUI];
    self.titleLab.text = self.model.title;
}
- (IBAction)btnAction:(id)sender {
    
}

@end