import TaskCategoryData from '../../common/bean/TaskCategoryData'
import {TaskListItemData} from '../../common/bean/TaskListItemData'
import CommonConstants from '../../common/constants/CommonConsts'
import Logger from '../../common/utils/Logger'

@CustomDialog
export struct TaskItemDialog_ViewOnly {
  @Link taskItem: TaskListItemData
  @Link categoryList: TaskCategoryData[]
  controller: CustomDialogController

  private taskName: string
  private startDate: Date
  private taskDate: Date
  private taskDetailText: string
  private showedTaskCategory: string
  private taskCategoryID: number

  @State showedTaskDate: string = ''
  @State showedStartDate: string = ''

  aboutToAppear() {
    this.taskName = this.taskItem.task_name
    this.taskDetailText = this.taskItem.detail
    this.taskDate = new Date()
    this.startDate = new Date()
    Logger.debug('TaskItemDialog new date = ' + this.taskDate.toLocaleString())
    this.taskDate.setTime(this.taskItem.due_date_stamp)
    this.startDate.setTime(this.taskItem.start_date_stamp)
    this.showedTaskDate = getTimeString(this.taskDate.getTime())
    this.showedStartDate = getTimeString(this.startDate.getTime())
    this.taskCategoryID = this.taskItem.category
    this.showedTaskCategory = this.taskItem.categoryName
  }

  build() {
    Column() {
      Image($r('app.media.half'))
        .width(64)
        .height(24)
        .onClick(() => {
          this.controller?.close();
        })
      .margin({top: 5})
      Column() {
        Column() {
          Row() {
            Text('任务名称')
              .fontSize(18)
              .alignSelf(ItemAlign.Start)
              .margin({ top: 12, bottom: 12 })

            Button() {
              Text(this.showedTaskCategory)
            }.backgroundColor('#f1f2f3')
            .padding({left: 12, right: 12, top: 8, bottom: 8})
          }.width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          Text(this.taskName)
            .TextStyle(50, TextAlign.Start)
            .width('90%')
          Text('详细内容')
            .fontSize(18)
            .alignSelf(ItemAlign.Start)
            .margin({top: 12, bottom: 12})
          Text(this.taskDetailText)
            .height(50 * 3)
            .width('90%')
            .borderRadius(24)
            .backgroundColor(0xf1f2f3)
            .padding({ left: 12, right: 12, top: 12, bottom: 12 })
            .align(Alignment.TopStart)
        }.padding({ left: 16, right: 16})
        .margin({ bottom: 20})
        Text(`布置日期：${this.showedStartDate}`)
          .TextStyle(40, TextAlign.Center)
          .margin({bottom: 8})
        Text(`截止日期：${this.showedTaskDate}`)
          .TextStyle(40, TextAlign.Center)

        Progress({value: 100 - this.taskItem.getDDLPer()})
          .margin({bottom: 10, top: 10})
          .color(CommonConstants.DDL_COLOR[this.taskItem.getDDLState()])
      }
        Row() {
          Button('确定')
            .onClick(() => {
              this.controller.close()
            })
        }.margin({ bottom: 20 })
    }.backgroundColor(0xffffff)
    .width('100%')
    .borderRadius(24)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

@Extend(Text) function TextStyle(height: number, align: TextAlign) {
  .width('80%')
  .height(height)
  .padding({ left: 12, right: 12 })
  .borderRadius(24)
  .backgroundColor(0xf1f2f3)
  .fontColor(0x000000)
  .textAlign(align)
}

function getTimeString(date_stamp: number): string {
  let date: Date = new Date()
  date.setTime(date_stamp)
  Logger.debug(`TaskList: datestamp = ${date_stamp}, date = ${date.toLocaleDateString()}`)
  let ds: string[] = date.toLocaleDateString().split('/')
  let res: string = `${ds[2]}/${ds[0]}/${ds[1]} `
  return res + date.toLocaleTimeString()
}
