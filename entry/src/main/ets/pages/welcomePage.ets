import device from '@system.device';
import window from '@ohos.window';
import router from '@ohos.router';

PersistentStorage.PersistProp('IsFirstIn', 1)
PersistentStorage.PersistProp('IsAgreed', 0)

@Entry
@Component
struct guide {
  @State statusBarHeight: number = 0
  @State screenDensity: number = 2
  @StorageLink('IsAgreed') IsAgreed: number = 0

  aboutToAppear() {
    // window.getTopWindow((err, data) => {
    //      var windowClass = data;
    //      var type = window.AvoidAreaType.TYPE_SYSTEM;
    //      windowClass.getAvoidArea(type, (err, data) => {
    //        if (err) {
    //          console.error('Failed to obtain the area. Cause:' + JSON.stringify(err));
    //          return;
    //        }
    //        this.statusBarHeight = data.topRect.height;
    //        console.info("statusBarHeight====>>>> %{private}d", this.statusBarHeight);
    //      });
    //    });
    //    var that = this;
    //    device.getInfo({
    //      success: function (data) {
    //        console.info("Device information obtained successfully. Device screenDensity: %{private}d", data.screenDensity);
    //        that.screenDensity = data.screenDensity;
    //      },
    //      fail: function (code) {
    //        console.info("Failed to obtain device information. Error code: %{private}d", code);
    //      },
    // });
  }

  private endGuide() {
    AppStorage.Set('IsFirstIn', 0)
    router.replace({
      url: 'pages/LoginPage',
    })
  }

  @Builder stepPage($$:{img: Resource, info: Resource | string, icon: boolean}) {
    Column() {
      Column() {
        Button('跳过')
          .height(36)
          .margin({ top: 12, right: 12 })
          .fontColor($r('app.color.text_level2'))
          .backgroundColor('#00000000')
          .onClick(() => {
            this.endGuide()
          })
      }
      .alignItems(HorizontalAlign.End)
      .height(48)
      .width('100%')

      Column() {
        if ($$.icon) {
          Image($$.img)
            .width(120)
            .height(120)
            .borderRadius(30)
        } else {
          Image($$.img)
            .height('100%')
            .width('100%')
        }
      }
      .justifyContent(FlexAlign.Center)
      .margin({ top: 72, bottom: 8 })
      .height('40%')
      .width('70%')

      Column() {
        Text($$.info)
          .fontColor($r('app.color.text_level2'))
          .fontSize(16)
          .margin({ top: 6 })
          .textAlign(TextAlign.Center)
      }
      .margin({ top: 24, bottom: 8 })
      .width('80%')
      .layoutWeight(1)
    }
    .height('100%')
    .width('100%')
  }

  build() {
    Stepper() {

      StepperItem() {
        Column() {
          Column() {
            Image($r('app.media.o1'))
              .width(120)
              .height(120)
              .borderRadius(30)
          }
          .justifyContent(FlexAlign.Center)
          .margin({ top: 72, bottom: 8 })
          .height('40%')
          .width('70%')

          Column() {
            Text('欢迎使用Smart Task')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_level1'))
            Text('让我们开始吧！')
              .fontColor($r('app.color.text_level2'))
              .fontSize(16)
              .margin({ top: 6 })
              .textAlign(TextAlign.Center)
          }
          .margin({ top: 24, bottom: 8 })
          .width('80%')
          .layoutWeight(1)

          Row() {
            Toggle({ type: ToggleType.Checkbox, isOn: this.IsAgreed != 0 })
              .size({ width: 16, height: 16 })
              .selectedColor($r('app.color.accent'))
              .onChange((isOn: boolean) => {
                this.IsAgreed = isOn ? 1 : 0
                console.info('Component status:' + this.IsAgreed)
              })
            Row() {
              Text('我已阅读并同意')
                .fontColor($r('app.color.text_level2'))
                .fontSize(16)
              Text('用户协议和隐私声明')
                .fontColor($r('app.color.accent'))
                .fontSize(16)
                .onClick(() => {
                  router.push({
                    url: 'pages/illustrate'
                  })
                })
            }
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
        }
        .height('100%')
        .width('100%')
      }
      .status(this.IsAgreed ? ItemState.Normal : ItemState.Disabled)


      StepperItem() {
        Column() {
          Swiper() {
            this.stepPage({ img: $r('app.media.hp1'), info: '点击右下角加号新建第一个待办', icon: false })
            this.stepPage({ img: $r('app.media.hp2'), info: '在这里可以填写待办信息', icon: false })
            this.stepPage({ img: $r('app.media.hp3'), info: '长按待办标记为重要', icon: false })
            this.stepPage({ img: $r('app.media.hp4'), info: '截止时间页面\n让您的待办信息一目了然', icon: false })
            this.stepPage({ img: $r('app.media.hp5'), info: '通过待办清单进行分类管理', icon: false })
            this.stepPage({ img: $r('app.media.hp6'), info: '通过编辑清单进行删除管理', icon: false })
          }
          .height('100%')
          .width('100%')
          .cachedCount(2)
          .index(0)
          .loop(false)
          .indicatorStyle({ bottom: 24 })
        }
        .width('100%')
      }
      .height('100%')
      .backgroundColor('#f1f2f3')



      StepperItem() {
        this.stepPage({img: $r('app.media.o1'), info: '欢迎使用SmartTask！\nf21010140 周正', icon: true})
      }
    }
    .backgroundColor($r('app.color.background'))
    .padding({ top: this.statusBarHeight / this.screenDensity })
    .onFinish(() => {
      // 此处可处理点击最后一页的Finish时的逻辑，例如路由跳转等
      console.info('onFinish');
      this.endGuide()
    })
    .onSkip(() => {
      // 此处可处理点击跳过时的逻辑，例如动态修改Stepper的index值使其跳转到某一步骤页等
      console.info('onSkip');
    })
  }
}