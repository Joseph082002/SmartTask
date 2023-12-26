import router from '@ohos.router'
import prompt from '@ohos.prompt'
@Entry
@Component
struct Loginpage {
  @State message: string = 'Hello World'
  @State user: string = ''
  @State password: string = ''

  login() {
    if (this.user == '' || this.password == '') {
      prompt.showToast({
        message: '用户名和密码不能为空!',
        duration: 2000
      });
    }else{
      if (this.user == 'a' && this.password == '1') {
        prompt.showToast({
          message: '用户名密码输入正确!',
          duration: 2000
        });
        router.replaceUrl({ url: 'pages/Index' });
      }else{
        prompt.showToast({
          message: '请输入正确的用户名和密码!',
          duration: 2000
        });
      }
    }
  }

  build() {
    Column() {
      Column() {
        //   头像
        Image($r("app.media.avatar"))
          .width(100)
          .height(100)
          .margin(100)
          .clip(new Circle({ width: 100, height: 100 }))

        //   用户名输入框
        TextInput({
          placeholder: "请输入用户名",

        })
          .width("70%")
          .backgroundColor("white")
          .onChange((value: string) => {
            this.user = value;
          })
        //   密码输入框
        TextInput({ placeholder: "请输入密码" })
          .width("70%")
          .margin({ top: 20 })
          .type(InputType.Password)
          .backgroundColor("white")
          .onChange((value: string) => {
            this.password = value;
          })

        Row(){
          //    忘记密码
          Button("验证码登录")
            .fontSize(15)
            .margin({left:-5})
            .width("50%")
            .backgroundColor("")
            .onClick(()=>
            router.pushUrl({url:"pages/registerPage"})
            )
          //    忘记密码
          Button("忘记密码？")
            .fontSize(15)
            .margin({left:20})
            .width("50%")
            .backgroundColor("")
            .onClick(()=>
            router.pushUrl({url:"pages/registerPage"})
            )
        }

        .width("360vp")
        .height("68.65vp")
        .offset({ x: "3.93vp", y: "-16.75vp" })

        //   登陆按钮
        Button("登录")
          .fontSize(18)
          .backgroundColor('#0F40F5')
          .type(ButtonType.Capsule)
          .width("50%")
          .margin(10)
          .onClick(() =>{
            this.login()
          }
          )
        Button("注册")
          .fontSize(18)
          .backgroundColor('#0F40F5')
          .type(ButtonType.Capsule)
          .width("50%")
          .margin(10)
          .onClick(() =>{
            this.login()
          }
          )
        Row() {
          Image($r('app.media.huawei'))
            .width("33%")
            .height("100%")
            .objectFit(ImageFit.Contain)
          Image($r("app.media.qq"))
            .width("33%")
            .height("100%")
            .objectFit(ImageFit.Contain)
          Image($r('app.media.weixin'))
            .width("33%")
            .height("100%")
            .objectFit(ImageFit.Contain)
        }
        .width("360vp")
        .height("50vp")
        .offset({ x: "0vp", y: "40vp" })
      }
      .width("100%")
      .height("100%")
      .backgroundImage($r("app.media.wel1"))
      .opacity(0.7)
      .backgroundImageSize(ImageSize.Cover)
      .justifyContent(FlexAlign.Center)
    }
  }
}
