//
//  FZRGenerateOrderViewController.m
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-12.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import "FZRGenerateOrderViewController.h"
#import "FZROrderInfoCell.h"
#import "FZRPaymentCell.h"
#import "PartnerConfig.h"
#import "FZDefaultTopView.h"
#import "FZRReleaseSuccessViewController.h"
#import "FZRReleaseSuccessViewController.h"

@interface FZRGenerateOrderViewController ()

- (void)UIConfig;
//提交订单信息
- (void)submitsOrderInfo;
- (void)gotoAlipay;
- (void)tradeFinished;
- (float)getNeedMoney;

@end

@implementation FZRGenerateOrderViewController

#pragma mark - 初始化 -

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tradeFinished) name:@"TradeFinished" object:nil];
    
    [self UIConfig];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController performSelector:@selector(addTitle:) withObject:@"支付订单"];
    [self addButtonWithImageName:@"fanhui" target:self action:@selector(giveUpOrder) position:POSLeft];
}

//放弃订单返回上一步
- (void)giveUpOrder
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您确定要放弃该订单吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//================================

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UIConfig
{
    [self.tableView registerNib:[UINib nibWithNibName:@"FZROrderInfoCell" bundle:nil]
         forCellReuseIdentifier:@"FZROrderInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FZRPaymentCell" bundle:nil]
         forCellReuseIdentifier:@"FZRPaymentCell"];
}

- (float)getNeedMoney
{
    float cash = [FZUserInfoWithKey(Key_UserCash) floatValue];
    float vouchers = [FZUserInfoWithKey(Key_UserTickets) floatValue];
    if ([[self.contractModel.paramDict objectForKey:@"use_fangbi"] intValue] == 2) {
        vouchers = 0;
    }
    
    float needToPay = [self.contractModel.orderModel.service_price floatValue];
    if (cash >= needToPay) {//现金账户充足，使用现金账户
        needToPay = 0;
    }
    else {
        needToPay -= cash;
        if (vouchers >= needToPay) {
            needToPay = 0;
        }
        else {
            needToPay -= vouchers;
        }
    }
    
    //判断是否打折扣--》如果关联房源编号，租赁减50，出售减100
    if (self.contractModel.houseNumber.length != 0) {
        ([self.contractModel.orderModel.service_type intValue] > 1) ? (needToPay -= 100) : (needToPay -= 50);
    }
    
    return needToPay;
}

- (void)submitsOrderInfo
{    
    [self.contractModel loadRequestParameters];
    [[FZRequestManager manager] releaseOrderWithParameters:self.contractModel.paramDict complete:^(BOOL success, id responseObject) {
        if (success) {
            [self.contractModel.orderModel setValuesForKeysWithDictionary:responseObject];
            [self gotoAlipay];
        }
        else {
#warning 异地登录
        }
    }];

}

#pragma mark - Table view delegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 160;
    }
    else {
        return 240;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"确认订单信息:";
        default:
            return @"选择支付方式:";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


#pragma mark - Table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FZROrderInfoCell *orderInfoCell = [tableView dequeueReusableCellWithIdentifier:@"FZROrderInfoCell"];
        [orderInfoCell fillDataWithModel:self.contractModel.orderModel];
        
        return orderInfoCell;
    }
    else {
        FZRPaymentCell *paymentCell = [tableView dequeueReusableCellWithIdentifier:@"FZRPaymentCell"];
        paymentCell.paymentLabel.text = [NSString stringWithFormat:@"%.2f元", [self getNeedMoney]];
        [paymentCell.paymentButton addTarget:self action:@selector(submitsOrderInfo)
                            forControlEvents:UIControlEventTouchUpInside];
        
        return paymentCell;
    }
}

#pragma mark - 支付宝支付 -

//获取订单信息
- (NSString *)getOrderInfo
{
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = self.contractModel.orderModel.jiaoyi_id; //订单ID
	order.productName = @"房主儿网签约服务"; //商品标题
	order.productDescription = [NSString stringWithFormat:@"北京市%@区-%@\n来自:%@",
                                self.contractModel.orderModel.cityarea_name,
                                self.contractModel.orderModel.qu_name,
                                self.contractModel.orderModel.ip];
	order.amount = [NSString stringWithFormat:@"%.2f", [self getNeedMoney]]; //商品价格
	order.notifyURL = URLStringByAppending(kAlipayCallBack); //回调URL
    order.itBPay = @"10m";
	
	return [order description];
}

- (void)tradeFinished
{
    [[FZRequestManager manager] finishContractWithJiaoyiID:self.contractModel.orderModel.jiaoyi_id complete:^(BOOL success, id responseObject) {
        if (success) {
            [JDStatusBarNotification showWithStatus:@"订单支付成功"];
            //更新用户信息
            [[FZRequestManager manager] getUserInfoComplete:NULL];
            
            FZRReleaseSuccessViewController * successViewController = [[FZRReleaseSuccessViewController alloc] init];
            successViewController.orderId = self.contractModel.orderModel.jiaoy_no;
            [self.navigationController pushViewController:successViewController animated:YES];
        }
    }];
}

//=============支付宝支付=================

- (void)gotoAlipay
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = self.contractModel.orderModel.jiaoyi_id; //订单ID
    order.productName = @"房主儿网签约服务"; //商品标题
    order.productDescription = [NSString stringWithFormat:@"北京市%@区-%@\n来自:%@",
                                self.contractModel.orderModel.cityarea_name,
                                self.contractModel.orderModel.qu_name,
                                self.contractModel.orderModel.ip];
    order.amount = [NSString stringWithFormat:@"%.2f", [self getNeedMoney]]; //商品价格
    order.notifyURL = URLStringByAppending(kAlipayCallBack); //回调URL
    order.itBPay = @"10m";
    order.inputCharset = @"utf-8";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"com.fangzhur.base";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //wap回调函数
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            NSInteger statusCode = [[resultDic objectForKey:@"resultStatus"] integerValue];
            switch (statusCode) {
                case 9000: {
                    [JDStatusBarNotification showWithStatus:@"订单支付成功"];
                    [self tradeFinished];
                }
                    break;
                case 6001: {
                    [JDStatusBarNotification showWithStatus:@"用户中途取消操作"];
                }
                    break;
                case 6002: {
                    [JDStatusBarNotification showWithStatus:@"网络连接错误"];
                }
                    break;
                case 4000: {
                    [JDStatusBarNotification showWithStatus:@"订单支付失败"];
                }
                    break;
                    
                default:
                    break;
            }
            [JDStatusBarNotification dismissAfter:2];
        }];
    }
}

@end
