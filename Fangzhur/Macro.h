//
//  Macro.h
//  base
//
//  Created by ioswang on 13-10-8.
//  Copyright (c) 2013年 wbw. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#pragma mark ====================== color

#define RGBCOLOR(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#pragma mark ====================== UserDefault
#define USERDEFAULT_MANUAL_KEY @"user_default_manual_key"

#pragma mark ====================== 获取当前ios版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] integerValue]

#pragma mark ====================== 系统控件的高度，宽度
#define WIDTH_SCREEN_WIDTH     ([UIScreen mainScreen].bounds.size.width)   //屏幕窗口的宽
#define HEIGHT_SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)  //屏幕窗口的高
#define R     ([UIScreen mainScreen].bounds)

#define HEIGHT_NAVBAR_HEIGHT   44    //导航条的高
#define HEIGHT_TABBAR_HEIGHT   48    //tabbar的高
#define HEIGHT_STATUS_HEIGHT   20    //状态条的高
#pragma mark ======================
#pragma mark ======================

//分隔线
#define Line(line, originY, superView) \
line = [[UIView alloc] initWithFrame:CGRectMake(10, originY, 300, 1)];\
line.backgroundColor = [UIColor lightGrayColor];\
[superView addSubview:line]


#define LLABEL(label,rect,wtext,view)   UILabel *label = [[UILabel alloc]initWithFrame:rect];\
label.text = wtext;\
label.backgroundColor = [UIColor clearColor];\
label.font = [UIFont systemFontOfSize:15];\
label.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:240.0/255.0 alpha:1];\
[view addSubview:label];
//发布界面框框的高度

#define fieldHeight 40
//选择弹出视图的按钮的自定义
#define MyTextField(textField,rect,p,mytag,title,view,backImage) textField = [[UITextField alloc]initWithFrame:rect];\
textField.delegate = self;\
textField.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];\
textField.font = [UIFont boldSystemFontOfSize:12];\
textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;\
textField.tag = mytag;\
textField.textAlignment = NSTextAlignmentCenter;\
PublicView(p, mytag);\
p.noSelectTitle =title;\
textField.inputView = p;\
textField.text = title;\
textField.background = [UIImage imageNamed:backImage];\
textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_youy"]];\
textField.rightViewMode = UITextFieldViewModeAlways;\
[view addSubview:textField];\

#define MyTextField1(textField,rect,p,mytag,title,view,backImage) textField = [[UITextField alloc]initWithFrame:rect];\
textField.delegate = self;\
textField.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];\
textField.font = [UIFont boldSystemFontOfSize:12];\
textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;\
textField.tag = mytag;\
textField.textAlignment = NSTextAlignmentCenter;\
PublicView(p, mytag);\
p.noSelectTitle =title;\
textField.inputView = p;\
textField.text = title;\
[view addSubview:textField];\

//textField.background = [UIImage imageNamed:backImage];\

#define TwoMyTextField(textField,rect,p,mytag,title,view,backImage) textField = [[UITextField alloc]initWithFrame:rect];\
textField.delegate = self;\
textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;\
textField.font = [UIFont boldSystemFontOfSize:12];\
textField.textAlignment = NSTextAlignmentCenter;\
textField.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];\
textField.tag = mytag;\
BoderStyleColorGray(textField);\
TwoPublicView(p, mytag);\
textField.inputView = p;\
textField.text = title;\
textField.background = [UIImage imageNamed:backImage];\
[view addSubview:textField];\

#define ThreeMyTextField(textField,rect,p,mytag,title,view,backImage) textField = [[UITextField alloc]initWithFrame:rect];\
textField.delegate = self;\
textField.textAlignment = NSTextAlignmentCenter;\
textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;\
textField.font = [UIFont boldSystemFontOfSize:12];\
textField.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];\
textField.tag = mytag;\
ThreePublicView(p, mytag);\
textField.inputView = p;\
textField.text = title;\
textField.background = [UIImage imageNamed:backImage];\
[view addSubview:textField];\


#define ViewWidth self.frame.size.width
#define ViewHeight self.frame.size.height
#define ContentWidth 210


