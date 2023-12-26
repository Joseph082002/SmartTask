import router from '@ohos.router'
import prompt from '@ohos.prompt'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct registerPage {
  @State password: string = ''
  @State username: string = ''

  build(){

    Column(){
      Text("用户注册")
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .fontColor("#ffffff")
        .margin({bottom:40,top:70})

      //输入用户名
      Row(){
        Text("用户名")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor("#aad08f")
          .margin({left:10})
      }
      .width("100%")

      Row(){
        Image($r("app.media.yonghu"))
          .width(30)
        TextInput({placeholder:"请输入用户名"})
          .width(250)
          .onChange((val: string)=>{
            this.username = val})
      }
      .margin({bottom:15,top:10,left:10})
      .width("100%")

      //输入电子邮箱
      Row() {
        Text("电子邮箱")
          .fontSize(18)
          .fontColor("#aad08f")
          .fontWeight(FontWeight.Bold)
          .margin({left:10})
      }
      .width("100%")

      Row() {
        Image($r("app.media.youxiang"))
          .width(30)
        TextInput({placeholder: "请输入电子邮箱" })
          .width(250)
          .onChange((val: string)=>{
            this.username = val})
      }
      .width("100%")
      .margin({bottom:15,top:10,left:10})

      //输入电话号码
      Row() {
        Text("电话号码")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({left:10})
          .fontColor("#aad08f")
      }
      .width("100%")

      Row() {
        Image($r("app.media.dianhua"))
          .width(30)
        TextInput({placeholder: "请输入电话号码" })
          .width(250)
          .onChange((val: string)=>{
            this.username = val})
      }
      .width("100%")
      .margin({bottom:15,top:10,left:10})

      //输入密码
      Row() {
        Text("密码")
          .fontSize(18)
          .fontColor("#aad08f")
          .fontWeight(FontWeight.Bold)
          .margin({left:10})
      }
      .width("100%")

      Row() {
        Image($r("app.media.mima"))
          .width(30)
        TextInput({placeholder: "请输入密码"})
          .width(250)
          .onChange((val: string) => {
            this.password = val})
          .type(InputType.Password)
      }
      .width("100%")
      .margin({bottom:15,top:10,left:10})

      //确认密码
      Row() {
        Text("确认密码")
          .fontSize(18)
          .fontColor("#aad08f")
          .fontWeight(FontWeight.Bold)
          .margin({left:10})
      }
      .width("100%")

      Row() {
        Image($r("app.media.mima"))
          .width(30)
        TextInput({placeholder: "请输入密码"})
          .width(250)
          .onChange((val: string) => {
            this.password = val})
          .type(InputType.Password)
      }
      .width("100%")
      .margin({bottom:15,top:10,left:10})

      // 注册按钮
      Button("立即注册")
        .fontSize(25)
        .width("50%")
        .margin({top:40})
        .backgroundColor("#aad08f")

      // 返回按钮
      Button("返回")
        .fontSize(15)
        .margin({left:220})
        .width("50%")
        .backgroundColor("")
        .onClick(()=>
        router.pushUrl({url:"pages/LoginPage"})
        )

    }

    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .padding({left:20,right:20})
    .backgroundImage($r("app.media.background"))
    .backgroundImageSize({width:"100%",height:"100%"})
  }
}