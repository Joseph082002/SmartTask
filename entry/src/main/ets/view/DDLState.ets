import TaskTable from '../../common/database/TaskTable'
import { TaskListItemData } from '../../common/bean/TaskListItemData'
import Logger from '../../common/utils/Logger'
import { TaskItemDialog_ViewOnly } from '../view/TaskItemDialog_ViewOnly'
import promptAction from '@ohos.promptAction';
import CommonConstants from '../../common/constants/CommonConsts'
import TaskCategoryData from '../../common/bean/TaskCategoryData'

@Component

export default struct DDLState {
  @Link tasks: Array<TaskListItemData>
  @Link categoryList: TaskCategoryData[]
  @State isEditing: boolean = false
  @State dialogIsAddNew: boolean = true
  @State taskItem: TaskListItemData = new TaskListItemData()
  private taskTable: TaskTable = new TaskTable(() => {});
  private dialogSelectedIndex: number = -1

  dialogController_view: CustomDialogController = new CustomDialogController({
    builder: TaskItemDialog_ViewOnly({
      taskItem: $taskItem,
      categoryList: $categoryList
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })

  @Builder TaskList_ListItem(item: TaskListItemData) {
    Column() {
      Row() {
        Row() {
          if (!this.isEditing) {
            Checkbox()
              .select(item.is_completed)
              .onChange((value: boolean) => {
                animateTo({duration: 300, curve: Curve.EaseInOut}, () => {
                  item.is_completed = value
                  this.updateExistingTask(item)
                })
              })
              .margin({ right: 10 })
          }
          Text(item.task_name)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .width('60%')
        }
        Row() {
          Column() {
            Text(getDateString(item.due_date_stamp))
              .fontSize(16)
            Text(getTimeString(item.due_date_stamp))
              .fontSize(13)
          }.alignItems(HorizontalAlign.End)
          .margin({ right: 10 })

          if (!item.is_completed) Button({ type: ButtonType.Circle, }) {
            Text(' ')
          }
          .backgroundColor(CommonConstants.DDL_COLOR[item.getDDLState()])
          .height(12)
          .width(12)
        }
        // Blank()
        //   .layoutWeight(1)
        // Text(item.subject.toString())
      }.justifyContent(FlexAlign.SpaceBetween)
      .height(56)
      .width('100%')
      .padding({ left: 12, right: 12 })

      Progress({value: 100 - item.getDDLPer()})
        .margin({bottom: 10})
        .color(CommonConstants.DDL_COLOR[item.getDDLState()])
    }
  }

  @Builder TaskList_DDLState(text: string, state: string) {
    Text(text)
      .fontSize(20)
      .width('100%')
      .margin({ bottom: 10, top: 20})
      .textAlign(TextAlign.Start)
      .padding({ left: 12, right: 12 })

    List() {
      // 未办事项
      ForEach(this.tasks, (item: TaskListItemData) => {
        if (!item.is_completed && item.getDDLState() == state) ListItem() {
          this.TaskList_ListItem(item)
        }.width('100%')
        .backgroundColor(0xffffff)
        .onClick(() => {
          this.taskItem = item
          this.dialogController_view.open()
        })
      })
    }
    .width('100%')
    .borderRadius(20)
    .divider({ strokeWidth: 1 })
    .margin({ bottom: 20 })
  }

  updateExistingTask(taskData: TaskListItemData) {
    this.taskTable.updateData(taskData, () => {})
    let new_task = this.tasks
    this.tasks = []
    new_task[this.dialogSelectedIndex] = taskData
    // Logger.debug(`TaskList taskData = ${JSON.stringify(taskData)}`)
    this.tasks = new_task // 触发 UI 刷新
    this.dialogSelectedIndex = -1
  }
  querySearchTask(searchVal: string, callback?: Function) {
    // 暂时只写了task_name
    this.taskTable.queryTaskName(`%${searchVal}%`, (searchRes) => {
      this.tasks = []
      searchRes.forEach(item => {this.tasks.push(item)})
      for (let i = 0; i < this.tasks.length; ++i) {
        this.tasks[i].setAll(this.categoryList)
      }
      if(callback !== undefined) callback()
    }, (searchVal == ''))
  }
  // 数据库操作封装 结束

  // UI
  build() {
    Column() {
      Stack({alignContent: Alignment.Bottom}) {
        Navigation() { // UI 标题栏
          // UI 搜索

          if (!this.isEditing) Search()
            // .onClick(() => { this.isOnSearch = true})
            .onSubmit((value: string) => {
              this.querySearchTask(value)
            })
              // .padding({ left: 12, right: 12 })
            .width('90%')

          Column() {
            // UI 待办事项界面
            Scroll() {
              Column() {
                // UI 待办事项列表
                this.TaskList_DDLState('非常紧急', 'critical')
                this.TaskList_DDLState('紧急', 'hard')
                this.TaskList_DDLState('还有时间', 'medium')
                this.TaskList_DDLState('该开始了', 'easy')
              }
              .padding({ left: 12, right: 12, bottom: 10, top: 10 })
              .margin({bottom: 40})
              // .height('70%')
              .justifyContent(FlexAlign.Start)
            }.edgeEffect(EdgeEffect.Spring)
            .scrollBar(BarState.Off)
          }
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .height('100%')
        .width('100%')
        .titleMode(NavigationTitleMode.Mini)
        .hideBackButton(true)
        .mode(NavigationMode.Stack)
        .title('截止时间')

        // UI <临时> 提交入口（只剩刷新按钮了）
        // if (!this.isEditing) Column() {
        //   Row() {
        //     Button('刷新')
        //       .onClick(() => {
        //         promptAction.showToast({message: '刷新中'})
        //         this.querySearchTask('', () => {
        //           promptAction.showToast({message: '刷新成功'})
        //         })
        //       })
        //   }.justifyContent(FlexAlign.SpaceAround)
        //   // .margin({ top: 30 })
        // }.padding({ left: 12, right: 12, bottom: 30 })
      }.height('100%')
    }.width('100%')
    .height('100%')
  }
}

function getDateString(date_stamp: number): string {
  let date: Date = new Date()
  date.setTime(date_stamp)
  Logger.debug(`TaskList: datestamp = ${date_stamp}, date = ${date.toLocaleDateString()}`)
  let ds: string[] = date.toLocaleDateString().split('/')
  let res: string = `${ds[2]}/${ds[0]}/${ds[1]}`
  return res
}

function getTimeString(date_stamp: number): string {
  let date: Date = new Date()
  date.setTime(date_stamp)
  Logger.debug(`TaskList: datestamp = ${date_stamp}, date = ${date.toLocaleTimeString()}`)
  return date.toLocaleTimeString()
}