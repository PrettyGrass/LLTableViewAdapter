//
//  SimpleCellView.m
//  LLTableViewAdapterExample
//
//  Created by ylin on 17/3/6.
//  Copyright © 2017年 ylin.yang. All rights reserved.
//

#import "SimpleCellView.h"
#import <UITableViewCell+LLModel.h>
#import "LLTableCell.h"

@implementation SimpleCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)updateCellUI {
    [super updateCellUI];
    self.titleLab.text = self.model.title;
}
@end