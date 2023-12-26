import promptAction from '@ohos.promptAction'
import TaskCategoryData from '../../common/bean/TaskCategoryData'
@CustomDialog

export default struct NewCategoryDialog {
  private categoryData: TaskCategoryData = new TaskCategoryData()
  @State cateName: string = ''
  @State cateColor: string = ''
  controller: CustomDialogController
  confirm: (newCategory: TaskCategoryData) => void

  aboutToAppear() {
    this.cateName = ''
    this.cateColor = ''
  }

  build() {
    Column() {
      Text('添加新清单')
        .margin({bottom: 12})
        .fontSize(20)
      TextInput({placeholder: '清单名称'})
        .onChange((value) => {this.cateName = value})
        .margin({bottom: 12})
      // TextInput({placeholder: '清单颜色'})
      //   .onChange((value) => {this.cateColor = value})
      //   .margin({bottom: 12})

      Row() {
        Button('取消')
          .backgroundColor('#00ffffff')
          .fontColor('#254ff7')
          .onClick(() => {this.controller.close()})
        Divider()
          .strokeWidth(1)
          .vertical(true)
          .height(30)
        Button('确定')
          .fontColor('#254ff7')
          .backgroundColor('#00ffffff')
          .onClick(() => {
            if (this.cateName === '') {
              promptAction.showToast({message: '清单信息不能为空'})
              return;
            }
            this.categoryData = {
              color: this.cateColor,
              name: this.cateName,
              id: this.categoryData.id
            }
            this.confirm(this.categoryData)
            this.controller.close()
          })
      }.width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }.padding({left: 24, right: 24, top: 24, bottom: 24})
  }
}