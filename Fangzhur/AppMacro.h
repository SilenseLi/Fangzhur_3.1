//
//  AppMacro.h
//  SelfBusiness
//
//  Created by --Chao-- on 14-6-9.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

//=============App信息==============
#define kServiceName @"com.fangzhur.base"
#define kBMAppKey @"DblbbNXRsSuHyxOwOE4COFUR"
#define kAppCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//=============提示信息=================
#define kReleaseSuccessTipInfo @"      您的服务订单 \"%@\" 已经提交，请在发布的订单中查看该订单。房主儿交易顾问将为您提供服务，您可以选择心仪的交易顾问为您服务，请在\"我的订单-发布的订单\"中查看。"
#define kSelfHelpTipInfo @"当您下完订单后，稍后将会最多收到三个顾问服务意向，请您从中选择一位最合适的顾问。当您不满意顾问的服务，您可以随时更换。"
#define kHelpCodeTipInfo @"什么是互助码?\n\n好东西要分享, 使用好友的互助码（默认为手\n机号）, 您即可获得1000元代金券! 官方互助\n码是4000981985（客服热线）。\n\n注册完成后, 请用您的互助码去帮助更多的朋\n友吧!"

#define kPushTipString @"房主儿将按照您的需求为您推送符合定制条件的房源。您可以取消不满意的需求，取消后将不再接受不满意的房源信息。"

//=============常量=================
#define kSideMenuBackgroundColor RGBColor(232, 52, 71)
#define kFontName @"Helvetica-Light"
//默认头像
#define kDefaultHead @"moren_touxiang"
//默认用户名
#define kDefaultUserName @"欢迎来到房主儿"
//基色
#define kDefaultColor RGBColor(232, 52, 71)

#define kScreenScale [[UIScreen mainScreen] scale]

//只适用于控件宽度与屏幕宽度等宽的时候
#define kAdjustScale ((SCREEN_WIDTH - 320) - ((kScreenScale - 2) * 20))

//=============控件尺寸=================
#define kLoginViewFrame CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

//=============网络接口===========================================================

//快速登录获取验证码 (2.0 忘记密码-获取验证码)
#define kGetPassword @"/iosapp/login/smspwcode.php"
//登录
#define kLogin @"/iosapp/login/easy_login.php"
//用户信息获取
#define kUserInfo @"/iosapp/member/member.php"
////第三方登录回调
//#define kThirdLogin @"/iosapp/login/easy_login.php"

//用户信息修改提交
#define kUpdateInfo @"/iosapp/member/brokerProfile.php"
//修改密码
#define kModifyPwd @"/iosapp/member/pwdEdit.php"
//账户收支
#define kAccountDetail @"/iosapp/member/accountDetail.php"

//====忘记密码===
#define kForgotPassword @"/iosapp/login/forgetPsw.php"
//忘记密码-验证手机号
#define kFPCheckPhoneNumber @"/iosapp/login/checkname.php"


//===注册===

//获取验证码-完善资料
#define kGetCode @"/iosapp/login/smspw.php"
//校验验证码
#define kCheckCode @"/iosapp/login/checkcode.php"
//校验互助码
#define kCheckHelpCode @"/iosapp/login/checkhuzhu.php"
//完成注册
#define kFinishRegister @"/iosapp/login/registered.php"

//===========首页============
//广告位
#define kGetAdImage @"/iosapp/index/loading.php"
#define kAdDetail @"/iosapp/index/addetail.php"
//获取标签
#define kGetTag @"/iosapp/member/indextag.php"

//===========筛选===========

#define kAreaList @"/iosapp/cityarea_list.php"
#define kSubwayList @"/iosapp/com/new_ditie.php"
#define kGetScreenData @"/iosapp/highsearch3.0.php"

//==========搜索=============
//模糊搜索
#define kSearch @"/iosapp/search3.0.php"

//============房源列表=================

#define kTag_RentList @"/iosapp/rent/rentlist3.0.php"
#define kTag_SellList @"/iosapp/sell/selllist3.0.php"

//============房源详情=================

#define kRentDetail @"/iosapp/rent/rentdetail.php"
#define kSellDetail @"/iosapp/sell/selldetail.php"

//查看房主电话的次数
#define kTelephone @"/iosapp/member/ajaxHouse.php"
//关注
#define kAttention @"/iosapp/member/scdy.php"
//评价
#define kAppraise @"/iosapp/member/report3.php"
//分享更新查看次数
#define kShare @"/iosapp/member/share.php"


//============评论 & 私信=================

#define kComment @"/iosapp/house/comment.php"
#define kChat @"/iosapp/member/talk3.0.php"