//设置黑色文本框边框的透明度
#define BoderStyleColor(textField) textField.textAlignment = NSTextAlignmentCenter;\
textField.background = [UIImage imageNamed:@"liebiaokuang_1"];

//设置灰色文本框边框的透明度
#define BoderStyleColorGray(textField) textField.textAlignment = NSTextAlignmentCenter;\
textField.background = [UIImage imageNamed:@"liebiaokuang_1"];

//区域找房中的宏定义
#define NEWLABEL(label,rect,ttext,view,img1,img2) UILabel* label = [[UILabel alloc]initWithFrame:rect];\
label.backgroundColor = [UIColor clearColor];\
label.text = ttext;\
[view addSubview:label];\
UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, label.frame.origin.y+LABELHEIGHT, WIDTH_SCREEN_WIDTH, 1)];\
img1.image = [UIImage imageNamed:@"gaojiline"];\
[view addSubview:img1];\
UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(label.frame.size.width+215, label.frame.origin.y+10, 8, 16)];\
img2.image = [UIImage imageNamed:@"icon_jiantouyou"];\
[view addSubview:img2];

#define  NEWFIELD(field,imageView,imagerect,rect,view,ttext)         UIImageView *imageView = [[UIImageView alloc]initWithFrame:imagerect];\
[view addSubview:imageView];\
field = [[LUITextField alloc]initWithFrame:rect];\
field.textColor = RGBCOLOR(2, 114, 204);\
field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;\
field.delegate = self;\
field.text = ttext;\
field.textAlignment = NSTextAlignmentRight;\
field.borderStyle = UITextBorderStyleNone;\
[view addSubview:field];\

//imageView.image = [UIImage imageNamed:@"liebiaokuang"];\

#define  WuYENEWFIELD(field,imageView,imagerect,rect,view,ttext)        imageView = [[UIImageView alloc]initWithFrame:imagerect];\
[view addSubview:imageView];\
field = [[LUITextField alloc]initWithFrame:rect];\
field.textColor = RGBCOLOR(2, 114, 204);\
field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;\
field.delegate = self;\
field.text = ttext;\
field.textAlignment = NSTextAlignmentRight;\
field.borderStyle = UITextBorderStyleNone;\
[view addSubview:field];\

#define PickerView(picker,field,number,array,dic) FieldPickerView *picker = [[FieldPickerView alloc]initWithField:field andNumberOfComponents:number andLeftArray:array andRightDic:dic];\
picker.frame = CGRectMake(0, 0, WIDTH_SCREEN_WIDTH, 216);\
field.inputView = picker;


#define LEFTSpace  20
#define LABELHEIGHT 36
#define LABELWIDTH 80
#define FieldLeft 90
#define ImageWidth 220
#define FieldWidth 180

//长短button的图片
//#define littleBtn @"liebiaoduan"
#define littleBtn @"liebiaoduan"
#define llittleBtn @"liebiao63"

//#define bigBtn @"fangwuleixing2"
#define bigBtn @"liebiaokuang"

#define LABELCELL(label,rect) UILabel *label = [[UILabel alloc]initWithFrame:rect];\
label.lineBreakMode = NSLineBreakByCharWrapping;\
label.numberOfLines = 0;\
label.font = [UIFont systemFontOfSize:15];\
[cell.contentView addSubview:label];

#define LABELFont(label,rect) UILabel *label = [[UILabel alloc]initWithFrame:rect];\
label.font = [UIFont boldSystemFontOfSize:15];\
[cell.contentView addSubview:label];

#pragma mark ================================================整租界面的自定义

#define LAYER(layers,view) CALayer *layers = view.layer;\
layers.borderColor = [[UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:1]CGColor];\
layers.borderWidth = 1;\
layers.borderColor = [UIColor lightGrayColor].CGColor;

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//layers.borderColor = [[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]CGColor];\

#define LAYERWu(layers,view) CALayer *layers = view.layer;\
[layers setCornerRadius:1.0];\
layers.borderColor = [[UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:1]CGColor];\
layers.borderWidth = 0.5f;

