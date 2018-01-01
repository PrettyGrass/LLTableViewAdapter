//
//  LTableSection.h
//  GetTV_iOS
//
//  Created by ylin.yang on 2016/6/24.
//  Copyright © 2016年 ylin.yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTableCell;
/**
 *	@author Y0, 16-07-04 17:07:59
 *
 *	tableView section 模型
 *
 *	@since 1.0
 */
@interface LTableSection : NSObject
/// 标题
@property (copy, nonatomic) NSString *sectionTitle;
/// 单元的数据集合
@property (strong, nonatomic) NSMutableArray <LTableCell *>*datas;

- (__kindof LTableCell *)addNewCell;
- (__kindof LTableCell *)addNewCell:(Class)clzz;

@end