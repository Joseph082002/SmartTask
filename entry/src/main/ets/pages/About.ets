@Entry
@Component
struct About {
  @State message: string = 'Hello World'

  @Builder LongText(value: string) {
    Text(value)
      .fontSize(16)
      .margin({bottom: 10})
  }

  pageTransition() {
    // 定义页面进入时的效果，从左侧滑入，时长为1200ms，无论页面栈发生push还是pop操作均可生效
    PageTransitionEnter({ type: RouteType.Push, duration: 500, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    // 定义页面退出时的效果，向左侧滑出，时长为1000ms，无论页面栈发生push还是pop操作均可生效
    // PageTransitionExit({ type: RouteType.Pop, duration: 1000, curve: Curve.Ease })
    //   .slide(SlideEffect.Right)
  }

  build() {
    Column(){
      Navigation() {
        Column() {
          Column() {
            Image($rawfile('sr_my_app_icon.png'))
              .height(80)
              .margin({bottom: 20})
              .borderRadius(16)
            this.LongText('Smart Task')
          }
          Column() {
            this.LongText('本作品为v1.0版本，后续功能敬请期待')
          }
        }.margin({top: 20})
        .justifyContent(FlexAlign.SpaceEvenly)
        .height('80%')
      }.titleMode(NavigationTitleMode.Mini)
      .title('关于')
      .mode(NavigationMode.Stack)

    }
    .height('100%')
    .width('100%')
  }
}