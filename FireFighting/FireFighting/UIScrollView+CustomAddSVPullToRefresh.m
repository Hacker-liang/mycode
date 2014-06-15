//
//  UIScrollView+CustomAddSVPullToRefresh.m
//  EMPian
//
//  Created by EMIAGE EMIAGE on 13-8-17.
//  Copyright (c) 2013年 com. All rights reserved.
//

#import "UIScrollView+CustomAddSVPullToRefresh.h"

@implementation UIScrollView (CustomAddSVPullToRefresh)

- (void)addCustomPullToRefreshWithActionHandler:(void (^)(void))actionHandler
{
    [self addPullToRefreshWithActionHandler:actionHandler];
    
    [self.pullToRefreshView setTitle:@"下拉可刷新" forState:SVPullToRefreshStateStopped];
    [self.pullToRefreshView setTitle:@"松开可刷新" forState:SVPullToRefreshStateTriggered];
    [self.pullToRefreshView setTitle:@"加载中……" forState:SVPullToRefreshStateLoading];
}

- (void)addCustomPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(SVPullToRefreshPosition)position
{
    [self addPullToRefreshWithActionHandler:actionHandler position:position];
    
    [self.pullToRefreshView setTitle:position == SVPullToRefreshPositionTop ? @"下拉可刷新" : @"上拉可刷新" forState:SVPullToRefreshStateStopped];
    [self.pullToRefreshView setTitle:@"松开可刷新" forState:SVPullToRefreshStateTriggered];
    [self.pullToRefreshView setTitle:@"加载中……" forState:SVPullToRefreshStateLoading];
}

@end
