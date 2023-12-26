import router from '@ohos.router'
class oobeRes {
  id: string = ''
  imgPath: string = ''

  constructor(id, path) {
    this.id = id
    this.imgPath = path
  }
}
class dataSource implements IDataSource {
  resource: oobeRes[] = []
  private listener: DataChangeListener

  constructor(list: oobeRes[]) {
    this.resource = list
  }
  unregisterDataChangeListener(listener: DataChangeListener): void {

  }
  registerDataChangeListener(listener: DataChangeListener): void {
    this.listener = listener
  }
  getData(index: number) {
    return this.resource[index]
  }
  totalCount(): number {
    return this.resource.length
  }
}

@Entry
@Component

struct OOBE {
  @State message: string = 'Hello World'

  private oobeResource: dataSource = new dataSource([
    {id: '欢迎使用SmartTask', imgPath: 'oobe/o1.png'},
    {id: '点击右下角加号新建第一个待办', imgPath: 'oobe/o2.png'},
    {id: '在这里可以填写待办信息', imgPath: 'oobe/o3.png'},
    {id: '长按待办标记为重要', imgPath: 'oobe/o6.png'},
    {id: '截止时间页面\n让您的待办信息一目了然', imgPath: 'oobe/o4.png'},
    {id: '通过待办清单进行分类管理', imgPath: 'oobe/o5.png'},
    {id: '开始使用SmartTask', imgPath: 'oobe/o1.png'},
  ])
  @Builder LongText(value: string) {
    Text(value)
      .fontSize(24)
      .margin({bottom: 20})
      .textAlign(TextAlign.Center)
  }
  @Builder oobePage(oobe: oobeRes, index: number) {
    Column() {
      Column() {
        this.LongText(oobe.id)
        Image($rawfile(oobe.imgPath))
          .height((index == 0 || index == 6 ? '30%' : '70%'))
          .borderRadius((index == 0 || index == 6 ? 16 : 0))
      }
      if (index == 6) Button('开始使用')
        .onClick(() => {
          router.back()
        })
        .width('70%')
    }.height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  build() {
    Row() {
      Column() {
        Swiper() {
          LazyForEach(this.oobeResource, (oobe, id) => {
            this.oobePage(oobe, id)
          })
        }.height('100%')
        .width('100%')
        .cachedCount(2)
        .index(0)
        .loop(false)
        .indicatorStyle({bottom: 24})
      }
      .width('100%')
    }
    .height('100%')
    .backgroundColor('#f1f2f3')
  }
}