#define LABEL(name,rect,value,view)     UILabel *name = [[UILabel alloc] initWithFrame:rect];\
name.backgroundColor = [UIColor clearColor];\
name.font = [UIFont boldSystemFontOfSize:13];\
name.textColor = [UIColor grayColor];\
name.text = value;\
[view addSubview:name];\

#define FIELD(name,rect,view,mtag) name = [[UITextField alloc]initWithFrame:rect];\
name.delegate = self;\
name.tag = mtag;\
name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;\
name.returnKeyType = UIReturnKeyDone;\
name.textAlignment = NSTextAlignmentCenter;\
name.keyboardType = UIKeyboardTypeNumbersAndPunctuation;\
name.font = [UIFont systemFontOfSize:12];\
[view addSubview:name];

// 导航条和tab高度
#define NAVBAR_HEIGHT 44.0
#define TABBAR_HEIGHT 49.0
#define Height_Footer 30.0f

#define rentTypeButtonSpaceWidth (self.view.frame.size.width-240)/2
#define rentTypeButtonHight 38
#define MmyViewHeight 73

#define Twidth self.view.frame.size.width/7
#define SecondBtnHeght 35  //第二栏button的高度
#define SecondImageName @"diban2(1)"  //第二栏button的图片
#define RentTypeHeight  40   //第一栏button的高度
#define SecondY 42 //第二栏button的纵坐标
#define SSecondY 0 //第二栏button的纵坐标

#define MyViewHeight  40 //列表和地图的纵坐标

#define wSpace 80 //整租合租出售界面文字和文本框的间距

//#define Header [[[NSUserDefaults standardUserDefaults] valueForKey:@"CityURL"] stringByAppendingString:@"/iosapp"]
#define Header1 @"http://www.fangzhur.com/"  //正式图片前缀
#define Header2 @"http://www.fangzhur.com/iosapp"

#define Header @"http://172.18.1.200/iosapp"  //正式2
//#define Header @"http://bj.unewfz.com/iosapp" //北京utf-8测试
//#define Header @"http://bj.newfz.com/iosapp"  //正式2
//#define Header1 @"http://www.newfz.com/"  //照片前缀

//#define Header @"http://fangzhu666.com/iosapp"  //内网
//#define Header1 @"http://fangzhu666.com"  //测试图片前缀

//#define Header @"http://www.fz0314.com/iosnew"   //丽鹏

#pragma mark =============================  获取版本号
#define FSystemVersion [NSString stringWithFormat:@"%@/project/banbencheck.php",Header]
#pragma mark +++++++++++++++++++++搜索房源首页的url
#pragma  mark ================================================   地图下只点击整租、合租、出售时发送请求

//整租
#define Zhengzu [NSString stringWithFormat:@"%@/rent.php",Header]
//合租
#define Hezu [NSString stringWithFormat:@"%@/renthezu.php",Header]
//出售
#define Chushou [NSString stringWithFormat:@"%@/sell.php",Header]

#pragma  mark ================================================   点击地图界面的标注进入房源列表的url
//出售
#define MapSell [NSString stringWithFormat:@"%@/sell/mapboroughsell.php",Header]
//整租合租
#define MapRentAndHeZu  [NSString stringWithFormat:@"%@/rent/mapboroughrent.php",Header]
#pragma mark =======================================================================  点击地图标注进入列表页后点击cell进入房源详情界面
//出售
#define MapSellDetail  [NSString stringWithFormat:@"%@/sell/selldetail.php",Header]
//整租和合租
#define MapRentDetail  [NSString stringWithFormat:@"%@/rent/rentdetail.php",Header]

#pragma mark =======================================================================   地图下整租、合租、出售下点击附近、房屋类型、价钱开始请求数据

//同  地图下只点击整租、合租、出售时发送请求

#pragma mark =======================================================================   地区信息

#define BeijingAreaUrl [NSString stringWithFormat:@"%@/",Header]
#pragma mark =======================================================================   首页切换成列表界面点击cell去请求房源的详细数据
//出售
//整租合租
#define ListRentDetail [NSString stringWithFormat:@"%@/rent/rentdetail.php",Header]

#pragma mark +++++++++++++++++++++搜索房源首页列表页的url
#pragma  mark ================================================   列表下只点击整租、合租、出售时发送请求

