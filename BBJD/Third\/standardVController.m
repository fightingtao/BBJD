//
//  standardVController.m
//  BBJD
//
//  Created by cbwl on 16/9/12.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import "standardVController.h"
#import "publicResource.h"
@interface standardVController ()<UIGestureRecognizerDelegate>
{
    UIScrollView *scrollview;

}
 
@end

@implementation standardVController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // white.png图片自己下载个纯白色的色块，或者自己ps做一个
    [navigationBar setBackgroundImage:[[communcat sharedInstance] createImageWithColor:MAINCOLOR] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = ViewBgColor;
    self.automaticallyAdjustsScrollViewInsets=false;
    
    [self.navigationController.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];//设置navigationbar的颜色
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"配送服务标准"];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    
    scrollview = [[UIScrollView alloc]init];
    scrollview.frame = self.view.bounds;
    [self.view addSubview:scrollview];
    NSString *A = @"一、仪容仪表 \n      1、仪容\n      整体要求：符合工作需要，自然大方、干净整洁\n      头发：男达人以前不盖额，侧不掩耳，后不及领为宜，不允许留大鬓角，不留怪异发型，不可烫彩色发；女达人长发要求在工作时间内必须将头发用黑色皮筋束起；装饰发夹款式简洁明快。中发要求：前不过眉；后不过肩；两侧的头发应收拢于耳后。短发要求：前不过眉；侧不盖耳；后不抵领；不得过于蓬松。\n      达人保持面部干爽、无油光，男达人不留胡须，常修剪鼻毛，保持面部洁净。\n      保持口腔清洁，达人上班期间不得饮食刺激性较大的饮料和食物如上班前和期间不吃有异味食物，如大蒜、韭菜、榴莲等\n      体味：头发保持干净整洁、无头屑、无异味；不使用气味强烈的定型发胶以及喷雾；勤洗澡注意个人卫生，防止异味。\n      手部：保持干净、清爽，指甲修剪整齐，不露白边无污垢，不涂有色指甲油。\n      服装及配饰要求\n      在线接单服务期间必须着工作服，穿戴必须整齐，纽扣齐全并扣紧，不得披衣、敞怀；工作服须常换洗，保持干净，无明显污垢、无破损、无异味。衣领、袖口保持干净，不可将袖口、裤管挽起。\n      工牌：\n      鞋子要求：不允许穿拖鞋。\n      配饰要求：女达人可佩项链，项链款式简单大方，宗教信仰饰物不宜突兀，禁止佩戴较为夸张的颈部饰品（过大过粗的金属链子）；手部饰品只可佩戴手表、戒指（婚戒，订婚戒指）等，但要求款式简洁、符合达人特点要求，禁止佩戴颜色鲜艳、款式夸张的配饰。\n      眼镜款式要求简洁大方；可选择无框或细框眼镜，镜片颜色要求无色为最优；禁止配戴颜色鲜艳的大宽边板材眼镜。\n      个人卫生要求：\n      勤洗头，勤洗澡，保持头发、身体无异味；禁止岗前饮酒或含有酒精的饮料；注意个人卫生，养成去完洗手间后立即洗手的良好习惯。\n       二、沟通、礼仪\n      接电话超尽量控制在三声以内，保持微笑。客户先挂电话，不可在客户之前先挂断电话或在沟通中终止通话。\n       1、沟通技巧及注意事项：\n       电话沟通：接听电话不可太随便，得讲究必要的礼仪和一定的技巧，以免产生误会。无论是打电话还是接电话，都应做到语调热情、大方自然、声量适中、表达清楚、简明扼要、文明礼貌。\n       注意事项：在整个服务流程中主动电话联系客户的次数控制在3次以内，电话次数是展现专业程度的一个方面，多次打扰也对客户的消费体验有负面影响。\n       2、面对面沟通：面对面沟通成功的“四要素”——语言、语调、表情、手势\n       ◆在达人与客户面对面沟通时,说什么很重要,但是更重要的是你怎样说!\n       ◆你讲话时对客户产生的影响是一种感觉,而不是事实!\n       ◆在与客户沟通时,沟通成功四要素中语言只占百分之七。\n       3、基本用语：\n       “您好”或“你好”\n       初次见面或当天第一次见面时使用。清晨（十点钟以前）可使用“早上好”，其他时间使用“您好”或“你好”。\n       “对不起，请问……”\n       请客户等候时使用，态度要温和且有礼貌，无论客户等候时间长短，均应向客户表示歉意。\n       “让您久等了”\n       如需让客户出示证件时，应使用此语。\n       “麻烦您，请您……”\n       当需要打断客户或其他人谈话的情况时使用，要注意语气和缓，音量要轻。\n       “不好意思，打扰一下……”\n       对其他人所提供的帮助和支持，均应表示感谢。\n       “谢谢”或“非常感谢”\n       “再见”或“欢迎下次使用，谢谢对我们工作的支持”\n       4、对客户的禁语：\n      哎！/喂！\n       能不能快点！\n       没有！\n       我就这态度！我态度怎么了？\n       不行你就拒收，没人拦你！\n       你以为你是谁！\n       不能提供！\n       你自己看着办吧！\n       还要不要了！\n       无法保证！\n       你问我，我问谁！\n       不行！\n       你想投诉就投诉吧，投诉也没用！\n       你怎么这么挑剔！\n       不知道！\n       你留的电话是错误的，还怪谁！\n       我管不了!\n       这不是我的责任！\n       你怎么这么多毛病！\n       自己看啊！\n       脑子有病！\n       我没时间和你废话！\n       有完没完！\n       我没时间！\n       就你事多！\n       给你打过好几次电话，为什么不接！\n       你等着吧！\n       还没有试完，准备试到什么时候！\n       你烦不烦！\n       爱要不要！\n       能不能快点，我还有一大堆要送！\n       你快点！\n       不是告诉你了吗？怎么还问\n       地址怎么瞎写！\n       整个配送流程微笑服务\n       配送流程\n       1、接单\n  邦办即达平台通过对流入的订单整理指派达人，达人接到订单后存在两种接单方式：去网点取单和在配送区域网格接单（订单送到配送区域）\n       2、预约配送\n       您好！我是邦办即达达人，请问您是**先生/吗？\n       您在***（当当网、天猫超市、京东商城……）的包裹到了，请问您方便签收吗？\n       好的!**分钟后给您送达！再见！（客户先挂电话）\n       3、配送\n       1.自我介绍\n       针对与客户的熟悉程度不同，应采用不同的自我介绍方式。\n       标准用语：您好！我是邦办即达达人！\n       4、验货签收\n       将快件双手递给客户(小件)，\n       标准用语：“X先生/小姐，这是您的包裹，请您验货签收”\n       将面单呈现给客户，并用右手五指并拢邀请指向寄件或收件人签署栏，\n       标准用语：“X先生/小姐，麻烦您在这里签收，谢谢!”。\n       5、信息反馈\n       订单配送后通过APP实时反馈配送状态和配送异常原因。如果APP有异常如实向站点管理人员反馈当天包裹的配送情况，比如拒收原因、未妥投订单的滞留原因，站长会在第一时间更新系统信息，结束当天配送工作。\n       四、服务注意事项：\n       1、送货上门\n       2、主动帮助客户开箱 验货  前提是要请客户在面单上备注签字外包装完好\n       保证第一映像会让你更顺利的服务好客户，所以配送中多用礼貌用语比如（您/您好/请/麻烦/多谢）+干净整洁的仪容仪表，\n       3、前台或他人代签应致电客户：“您好X先生/小姐，您的包裹已经由前台/同事**代为签收，请及时取回”除了电话通知，同事需要短信提醒客户及时取回包裹。\n       五、标准话术：\n       话术一：接客户电话时，“您好！我是邦办即达达人，有什么可以帮您！”\n       话术二：预约配送：“您好！请问是李先生/女士吗?”\n       话术三：预约配送：“您好！我是邦办即达达人，您在天猫超市订购的商品到了，我大约10分钟送达，您方便签收吗？”\n       话术四：预约配送：“好的，稍后为您送达，再见！”\n       话术五：送货上门时，“您好！我是邦办即达达人，这是您在天猫超市订购的商品，请您验货签收！谢谢！”\n       话术六：提供增值服务时，“请问您有生活垃圾需要我帮您带走吗？ ”\n       话术七：配送结束时，“如果您对我的服务满意，请您好评点赞！祝您购物愉快！谢谢！”\n       \n六、异常处理方法及流程\n       1.是否可以他人代收？\n       客户不在送货地址征得客户同意他人代签收或者预约再次配送时间系统需同步\n       经客户同意的代签收，面单上需要有门卫、前台等字样，最好盖章保存半年以上，面单需要送回站点。\n       2.拖件不齐\n       需要联系客户，按照客户意愿操作。\n       不可以半收半退，在一件丢的情况下，与客户协商赔偿丢的部分，其他的给客户送到这样可以减少损失。\n       3.客户拒收后还要货怎么办 ？\n       达人APP端只可以反馈成功，其它异常需要把订单退回站点，系统反馈拒收后，如客户要求再次配送，把情况如实反馈给站点即可。\n       4.成功改拒收怎么处理？\n       如果客户签收后要拒收，请客户联系商家安排退货。如果是误签收，第一时间联系站点告知情况等待操作指令。\n       5.货物破损怎么处理？\n       接收订单时发现订单破损需要在交接单上备注订单号，交接人签字确认，尝试配送，如配送失败直接退回站点。\n       达人已取件或在配送途中破损：第一时间多角度拍照保存，最好视频拍摄。主动联系客户协商赔付破损金额，经客户同意系统提交成功，把具体情况反馈给站点负责人（落地配私了订单与客户协商好不要告知商家，避免除订单破损或丢失赔偿以外的费用发生。）\n       6.滞留\n       客户电话停机/未接电话/短信呼，地址不详细或地址不存在无法送达时，把情况告知站点直接把订单退回站点即可\n       要求：\n       滞留原因必须真实，原因真实可以减少虚假罚款。\n       注意：\n       签收单至少保存半年以上，签收单必须要有签名和签收时间（经客户同意的代签收，面单上需要有门卫、前台等字样，最好盖章），签收单每天跟异常订单退回站点。面单作为投诉举证和核对交接数量的重要证据。";
    
    UILabel *a =[[UILabel alloc]init];
    a.frame = CGRectMake(10,10, SCREEN_WIDTH-20,[self rectWithStr:A]);
    a.text =A;
    [self WithLabel:a];
    [self creactRightGesture];
}

- (CGFloat )rectWithStr:(NSString *)str{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:kTextMainCOLOR} context:nil];
    scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, rect.size.height+64+49);
    return rect.size.height;
}

- (void)WithLabel:(UILabel *)label{
    
    label.textColor = kTextMainCOLOR;
    label.numberOfLines = 0 ;
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    [scrollview addSubview:label];
}

- (void )floatWithLabel:(UILabel *)label WithStr:(NSString *)Str WhichLab:(UILabel *)WL{
    
    label.frame = CGRectMake(10,10+WL.frame.origin.y+WL.frame.size.height, SCREEN_WIDTH-20,[self rectWithStr:Str]);
}

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 右滑返回上一级_________
///右滑返回上一级
-(void)creactRightGesture{
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    leftEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:leftEdgeGesture];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

-(void)handleNavigationTransition:(UIScreenEdgePanGestureRecognizer *)pan{
    [self leftItemClick];
}

@end