//====================发布房源===================
//上传照片
#define kUploadHousePic @"/iosapp/rent/upload.php"
//整租
#define kAllRent @"/iosapp/guest/houseRent.php"
//合租
#define kTogetherRent @"/iosapp/guest/jointRent.php"
//出售
#define kSell @"/iosapp/guest/houseSale.php"
//发布房源时获取小区名字
#define kCommunityName @"/iosapp/guest/ajaxborough.php"

//===============房源定制=================

#define kCustomHouses @"/iosapp/project/ajaxcustomize.php"
//定制房源列表
#define kCustomList @"/iosapp/member/housecustomize.php"
//私人定制
#define kPersonalCustom @"/iosapp/personally.php"

//==============支付================

//银行列表
#define kBankList @"/iosapp/banklist.php"
//获取支付订单信息
#define kOrderInfo @"/iosapp/yeepayment/trade.php"
//获取支付链接
#define kGetPaymentURL @"/iosapp/yeepayment/new_trade.php"

//=========房源管理==================
#define kRentManagement @"/iosapp/member/manageRent.php"
#define kSaleManagement @"/iosapp/member/manageSale.php"

//============我的订单=================
//我的订单
#define kMyOrder @"/iosapp/member/serviceOrders.php"
//举报订单
#define kInformOrder @"/iosapp/member/orderReport.php"
//选择顾问
#define kChooseAgent @"/iosapp/member/chooseAdviser.php"
//取消订单
#define kCancelOrder @"/iosapp/member/orderCancel.php"
//确认完成服务
#define kCompleteService @"/iosapp/member/orderEvaluation.php"

//根据房源编号查询房源信息接口
#define kHouseInfoByID @"/iosapp/project/ajax.php"
//获取北京城区信息
#define kBeijingAreaInfo @"/iosapp"
//获取小区名称信息
#define kCommunityName @"/iosapp/guest/ajaxborough.php"
//发布订单
#define kReleaseOrder @"/iosapp/project/trade_save.php"
//支付宝回调接口
#define kAlipayCallBack @"/iosapp/project/alipay/notify_url.php"
//支付完成
#define kTradeFinished @"/iosapp/project/trade_finish.php"

//=============用户信息=================
//上传图片
#define kUploadPic @"/iosapp/member/upload.php"

//App下载地址
#define kAppDownload @"https://itunes.apple.com/us/app/fang-zhu-er/id840013807?l=zh&ls=1&mt=8"
//App评价
#define kAppComment @"itms-apps://itunes.apple.com/app/id840013807"
//版本检查
#define kAppVersion @"http://itunes.apple.com/lookup?id=840013807"

//========邀请好友=========

#define kAgentAboutTipString @"只需分享您的互助码给好友，好友加盟顾问后即可获得1000积分。而且，您好友每完成一次交易服务，房主儿网将永久补贴该服务费的5%作为现金收益送给您!邀请更多的好友加盟房主儿顾问，天天有钱赚!"
#define kFangzhurAboutTipString @"小主儿，送好友和自己一个获得万元房租的机会吧！快快分享您的互助码（手机号），好友注册即可参加房码抽奖，最高可获得1万元房码大奖，房码可以在“房主儿”抵房租和服务费呦！同时，好友抽中多少房码，也赠送您多少房码！分享越多积累越多！\nhttp://www.fangzhur.com/wap/registered.php"

//分享内容
#define kAgentShareContents(name) [NSString stringWithFormat:@"您的好友推荐使用房主儿网交易顾问APP，房主儿网——全国最大的个人房产O2O交易平台，邀请您成为高级合伙人，共享房产交易赚钱新模式，一月抢3单，收入轻松过万！我的互助码：%@（分享自@房主儿）", name]
#define kFangzhurShareContents(name) [NSString stringWithFormat:@"小伙伴，一起用\"无中介找房神器\"-房主儿网   房主面对面，无需中介费，还有超低价格的租赁、过户贷款等交易代办服务。\n注册用互助码（%@）得千元代金券哦！\nwww.fangzhur.com/wap 点击链接，开始找房", name]


//===========User defaults keys==============

#define Key_FirstLaunch @"FirstLaunch"

#define Key_CityURL @"CityURL"
#define Key_CityID @"CityID"
#define Key_CityName @"CityName"
#define key_CityRegion @"CityRegion"
#define Key_Subway @"Subway"
#define Key_Tag @"Tag"
#define Key_TagDictionary @"TagDictionary"
#define Key_LocationPush @"LocationPush"

#define Key_NewMessage @"NewMessageNumber"
#define Key_LoginToken @"LoginToken"
#define Key_UserName @"UserName"
#define Key_MemberID @"MemberID"
#define Key_HeadImage @"HeadImage"
#define Key_RoleType @"RoleType"
#define Key_Gender @"Gender"
//现金，积分，房码
#define Key_UserCash @"UserCash"
#define Key_UserCredits @"UserCredits"
#define Key_UserTickets @"UserTickets"
#define Key_BindingTag @"BindingTag"
