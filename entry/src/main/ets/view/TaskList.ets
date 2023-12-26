import TaskTable from '../common/database/TaskTable'
import {TaskListItemData} from '../common/bean/TaskListItemData'
import Logger from '../common/utils/Logger'
import { TaskItemDialog } from '../components/view/TaskItemDialog'
import { TaskItemDialog_ViewOnly } from '../components/view/TaskItemDialog_ViewOnly'
import promptAction from '@ohos.promptAction';
import CommonConstants from '../common/constants/CommonConsts'
import CommonUI from '../common/constants/CommonUIConstants'
import PreferenceData from '../common/bean/PreferenceData'
import TaskCategoryData from '../common/bean/TaskCategoryData'
import NewCategoryDialog from '../components/view/NewCategoryDialog'
import CategoryTable from '../common/database/CategoryTable'
import CategoryListDialog from '../components/view/CategoryListDialog'

@Component

export default struct TaskList {

  @Link taskList: Array<TaskListItemData>
  @Link taskTable: TaskTable
  @Link prefData: PreferenceData
  @Link categoryList: TaskCategoryData[]
  @Link categoryTable: CategoryTable
  @State isEditing: boolean = false
  @State dialogIsAddNew: boolean = true
  @State taskItem: TaskListItemData = new TaskListItemData()
  private dialogSelectedIndex: number = -1
  private deleteTarget: Array<TaskListItemData> = []