//整租
#define ListRent [NSString stringWithFormat:@"%@/rent/rentmap.php",Header]

//合租
#define ListHezu [NSString stringWithFormat:@"%@/rent/hezumap.php",Header]
//出售
#define ListSell [NSString stringWithFormat:@"%@/sell/sellmap.php",Header]

#pragma mark =======================================================================   整租、合租、出售下点击附近、房屋类型、价钱开始请求数据
//搜索房源界面获取整租小区数据
//#define SearchZZHZURL  [NSString stringWithFormat:@"%@/rent/rentlist.php",Header]
#define SearchZZURL  [NSString stringWithFormat:@"%@/rent/rentmap.php",Header]
//合租
#define SearchHZURL  [NSString stringWithFormat:@"%@/rent/hezumap.php",Header]
//搜索房源界面获取出售小区数据
//#define SearchSellURL  [NSString stringWithFormat:@"%@/sell/selllist.php",Header]
#define SearchSellURL  [NSString stringWithFormat:@"%@/sell/sellmap.php",Header]

#pragma mark +++++++++++++++++++++  登录注册的url

//登录
#define UserLogin [NSString stringWithFormat:@"%@/login/login.php",Header]
//注册
#define UserRegist [NSString stringWithFormat:@"%@/login/registered.php",Header]
//注册获取手机验证码
#define UserSms [NSString stringWithFormat:@"%@/login/sms.php",Header]
//注册时验证互助码的正确性
#define HuZhuCode [NSString stringWithFormat:@"%@/login/checkhuzhu.php",Header]

#pragma mark ================================ 获取用户信息的url

#define MemberInfoURL [NSString stringWithFormat:@"%@/member/member.php",Header]

#pragma mark ================================ 修改用户密码的url

#define ModifyPasswordURL [NSString stringWithFormat:@"%@/member/pwdEdit.php",Header]

#pragma mark ===============================修改用户资料

#define ModifyUserInfoURL [NSString stringWithFormat:@"%@/member/brokerProfile.php",Header]

#pragma mark +++++++++++++++++++++  已关注界面url  同ListSellDetail  ListRentDetail

#pragma mark +++++++++++++++++++++  已浏览界面url  同ListSellDetail  ListRentDetail

#pragma mark ==============================发布整租房源的url
#define ZhengZuFabu [NSString stringWithFormat:@"%@/guest/houseRent.php",Header]
#pragma mark ==============================发布合租房源的url

#define HeZuFabu [NSString stringWithFormat:@"%@/guest/jointRent.php",Header]

#pragma mark ==============================发布出售房源的url

#define ChuShouFabu [NSString stringWithFormat:@"%@/guest/houseSale.php",Header]

#pragma mark ==================================   上传图片的url

#define SendImageURL [NSString stringWithFormat:@"%@/rent/upload.php",Header2]

//发布房源时获取小区名字的url
#define CommunityNameGetURL [NSString stringWithFormat:@"%@/guest/ajaxborough.php",Header]

//房源管理URL
#define HouseManagerURL [NSString stringWithFormat:@"%@/member/manageRent.php",Header]
//找回密码时候验证手机号码的正确性
#define CheckTelIsRight [NSString stringWithFormat:@"%@/login/checkname.php",Header]


#define GetCodeWhileForget [NSString stringWithFormat:@"%@/login/smspw.php",Header]
//找回密码
#define FindPassword [NSString stringWithFormat:@"%@/login/forgetPsw.php",Header]
//关注
#define GuanZhuURL [NSString stringWithFormat:@"%@/member/scdy.php",Header]
//取消关注
#define QXguanzhuURL [NSString stringWithFormat:@"%@/member/scdy.php",Header]

//用户头像认证
#define UserHeadImageURL [NSString stringWithFormat:@"%@/member/upload.php",Header]
#pragma mark ======================高级搜索
//地铁线路
#define DiTieSearch [NSString stringWithFormat:@"%@/com/ditie.php",Header]
//高级搜索之区域搜索
#define TopSearch [NSString stringWithFormat:@"%@/search.php",Header]
//高级搜索之地铁搜索
#define SubwaySearch [NSString stringWithFormat:@"%@/waysearch.php",Header]



