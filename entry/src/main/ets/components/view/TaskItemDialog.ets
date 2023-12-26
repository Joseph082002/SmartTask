import promptAction from '@ohos.promptAction'
import PreferenceData from '../../common/bean/PreferenceData'
import TaskCategoryData from '../../common/bean/TaskCategoryData'
import { TaskListItemData } from '../../common/bean/TaskListItemData'
import CommonConstants from '../../common/constants/CommonConsts'
import Logger from '../../common/utils/Logger'

@CustomDialog
export struct TaskItemDialog {
  @Link taskItem: TaskListItemData
  @Link dialogIsAddNew: boolean
  @Link prefData: PreferenceData
  @Link categoryList: TaskCategoryData[]
  controller: CustomDialogController
  confirm: (dialogIsAddNew: boolean, newTask: TaskListItemData) => void

  private taskName: string
  private taskSubject: number
  private startDate: Date
  private taskDate: Date
  private taskDetailText: string
  private taskDdlDetail: string = '0.3-0.5-0.9'
  private taskCategoryID: number

  @State startTask: string[] = ['', '']
  @State endTask: string[] = ['', '']
  @State showedTaskDDL: string = '正常'
  @State showedTaskCategory: string = '默认清单'
  @State taskCategoryColor: string = '#000000'
  @State handlePopup: boolean = false

  @Builder DatePickerMenu($$:{date: Date, str: string[]}) {
    Menu() {
      MenuItem() {
        DatePicker({
          start: new Date('1970-01-01'),
          selected: $$.date,
          end: new Date('2100-01-01')
        })
          .onChange((value: DatePickerResult) => {
            Logger.debug(`TaskItemDialog date = ${JSON.stringify(value)}`)
            $$.date.setFullYear(value.year, value.month, value.day)
            Logger.debug(`TaskItemDialog res = ${JSON.stringify($$.date)}, str = ${$$.date.toLocaleString()}`)
            $$.str[0] = getDateString($$.date.getTime())
          })
          .backgroundColor(0xffffff)
      }
    }
  }
  @Builder TimePickerMenu($$:{date: Date, str: string[]}) {
    Menu() {
      MenuItem() {
        TimePicker({
          // start: new Date('1970-01-01'),
          selected: $$.date,
          // end: new Date('2100-01-01')
        })
          .onChange((value: TimePickerResult) => {
            Logger.debug(`TaskItemDialog date = ${JSON.stringify(value)}`)
            $$.date.setHours(value.hour, value.minute)
            Logger.debug(`TaskItemDialog res = ${JSON.stringify($$.date)}, str = ${$$.date.toLocaleString()}`)
            $$.str[1] = getTimeString($$.date.getTime())
          })
          .backgroundColor(0xffffff)
          .width('80%')
      }
    }
  }
  @Builder DDLDetailPickerMenu() {
    Menu() {
      ForEach(CommonConstants.DDL_DETAIL_PRESET, (preset) => {
        MenuItem({content: preset.hint})
          .onClick(() => {
            this.taskDdlDetail = preset.detail
            this.showedTaskDDL = preset.hint
          })
      })
    }
  }
  @Builder CategoryPickerMenu() {
    Menu() {
      ForEach(this.categoryList, (cate) => {
        MenuItem({content: cate.name}) {
          Button({type: ButtonType.Circle}) {
            Text(' ').fontSize(50)
          }
          .backgroundColor(cate.color)
        }
          .onClick(() => {
            this.taskCategoryID = cate.id
            this.taskCategoryColor = cate.color
            this.showedTaskCategory = cate.name
          })
      })
    }
  }

