//
//  RegistDelegateViewController.m
//  CYZhongBao
//
//  Created by cbwl on 16/5/1.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "RegistDelegateViewController.h"
#import "publicResource.h"

@interface RegistDelegateViewController ()

{
    UIScrollView *scrollview;
    float _lbl_height;
}

 

@end

@implementation RegistDelegateViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
//    self.hidesBottomBarWhenPushed=NO;
    self.tabBarController.tabBar.hidden=YES;

    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lbl_height=0;
    self.view.backgroundColor = ViewBgColor;
 
    self.navigationItem.titleView = [[navLabel alloc] initWithFrame:lableFrame titile:@"邦办即达-达人协议"];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    scrollview = [[UIScrollView alloc]init];
    scrollview.frame = self.view.bounds;
    scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 6500);
//    if (SCREEN_HEIGHT == 667)
//    {
//        scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 5700-667*2-480);
//    }
//    if(SCREEN_HEIGHT == 736)
//    {
//        scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 5200-756*2-480);
//    }
    
    [self.view addSubview:scrollview];
    
    NSString *A = @"本条款需由您与邦办即达平台经营者共同缔造，在下载邦办即达应用程序或使用我们的服务之前，请先仔细阅读本《用户条款》，一旦您点击登录按钮，即表示您已接受了以下条款和条件，本用户条款即对您与邦办即达经营者之间产生合同效力。\n以下这些条款和条件(以下简称达人条款）适用于您访问和使用我们的网站www.bangbanjida.com以下简称（网站）、服务、应用程序上或通过他们向您提供的所有信息、建议和/或服务。";
    NSString *B = @"1、邦办即达";
    NSString *C = @"    邦办即达是包括但不限于域名为www.bangbanjida.com的web站点和名为“邦办即达”的应用合称，归属于南京邦办网络科技有限公司。";
    NSString *D = @"2、邦办即达提供哪些服务";
    
    NSString * E = @"    a.邦办即达平台是为达人提供用户信息管理、配送信息浏览查询、配送交易撮合与处理、订单查询与管理、配送费代收、代付等互联网信息服务的在线交易处理服务的网络平台。\n    b.达人可在平台发布物流配送需求信息或接受并提供完成站点指示配送任务的服务。邦办即达配送平台作为信息发布、服务平台，提供信息服务，由平台站点自主选择发布任务。达人在完成站点指示的任务后按照站点设定的费用标准支付给达人报酬。\n    c.达人自愿利用闲暇时间并根据自己的行程安排，自主选择是否接受本平台上站点发布的服务需求。";
    NSString * F = @"3、签约达人身份要求和承诺";
    NSString * G = @"    a、您首次登录时，即默认使用邦办即达，使用邦办即达服务您需向邦办即达提交身份验证信息、支付账户等信息。\n    b、您必须具有完全民事行为能力且具备相应资质才能承接配送需求信息。您承诺：如果是代表个人签订本合约，您对所发信息真实性、安全性、合法性进行保证。\n    c、您必须年满18周岁具有完全民事行为能力和劳动能力，并且具备相应的资质才能注册为达人。您承诺：根据配送要求，将有配送需求站点的订单按照包裹面单信息保质保量配送给消费者；并认可，接受并承担因配送行为所引发的一切可能责任（包括但不限于自身及他人人身安全或财产安全责任），同时承担因配送所带来的客服理赔责任。您申请网络达人不视为与南京邦办网络科技有限公司形成事实上的劳动关系，您明确达人不是南京邦办网络科技有限公司的职工，与南京邦办网络科技有限公司不存在劳动关系。您申请成为网络达人，同意接受配送站点的相应的业务培训和管理。该类培训和管理只是为了完善服务的基本需求，不视为达人与邦办即达经营者公司形成事实上的劳动关系。";
    NSString * H = @"4、如何使用服务和应用程序";
    NSString * I = @"    a.应用程序允许达人在邦办即达平台上接受物流配送需求信息。\n    b.对于站点使用者需操作邦办即达管理后台，发布用人需求，包括大体配送区域，单量，价格，需求人数。系统会针对性推送给符合条件的达人。\n    c.达人在登录状态下会接收到需求站点推送过来的用人需求，达人抢单确认可以提供配送服务。\n    d.您已下载应用程序的移动设备上应安装GPS接收器。该接收器会测定您所在的位置，并将您的位置信息上传到服务器，以便站点了解您的位置。站点管理方有权决定是否使用每个达人的请求，也完全有权知悉达人在服务期间的位置信息。\n    e.为避免疑问，特澄清以下信息：邦办即达平台上包含多个配送服务提供站点。站点可以在有需求时自由发送用人需求，邦办即达配送平台并不直接参与站点与达人之间的配送交易。站点和达人双方应明确各项规范和要求，避免发生争议，邦办即达平台运营者南京邦办网络科技有限公司不参与任何纠纷，但双方可以寻求邦办即达平台协助调解。\n    f.为确保达人安全抵达目的地，避免或减少因发生交通事故等造成自身或他人损失，所有达人委托南京邦办网络科技有限公司统一向保险公司办理保险业务，通过账户中心向达人在接当天首单时自动扣取1元/人费用作为保险费用，由邦办即达平台代为扣除并统一支付给南京邦办网络科技有限公司。";
    NSString * J = @"5、达人对应用程序或服务的正确使用保证";
    NSString * K = @"       a.您保证向邦办即达平台提供的信息正确、完整。承认邦办即达配送平台在任何时候都有权验证您的信息，并有权在不提供任何理由的情况下拒绝向您提供服务或拒绝您使用应用程序。如果您的移动设备不兼容或者移动设备下载的应用程序版本有误，邦办即达概不承担责任。如果您在不兼容或未授权的设备上使用服务或应用程序，邦办即达保留终止向您提供服务和拒绝您使用程序的权利。\n    b.您使用应用程序或服务，即表示您还同意以下事项：\n    	您出于自己的个人用途使用服务或下载应用程序，并且不会转售给第三方；\n    	您不会授权其他人使用您的账户；\n    	您不会在没有恰当授权的情况下使用受他人任何权利约束的账户；\n    	您不会将服务或应用程序用于非法目的；\n    	您不会应用服务或应用程序骚扰、妨碍他人或造成不便；\n    	您不会尝试危害服务或应用程序；\n    	未获邦办即达许可，您不会复制或分发应用程序或其他邦办即达内容；您会妥善保管平台账户名和密码或者其它应用于邦办即达的任何身份识别信息，该账户用户名及密码只限于您本人使用，通过该账户进行的任何操作均视为您本人接受，相关责任亦有您本人承担；\n    	在完成配送服务的过程中获取的任何有关本平台或任何第三方的信息，包括但不限于姓名，联系方式，地址等均需保密，不得传播，泄露，倒卖，给他人或邦办平台带来损失的，您应当赔偿；\n    	当我们提出合理请求时，您会提供任何身份证明；\n    	您遵守国家和地区的法律法规。\n    如违反以上任意一条规则，邦办即达平台保留立即终止向您提供服务和拒绝您再次申请使用的权利。";
    NSString * L = @"6、信息服务费及配送付款规定";
    NSString * M =@"        a.邦办即达信息服务平台向您提供的服务付出了大量成本但目前向您提供的所有服务均为免费。如未来邦办即达向您收取合理费用，邦办即达会采取合理途径提前通知您，确保您有充分选择的权利。\n    b.您使用邦办即达信息平台即表示您授权并同意邦办即达经营者可实施下列权利：\n    	南京邦办网络科技有限公司授权邦办即达经营者代表南京邦办网络科技有限公司向邦办即达信息平台的使用者收取配送服务费，使用者同意上述行为；\n    	平台使用者和南京邦办网络科技有限公司同意配送服务费须通过邦办即达账户中心结算，并授权邦办即达经营者可以从各方在邦办即达账户中心或注册服务时提供的银行账户中扣除或退回据实发生的或相关的配送服务费用。\n    	用户同意邦办即达经营者处理配送服务费结算业务，为授权委托行为，经营者不对双方交易行为真实性或瑕疵承担任何责任。\n    	达人在认证时，接单服务前，须先在邦办即达中存入规定的信用金保证服务的可持续性。配送需求方始终有责任及时支付产生的费用。\n    	配送价格是配送需求站点自行设定，达人和站点协商一致与邦办即达平台及其运营人员没有关联。\n   	达人可以在个人收益中心查看收益、扣款等资金交易明细，并进行充值及提现操作。";
    NSString * N =@"7、达人的赔偿责任及范围";
    NSString * O =@"        您在接受本《达人条款》并使用应用程序或服务时，即表示同意：对于因以下事项产生的或与以下事项相关的任何索赔、费用、赔偿、损失、债务和开销（包括律师费和诉讼费），您将全额承担责任。\n    a.您触犯或违反《达人条款》中的任何条款或任何现行有效的法律法规造成自己或他人损失。\n    b.您触犯任何第三方的任何权利，造成自己或他人损失。\n    C.您使用或滥用应用程序或服务造成自己或他人损失。";
    NSString * P =@"8、网络信息平台的责任约定及免责款项";
    NSString * Q =@"        a.在网站、服务和应用程序上或通过它们向您提供的信息、推荐和/或服务仅用作一般参考信息，并不构成实质性建议。邦办即达在合理的范围内保证应用程序及信息内容正确，但不保证没有错误、缺陷、恶意软件和病毒。\n    b.对于因使用（或无法使用）应用程序导致的任何损害，包括但不限于由恶意软件、病毒、信息的任何不正确或不完整导致的损害，除非此类损害由邦办即达方面任何蓄意不当行为或重大疏忽造成的，否则邦办即达概不负责。此外，对于因使用（或无法使用）与应用程序的电子通讯手段导致的任何损害，包括但不限于因电子通信传达失败或延时、第三方或用于电子通信的计算机程序对电子通信的拦截或操纵，以及病毒传输导致的损害，邦办即达也概不负责。\n    在不损害上述约定内容的情况下，如有法律强制性规定网络平台承担责任的，您同意接受邦办即达承担的全部责任绝不超过500元人民币。";
    NSString * R =@"9、配送服务质量的归责";
    NSString * S =@"         您通过邦办即达平台获得配送需求信息，需按照站点的服务要求去完成订单服务，达人和站点负责人在站点达成服务要求一致，达人承诺遵守服务流程。如因达人原因未满足站点对于订单的配送服务要求，达人接受因服务质量问题的投诉，并承担相应的投诉及快件破损责任。邦办即达平台会对您的评价进行反馈，但不承诺对配送纠纷承担解决义务。";
    NSString * T =@"10、合约的期限和终止";
    NSString * U =@"        a.邦办即达和您订立的这份合约是无固定期限合约。\n    b.您有权随时通过永久性删除智能手机上安装的应用程序来终止合约，这样将禁止您使用应用程序和服务。您也可以随时按照邦办即达的说明注销用户账号。\n    c.如果您触犯或违反本《用户协议》，邦办即达有权随时终止合约并立即生效（即禁止您使用应用程序和服务）\n    d.合约终止时，您应向本平台指定人员办理相关事务交接并退还相关设备、文件等手续；未按规定办理手续的，邦办即达平台有权冻结您账户里的资金。";
    
    NSString * V = @"11、法律责任";
    NSString * W = @"       a.您违反本协议及相关法律规定的义务的，应当向本平台承担违约责任或赔偿责任\n    b.您保证签署和履行本协议，不违反您与其他主体之间的契约或您负有的其他义务，不侵犯任何第三人的合法权益，否则由此造成平台损失的，您需承担赔偿责任。";
    NSString * X = @"12、适用法律和争议处理";
    NSString * Y = @"       a.本条款的订立、执行和解释及争议的解决应适用中国法律。\n    b.本协议所有条款的标题仅为阅读方便，本身并无实际含义，不能作为本协议涵义解释的依据。\n    c.本协议条款无论因何种原因部分无效或不可执行，其余条款仍有效，对双方具有约束力。\n    d.本协议签订地为中华人民共和国江苏省南京市玄武区长江路99号长江贸易大楼16楼。\n    e.如双方就本协议条款内容或其执行发生任何争议，双方应尽力友好协商解决；协商不成时，任何一方均可向合同签订地的人民法院提起诉讼解决。";
    NSString * Z = @"13、其它事项";
    NSString * str1 = @"邦办即达保留自行决定随时修改或替换《用户条款》版本的任何内容，或者更改、暂停或中断服务或应用程序的权利。届时，邦办即达只需在网站张贴公告或者通过服务、应用程序或电子邮件发送通知。邦办即达也可以对某些功能和服务施加限制，或者限制您访问部分或全部服务，恕不另行通知，也不承担任何责任。\n    邦办即达经营者有权在公告告知的前提下，将本协议的权利和义务一并转让给邦办即达经营者的关联公司或指定公司，具体受让的关联公司或指定公司以本平台公告为准，协议转让一经本平台公告后7日即生效。";
    UILabel *a =[[UILabel alloc]init];
    a.frame = CGRectMake(10,10, SCREEN_WIDTH-20,[self rectWithStr:A]);
    a.text =A;
    [self WithLabel:a];
    
    UILabel *b =[[UILabel alloc]init];
    [self floatWithLabel:b WithStr:B WhichLab:a];
    b.text =B;
    [self WithLabel:b];
    
    UILabel *c =[[UILabel alloc]init];
    [self floatWithLabel:c WithStr:C WhichLab:b];
    c.text =C;
    [self WithLabel:c];
    
    UILabel *d =[[UILabel alloc]init];
    [self floatWithLabel:d WithStr:D WhichLab:c];
    d.text =D;
    [self WithLabel:d];
    
    UILabel *e =[[UILabel alloc]init];
    [self floatWithLabel:e WithStr:E WhichLab:d];
    e.text =E;
    [self WithLabel:e];
    
    UILabel *f =[[UILabel alloc]init];
    [self floatWithLabel:f WithStr:F WhichLab:e];
    f.text =F;
    [self WithLabel:f];
    
    UILabel *g =[[UILabel alloc]init];
    [self floatWithLabel:g WithStr:G WhichLab:f];
    g.text =G;
    [self WithLabel:g];
    
    UILabel *h =[[UILabel alloc]init];
    [self floatWithLabel:h WithStr:H WhichLab:g];
    h.text =H;
    [self WithLabel:h];
    
    UILabel *i =[[UILabel alloc]init];
    [self floatWithLabel:i WithStr:I  WhichLab:h];
    i.text =I;
    [self WithLabel:i];
    
    UILabel *j =[[UILabel alloc]init];
    [self floatWithLabel:j WithStr:J WhichLab:i];
    j.text =J;
    [self WithLabel:j];
    
    UILabel *k =[[UILabel alloc]init];
    [self floatWithLabel:k WithStr:K WhichLab:j];
    k.text =K;
    [self WithLabel:k];
    
    UILabel *l =[[UILabel alloc]init];
    [self floatWithLabel:l WithStr:L WhichLab:k];
    l.text =L;
    [self WithLabel:l];
    
    UILabel *m = [[UILabel alloc]init];
    [self floatWithLabel:m WithStr:M WhichLab:l];
    m.text =M;
    [self WithLabel:m];
    
    UILabel *n = [[UILabel alloc]init];
    [self floatWithLabel:n WithStr:N WhichLab:m];
    n .text =N;
    [self WithLabel:n];
    
    UILabel *o = [[UILabel alloc]init];
    [self floatWithLabel:o WithStr:O WhichLab:n];
    o.text =O;
    [self WithLabel:o];
    
    UILabel *p =[[UILabel alloc]init];
    [self floatWithLabel:p WithStr:P WhichLab:o];
    p.text =P;
    [self WithLabel:p];
    
    UILabel *q =[[UILabel alloc]init];
    [self floatWithLabel:q WithStr:Q WhichLab:p];
    q.text =Q;
    [self WithLabel:q];
    
    UILabel *r =[[UILabel alloc]init];
    [self floatWithLabel:r WithStr:R WhichLab:q];
    r .text =R;
    [self WithLabel:r];
    
    UILabel *s =[[UILabel alloc]init];
    [self floatWithLabel:s WithStr:S WhichLab:r];
    s.text =S;
    [self WithLabel:s];
    
    UILabel *t =[[UILabel alloc]init];
    [self floatWithLabel:t WithStr:T WhichLab:s ];
    t.text =T;
    [self WithLabel:t];
    
    UILabel *u =[[UILabel alloc]init];
    [self floatWithLabel:u WithStr:U WhichLab:t ];
    u .text =U;
    [self WithLabel:u];
    
    UILabel *v =[[UILabel alloc]init];
    [self floatWithLabel:v WithStr:V WhichLab:u ];
    v.text =V;
    [self WithLabel:v];
    
    UILabel *w =[[UILabel alloc]init];
    [self floatWithLabel:w WithStr:W WhichLab:v ];
    w.text =W;
    [self WithLabel:w];
    
    UILabel *x =[[UILabel alloc]init];
    [self floatWithLabel:x WithStr:X WhichLab:w ];
    x.text =X;
    [self WithLabel:x];
    
    UILabel *y =[[UILabel alloc]init];
    [self floatWithLabel:y WithStr:Y WhichLab:x ];
    y .text =Y;
    [self WithLabel:y];
    
    UILabel *z =[[UILabel alloc]init];
    [self floatWithLabel:z WithStr:Z WhichLab:y ];
    z.text =Z;
    [self WithLabel:z];
    
    UILabel *lab1 =[[UILabel alloc]init];
    [self floatWithLabel:lab1 WithStr:str1 WhichLab:z ];
    lab1.text =str1;
    [self WithLabel:lab1];
    
    
}

- (CGFloat )rectWithStr:(NSString *)str{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:TextMainCOLOR} context:nil];
    return rect.size.height;
}

- (void)WithLabel:(UILabel *)label{
    label.textColor = kTextMainCOLOR;
    label.numberOfLines = 0 ;
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    [scrollview addSubview:label];
//      CGSize size = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]];
    CGRect tmpRect = [label.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    _lbl_height=_lbl_height+tmpRect.size.height;
    scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _lbl_height);

}

- (void )floatWithLabel:(UILabel *)label WithStr:(NSString *)Str WhichLab:(UILabel *)WL{
    
    label.frame = CGRectMake(10,10+WL.frame.origin.y+WL.frame.size.height, SCREEN_WIDTH-20,[self rectWithStr:Str]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
