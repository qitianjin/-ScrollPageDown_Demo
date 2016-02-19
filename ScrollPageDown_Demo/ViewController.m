//
//  ViewController.m
//  ScrollPageDown_Demo
//
//  Created by 李金华 on 15/7/16.
//  Copyright (c) 2015年 LJH. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UIScrollView *scrollV;
@property(strong,nonatomic)UITableView *tableV;
@property(strong,nonatomic)UIWebView *webV;

@end

#define IPHONE_W ([UIScreen mainScreen].bounds.size.width)
#define IPHONE_H ([UIScreen mainScreen].bounds.size.height)

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //控件添加到视图上
    /**
     *  设置一个 UIScrollView 作为视图底层，并且设置分页为两页
     *  然后在第一个分页上添加一个 UITableView 并且设置表格能够上提加载（上拉操作即为让视图滚动到下一页）
        在第二个分页上添加一个 UIWebView 并且设置能有下拉刷新操作（下拉操作即为让视图滚动到上一页）
     */
    [self.view addSubview:self.scrollV];
    [self.scrollV addSubview:self.tableV];
    [self.scrollV addSubview:self.webV];
    
    
    //设置UITableView 上拉加载
    self.tableV.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //上拉，执行对应的操作---改变底层滚动视图的滚动到对应位置
        //设置动画效果
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.scrollV.contentOffset = CGPointMake(0, IPHONE_H);
        } completion:^(BOOL finished) {
            //结束加载
            [self.tableV.footer endRefreshing];
        }];
       
       
    }];
    
    //设置UIWebView 有下拉操作
    self.webV.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉执行对应的操作
        self.scrollV.contentOffset = CGPointMake(0, 0);
        //结束加载
        [self.webV.scrollView.header endRefreshing];
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
}

#pragma mark -- UITableView DataSource && Delegate
//返回表格分区行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
//定制单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%ld",indexPath.section,indexPath.row];
    return cell;
}


#pragma mark ---- get

-(UIScrollView *)scrollV
{
    if (_scrollV == nil)
    {
        _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_W, IPHONE_H)];
        _scrollV.contentSize = CGSizeMake(IPHONE_W, IPHONE_H * 2);
        //设置分页效果
        _scrollV.pagingEnabled = YES;
        //禁用滚动
        _scrollV.scrollEnabled = NO;
    }
    return _scrollV;
}

-(UITableView *)tableV
{
    if (_tableV == nil)
    {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_W, IPHONE_H) style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
    }
    return _tableV;
}

-(UIWebView *)webV
{
    if (_webV == nil)
    {
        _webV = [[UIWebView alloc]initWithFrame:CGRectMake(0, IPHONE_H, IPHONE_W, IPHONE_H)];
    }
    return _webV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