  aboutToAppear() {
    this.taskName = this.taskItem.task_name
    this.taskSubject = this.taskItem.subject
    this.taskDetailText = this.taskItem.detail
    this.taskDdlDetail = this.taskItem.ddl_detail
    this.taskDate = new Date()
    this.startDate = new Date()
    this.taskDate.setSeconds(0)
    this.startDate.setSeconds(0)
    Logger.debug('TaskItemDialog new date = ' + this.taskDate.toLocaleString())
    if (this.taskItem.start_date_stamp) this.startDate.setTime(this.taskItem.start_date_stamp)
    if (this.taskItem.due_date_stamp) this.taskDate.setTime(this.taskItem.due_date_stamp)
    this.startTask[0] = getDateString(this.startDate.getTime())
    this.startTask[1] = getTimeString(this.startDate.getTime())
    this.endTask[0] = getDateString(this.taskDate.getTime())
    this.endTask[1] = getTimeString(this.taskDate.getTime())
    this.showedTaskDDL = getDDLPresetFromDetail(this.taskDdlDetail)
    this.taskCategoryID = this.taskItem.category
    for (let i = 0; i < this.categoryList.length; ++i) {
      if (this.categoryList[i].id == this.taskCategoryID) {
        this.showedTaskCategory = this.categoryList[i].name
        this.taskCategoryColor = this.categoryList[i].color
        break;
      }
      if (i == this.categoryList.length - 1) {
        this.taskCategoryID = this.categoryList[0].id
        this.showedTaskCategory = this.categoryList[0].name
        this.taskCategoryColor = this.categoryList[0].color
      }
    }
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
            Text((this.dialogIsAddNew ? '添加' : '修改') + '事项')
              .fontSize(20)
              .alignSelf(ItemAlign.Start)
            Button() {
              Text(this.showedTaskCategory)
            }.backgroundColor('#f1f2f3')
            .bindMenu(this.CategoryPickerMenu)
            .padding({left: 12, right: 12, top: 8, bottom: 8})
          }
          .margin({ left: 24, bottom: 20, right: 24 })
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          TextInput({
            placeholder: '事项名称',
            text: this.taskName
          })
            .onChange((value: string) => {
              this.taskName = value
            })
            .backgroundColor(0xf1f2f3)
            .margin({ bottom: 10 })
            .height(50)
          TextArea({ placeholder: '详细信息', text: this.taskDetailText })
            .onChange((value: string) => {
              this.taskDetailText = value
            })
            .height(50 * 3)
          .margin({ bottom: 10 })
          Row(){
            Button('任务紧急程度：' + this.showedTaskDDL)
              .bindMenu(this.DDLDetailPickerMenu)
              .width('60%')
              .margin({ right: 15 })
              .backgroundColor(0xf1f2f3)
              .fontColor(0x000000)
            Button({type: ButtonType.Circle}) {
              Image($r('app.media.ic_public_help_filled'))
                .height(25)
                .width(25)
            }
              .onClick(() => {this.handlePopup = !this.handlePopup})
              .height(25)
              .width(25)
              .backgroundColor(0xffffff)
              .bindPopup(this.handlePopup, {
                message: '任务紧急程度会决定指示颜色变化的快慢，任务紧急程度越高，指示颜色越早变红。',
                placementOnTop: true,
                primaryButton: {
                  value: '明白了',
                  action: () => {this.handlePopup = false}
                }
              })
          }
        }.padding({ left: 16, right: 16})
        .margin({ bottom: 16})
        Row() {
          Button('布置日期：' + this.startTask[0])
            .bindMenu(this.DatePickerMenu({date: this.startDate, str: this.startTask}))
            .backgroundColor(0xf1f2f3)
            .fontColor(0x000000)
            .margin({right: 10})

          Button(this.startTask[1])
            .bindMenu(this.TimePickerMenu({date: this.startDate, str: this.startTask}))
            .backgroundColor(0xf1f2f3)
            .fontColor(0x000000)
        }.margin({bottom: 8})
        Row() {
          Button('截止日期：' + this.endTask[0])
            .bindMenu(this.DatePickerMenu({date: this.taskDate, str: this.endTask}))
            .backgroundColor(0xf1f2f3)
            .fontColor(0x000000)
            .margin({right: 10})

          Button(this.endTask[1])
            .bindMenu(this.TimePickerMenu({date: this.taskDate, str: this.endTask}))
            .backgroundColor(0xf1f2f3)
            .fontColor(0x000000)
        }
      }.margin({bottom: 16})
          // .margin({ bottom: 10 })
      Row() {
        Button('取消')
          .margin({ right: 10 })
          .onClick(() => {
            this.controller.close()
          })
        Button('保存')
          .onClick(() => {
            if (this.taskName == '') {
              promptAction.showToast({message: '任务名称不能为空'})
              return
            }
            if (this.taskDate.getTime() < this.startDate.getTime()) {
              promptAction.showToast({message: '结束日期不能在开始日期之前'})
            }
            this.taskItem.subject = this.taskSubject
            this.taskItem.task_name = this.taskName
            this.taskItem.detail = this.taskDetailText
            this.taskItem.due_date_stamp = this.taskDate.getTime()
            this.taskItem.start_date_stamp = this.startDate.getTime()
            this.taskItem.ddl_detail = this.taskDdlDetail
            this.taskItem.category = this.taskCategoryID
            Logger.debug(`TaskItemDialog ddlDetail = ${this.taskItem.ddl_detail}`)
            // Logger.debug(`TaskItemDialog due_date(stamp): ${this.taskItem.due_date_stamp}, date: ${this.taskDate.toDateString()}`)
            this.confirm(this.dialogIsAddNew, this.taskItem)
            this.controller.close()
          })
      }.margin({ bottom: 20 })
    }.backgroundColor(0xffffff)
    .width('100%')
    // .height('60%')
    .borderRadius(24)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

function getTimeString(date_stamp: number): string {
  let date: Date = new Date()
  date.setTime(date_stamp)
  Logger.debug(`TaskList: datestamp = ${date_stamp}, time = ${date.toLocaleTimeString()}`)
  return date.toLocaleTimeString()
}

function getDateString(date_stamp: number): string {
  let date: Date = new Date()
  date.setTime(date_stamp)
  Logger.debug(`TaskList: datestamp = ${date_stamp}, date = ${date.toLocaleDateString()}`)
  let ds: string[] = date.toLocaleDateString().split('/')
  let res: string = `${ds[2]}/${ds[0]}/${ds[1]}`
  return res
}

function getDDLPresetFromDetail(detail: string): string {
  for (let i = 0; i < 5; ++i) {
    Logger.debug('getDDL: ' + CommonConstants.DDL_DETAIL_PRESET[i].detail)
    if (CommonConstants.DDL_DETAIL_PRESET[i].detail == detail) return CommonConstants.DDL_DETAIL_PRESET[i].hint
  } return ''
}