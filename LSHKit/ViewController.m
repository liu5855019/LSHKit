//
//  ViewController.m
//  LSHKit
//
//  Created by 西安旺豆电子信息有限公司 on 17/4/24.
//  Copyright © 2017年 西安旺豆电子信息有限公司. All rights reserved.
//

#import "ViewController.h"
#import "PersonModel.h"

@interface ViewController ()


@property (nonatomic , strong) UIScrollView *bgView;

@property (nonatomic , copy) NSArray *datas;

@property (nonatomic , copy) NSArray *persons;

@property (nonatomic , assign) CGFloat currentH;

@property (nonatomic , assign) CGFloat oldH;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    [self setupLayouts];
    
    
    [self loadDatas];
    
    [self makeDatas];
    

    
    
}

-(void)makeDatas
{
   
    NSMutableArray *muarray = [NSMutableArray array];
    for (NSDictionary *dict in _datas) {
        
        PersonModel *model = [[PersonModel alloc] init];
        model.name = dict[@"userName"];
        model.parentID = [dict[@"panartId"] integerValue];
        model.peiou = [@([dict[@"peiouId"] integerValue]) stringValue];
        model.userID = [dict[@"userId"] integerValue];
        
        [muarray addObject:model];
    }
    
    _persons = muarray;
    
    //拿到根节点数组
    muarray = [NSMutableArray array];
    for (PersonModel *model in _persons) {
        if (model.parentID == 0) {
            [muarray addObject:model];
        }
    }
    for (PersonModel *model in muarray) {
        _oldH = 0;
        [self readPerson:model andCount:1 ];
    }
    
}

-(void)readPerson:(PersonModel *)person andCount:(NSInteger)dai
{
    NSLog(@"%@---%ld---%f",person.name,dai,_oldH);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat buttonH = 40;
    CGFloat buttonW = 100;
    CGFloat spaceW = buttonW / 2;
    CGFloat spaceH = buttonH / 2;
    button.frame = CGRectMake(spaceW *dai, _currentH + spaceH, buttonW, buttonH);
    _currentH = _currentH + spaceH + buttonH;
    
    button.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:button];
    [button setTitle:person.name forState:UIControlStateNormal];
    
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor orangeColor];
    line1.frame = CGRectMake(kGetX(button)- spaceW /2, kGetY(button) + spaceH , spaceW/2, 1);
    [self.bgView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor orangeColor];
    line2.frame = CGRectMake(kGetX(button)- spaceW /2, _oldH + buttonH, 1, kGetY(button) + spaceH - _oldH - buttonH);
    [self.bgView addSubview:line2];
    
    for (PersonModel *model in _persons) {
        if (model.parentID == person.userID) {
            _oldH = kGetY(button);
            [self readPerson:model andCount:dai+1 ];
        }
    }

}


-(void)setupViews
{
    _bgView = [[UIScrollView alloc] init];
    [self.view addSubview:_bgView];
    
    
}

-(void)setupLayouts
{
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}




-(void)loadDatas
{
    self.datas = @[
                   @{
                       @"panartId" : @0,
                       @"peiouId" : @189,
                       @"userId" : @1,
                       @"userName" : @"kanakn"
                       },
                   @{
                       @"panartId" : @1,
                       @"peiouId" : @124,
                       @"userId" : @161,
                       @"userName" : @"load"
                       },
                   @{
                       @"panartId" : @161,
                       @"peiouId" : @0,
                       @"userId" : @148,
                       @"userName" : @"meizi"
                       },
                   @{
                       @"panartId" : @161,
                       @"peiouId" : @0,
                       @"userId" : @29,
                       @"userName" : @"meiziLaopo"
                       },
                   @{
                       @"panartId" : @1,
                       @"peiouId" : @0,
                       @"userId" : @145,
                       @"userName" : @"later"
                       },
                   @{
                       @"panartId" : @0,
                       @"peiouId" : @5,
                       @"userId" : @2,
                       @"userName" : @"brother"
                       },
                   @{
                       @"panartId" : @2,
                       @"peiouId" : @33,
                       @"userId" : @23,
                       @"userName" : @"child",
                       },
                   @{
                       @"panartId" : @23,
                       @"peiouId" : @0,
                       @"userId" : @18,
                       @"userName" : @"sandai",
                       }
                   ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
