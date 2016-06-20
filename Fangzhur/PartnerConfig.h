//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088211724206885"
//收款支付宝账号
#define SellerID  @"fangzhur@126.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"doyalouxcgcc5b6irharm6wt5m105nny"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAPP9m2+vylz0SfsEfkP2NhSaAqGQHngsWrrxAHJH16b2bPCHCITLjOyoss6knnJsJvC5VldKk4NyFEwukjXGQe2bKmz4YsMy/DcaVbz3Ef6HBla45+n8d382U/QxINyyrL8nyJ1t9Auj6m3htUqYVE6193eTCgVx6CABXX8hYgPXAgMBAAECgYB9hddVmiaNs8/rp+Adrqkb6C+6Vp6WTJtQ2XPVV0iGyPg6tf2X8/BIQHHdBavOSf2ukmrs9Zz2XtY6ayslJx360kqxnywTpHB2QHBWELbOz+EMC03hJ4ckQos2gQHskj9Q+xz94XyIQ+ZIGnUS4AfUMWvKBUWd58bEefF8EARVAQJBAP6Gol7DPUDjkF1XKMwgW7pfjs/Z6mgYKmIt4PgnUuB5pllBEaOmXksIDKo8+dF483DwZosReWe6GR1h4i/MzDcCQQD1Z1pk6n0ajNTlVps0t4JAVkRek8AP+0JpL1SUevgRV6t7W5dXyQB4Y/GgdGr6ls6E9Zt0pGy3YeY0ol3paPVhAkEA0y4R+l4zrGsjlM6EYxlWAkTW0U4VV1j1kZBPYJYABY/pnZSHdijLg6WiHH2LKWoZUlOkQS62dIHL5L0aVl6t8QJBAIVHOW+/bmxh+ioH7EkoNQROFdmrss67LilEPFJbqqh4jbh0WPCjSK8Z0JvNPmCUUNsjLOefeS/raoRBfnGKwGECQQCTvBb9B5mO5mmRe0WX6gpgSq0M9WFiRNZx1sZ7KBp5l60n+vhLzAUOyelJgmvX8B08+FN7Hp58IENyDd7Jk6De"


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

//========ShareSDK========

//AppKey
#define ShareSDK_AppKey @"28307fee1a13"