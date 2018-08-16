//
//  LLCollectSection.h
//  Adapter
//
//  Created by ylin.yang on 2016/7/5.
//  Copyright © 2016年 ylin.yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLBaseSection.h"
@class LLCollectCell;

/**
 *	@author Y0, 16-07-05 22:07:39
 *
 *  宫格视图单元模型
 *
 *	@since 1.0
 */
@interface LLCollectSection<LLCellType: LLBaseCell*, LLHeaderType: LLBaseCell*, LLFooterType: LLBaseCell*>: LLBaseSection<LLCellType, LLHeaderType, LLFooterType>

@end