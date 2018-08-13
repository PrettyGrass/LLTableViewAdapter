//
//  LBaseAdapter.h
//  Adapter
//
//  Created by yangyl on 16/7/6.
//  Copyright © 2016年 ylin.yang. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 基础适配器
@interface LBaseAdapter <SectionType>: NSObject

@property (strong, nonatomic) NSMutableArray <SectionType>* sections;
/// 适配器刷新，就是更新列表
- (void)reloadData;

@end