  // UI 编辑弹窗 Dialog
  dialogController: CustomDialogController = new CustomDialogController({
    builder: TaskItemDialog({
      dialogIsAddNew: $dialogIsAddNew,
      taskItem: $taskItem,
      confirm: (dialogIsAddNew: boolean, taskItem: TaskListItemData) => {
        if (dialogIsAddNew) {
          this.submitNewTask(taskItem)
        } else {
          this.updateExistingTask(taskItem)
        }
        dialogIsAddNew = true
      },
      prefData: $prefData,
      categoryList: $categoryList
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })
  dialogController_view: CustomDialogController = new CustomDialogController({
    builder: TaskItemDialog_ViewOnly({
      taskItem: $taskItem,
      categoryList: $categoryList
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })
  dialogCategoryList: CustomDialogController = new CustomDialogController({
    builder: CategoryListDialog({
      categoryList: $categoryList,
      categoryTable: $categoryTable,
      safeDeleteCheckID: (id) => {
        for (let i = 0; i < this.taskList.length; ++i) {
          if (this.taskList[i].category == id) return false;
        }
        return true
      },
      openNewCategoryDialog: () => {
        this.dialogNewCategory.open()
      },
      queryCategory: (id) => {
        this.queryCategory(id)
      }
    })
  })
  dialogNewCategory: CustomDialogController = new CustomDialogController({
    builder: NewCategoryDialog({
      confirm: (newCategory: TaskCategoryData) => {
        this.categoryTable.insertData(newCategory, (id) => {
          newCategory.id = id;
          this.categoryList.push(newCategory)
          Logger.debug(`Category Added. Now: ${JSON.stringify(this.categoryList)}`)
        })
      }
    }),
  })


  @Builder TaskList_ListItem(item: TaskListItemData, index: number) {
    Row() {
      if (!this.isEditing) {
        Checkbox()
          .select(item.is_completed)
          .onChange((value: boolean) => {
            animateTo({duration: 300, curve: Curve.EaseInOut}, () => {
              item.is_completed = value
              this.dialogSelectedIndex = index
              this.updateExistingTask(item)
            })
          })
          .margin({ right: 10 })
      }
      Text(item.task_name)
        .textOverflow({overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .width('40%')
      Blank()
        .layoutWeight(1)
      Row() {
        Text(getTimeString(item.due_date_stamp))
          .margin({right: 10})

        Button() {
          Text(item.categoryName)
            .fontSize(14)
        }.backgroundColor('#f1f2f3')
        .margin({right: 4})
        .padding({left: 6, right: 6, top: 4, bottom: 4})
        if (!item.is_completed)
          Button({type: ButtonType.Circle, }) {
            Text(' ')
          }
          .backgroundColor(CommonConstants.DDL_COLOR[item.getDDLState()])
          .height(12)
          .width(12)
      }.margin({right: 8})
      if (this.isEditing) {
        Toggle({ type: ToggleType.Checkbox, isOn: false })
          .onChange((isOn: Boolean) => {
            if (isOn) this.deleteTarget.push(item)
            else {
              let this_id_index = this.deleteTarget.indexOf(item)
              this.deleteTarget.splice(this_id_index, 1)
            }
          })
      }
    }.justifyContent(FlexAlign.SpaceBetween)
    .height(56)
    .width('100%')
    .padding({ left: 12, right: 12 })
    .backgroundColor(item.topped ? '#80B6C5D1' : '#ffffff')
    .gesture(
      LongPressGesture()
        .onAction(() => {
          Logger.debug(`Drag Start`)
          item.topped = !item.topped
          this.dialogSelectedIndex = index
          this.updateExistingTask(item)
        })
    )
  }

  sortItems() {
    this.taskList.sort((a, b) => {
      return Number(b.topped == true ? 2 : 0) - Number(a.topped == true ? 2 : 0)
    })
  }

  // 数据库操作封装
  submitNewTask(taskData: TaskListItemData) {
    this.taskTable.insertData(taskData, (id: number) => {
      taskData.id = id
      taskData.setAll(this.categoryList)
      this.taskList.push(taskData)
    })
  }
  updateExistingTask(taskData: TaskListItemData) {
    this.taskTable.updateData(taskData, () => {})
    taskData.setAll(this.categoryList)
    let new_task = this.taskList
    this.taskList = new Array<TaskListItemData>()
    new_task[this.dialogSelectedIndex] = taskData
    new_task.sort((a, b) => {
      return Number(b.topped == true ? 2 : 0) - Number(a.topped == true ? 2 : 0)
    })
    new_task.forEach((val) => {
      this.taskList.push((val))
    })
    this.dialogSelectedIndex = -1
  }
  deleteSelectedTasks() {
    if (this.deleteTarget.length == 0) return;
    for (let i = 0; i < this.deleteTarget.length; ++i) {
      let target = this.deleteTarget[i]
      this.taskTable.deleteData(target, (ret) => {
        if (ret) {
          let targetIndex = this.taskList.indexOf(target)
          this.taskList.splice(targetIndex, 1)
        }
      })
    }
    this.deleteTarget = []
  }
  querySearchTask(searchVal: string, callback?: Function) {
    // 暂时只写了task_name
    this.taskTable.queryTaskName(`%${searchVal}%`, (searchRes: TaskListItemData[]) => {
      this.taskList = new Array<TaskListItemData>()
      searchRes.sort((a, b) => {
        return Number(b.topped == true ? 2 : 0) - Number(a.topped == true ? 2 : 0)
      })
      searchRes.forEach(item => {this.taskList.push(item)})
      for (let i = 0; i < this.taskList.length; ++i) {
        this.taskList[i].setAll(this.categoryList)
      }
      Logger.debug(`TaskListItemData = ${JSON.stringify(this.taskList)}`)
      if (callback !== undefined) callback()
    }, (searchVal == ''))
  }
  queryCategory(searchVal: number, callback?: Function) {
    let tmp: TaskListItemData = new TaskListItemData()
    tmp.category = searchVal
    this.taskTable.basic_query('category', tmp, (searchRes: TaskListItemData[]) => {
      this.taskList = new Array<TaskListItemData>()
      searchRes.sort((a, b) => {
        return Number(b.topped == true ? 2 : 0) - Number(a.topped == true ? 2 : 0)
      })
      searchRes.forEach(item => {this.taskList.push(item)})
      for (let i = 0; i < this.taskList.length; ++i) {
        this.taskList[i].setAll(this.categoryList)
      }
      Logger.debug(`TaskListItemData = ${JSON.stringify(this.taskList)}`)
      if (callback !== undefined) callback()
    }, (searchVal == 0))
  }
  // 数据库操作封装 结束

  // UI
  build() {
    Stack({alignContent: Alignment.Bottom}) {
      Stack({ alignContent: (this.isEditing ? Alignment.Bottom : Alignment.BottomEnd) }) { // 主界面与悬浮按钮叠放
        Navigation() { // UI 标题栏
          // UI 搜索
          if (!this.isEditing)
            Search()
              .onSubmit((value: string) => {
                this.querySearchTask(value)
              })

          Column() {
            Column() {
              // UI 待办事项界面
              // issue: 不满一屏仍然滚动
              Scroll() {
                Column() {
                  // UI 待办事项列表
                  Text('未办事项')
                    .textTitle()

                  List() {
                    // 未办事项
                    ForEach(this.taskList, (item: TaskListItemData, index) => {
                      if (!item.is_completed) ListItem() {
                        this.TaskList_ListItem(item, index)
                      }.width('100%')
                      .backgroundColor(0xffffff)
                      .onClick(() => {
                        if (this.isEditing) {
                          this.taskItem = item
                          this.dialogIsAddNew = false
                          this.dialogSelectedIndex = this.taskList.indexOf(item)
                          this.dialogController.open()
                        } else {
                          this.taskItem = item
                          this.dialogController_view.open()
                        }
                      })
                    })
                  }
                  .width('100%')
                  .borderRadius(20)
                  .divider({ strokeWidth: 1 })
                  .margin({ bottom: 20 })


                  Text('已办事项')
                    .textTitle()

                  List() {
                    // 已办事项
                    ForEach(this.taskList, (item: TaskListItemData, index) => {
                      if (item.is_completed) ListItem() {
                        this.TaskList_ListItem(item, index)
                      }.width('100%')
                      .backgroundColor(0xffffff)
                      .onClick(() => {
                        if (this.isEditing) {
                          this.taskItem = item
                          this.dialogIsAddNew = false
                          this.dialogSelectedIndex = this.taskList.indexOf(item)
                          this.dialogController.open()
                        } else {
                          this.taskItem = item
                          this.dialogController_view.open()
                        }
                      })
                    })
                  }
                  .width('100%')
                  .borderRadius(24)
                  .divider({ strokeWidth: 1 })
                  .margin({bottom: 40})
                }
                // .justifyContent(FlexAlign.Start)
                .margin({top: 0})
              }
              .edgeEffect(EdgeEffect.Spring)
              .scrollBar(BarState.Off)
            }
          }.height('100%')
        }.titleMode(NavigationTitleMode.Full)
        .title('Smart Task')
        .menus([{
          value: "",
          icon: '../../../resources/base/media/ic_public_folder.svg',
          action: () => {
            this.dialogCategoryList.open()
          }
        },{
            value: "",
            icon: (this.isEditing ? '../../../resources/base/media/ic_public_edit_filled.svg' : '../../../resources/base/media/ic_public_edit.svg'),
            action: () => {
              animateTo({duration: 200, curve: Curve.EaseOut}, () => {
                this.deleteTarget = []
                this.isEditing = !this.isEditing
              })
            }
          }])
        .height('100%')
        .mode(NavigationMode.Stack)

        // UI 右下角的 Fab
        Button({ type: ButtonType.Circle }) {
          if (!this.isEditing) Image($r('app.media.ic_public_list_add_light'))
          else {
            Image($r('app.media.ic_public_delete'))
              .height(28)
              .width(28)
          }
        }
        .backgroundColor(!this.isEditing ? 0x0A59F7 : 0xE84026)
        .width(60)
        .height(60)
        .margin({ bottom: 12, right: (this.isEditing ? 0 : 12) })
        .onClick(() => {
          animateTo({duration: 200, curve: Curve.EaseOut}, () => {
            if (!this.isEditing) {
              this.dialogIsAddNew = true
              this.taskItem = new TaskListItemData()
              this.dialogController.open()
            } else {
              if (this.deleteTarget.length != 0) {
                this.deleteSelectedTasks()
                this.isEditing = false
              }
            }
          })
        })
      }.padding(CommonUI.DEFAULT_PADDING)
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
      //   .margin({ top: 30 })
      // }.padding({ left: 12, right: 12, bottom: 30 })
    }
  }
}

@Extend(Text) function textTitle() {
  .fontSize(20)
  .width('100%')
  .margin({ left: 12, bottom: 10, top: 20 })
  .textAlign(TextAlign.Start)
}

function getTimeString(date_stamp: number): string {
  let date: Date = new Date()
  date.setTime(date_stamp)
  Logger.debug(`TaskList: datestamp = ${date_stamp}, date = ${date.toLocaleDateString()}`)
  let ds: string[] = date.toLocaleDateString().split('/')
  let res: string = `${ds[2]}/${ds[0]}/${ds[1]}`
  return res
}
