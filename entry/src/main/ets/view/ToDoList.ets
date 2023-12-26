import { Settings } from '../components/IndexTabPages/Settings'
import TaskList from '../components/IndexTabPages/TaskList'
import DDLState from '../components/IndexTabPages/DDLState'
import { TaskListItemData } from '../common/bean/TaskListItemData'
import TaskTable from '../common/database/TaskTable'
import Logger from '../common/utils/Logger'
import CommonUI from '../common/constants/CommonUIConstants'
import PreferenceData from '../common/bean/PreferenceData'
import CategoryTable from '../common/database/CategoryTable'
import TaskCategoryData from '../common/bean/TaskCategoryData'
import PreferenceDB from '../common/database/PreferenceDB'
import CommonConstants from '../common/constants/CommonConsts'
import router from '@ohos.router'
import MediaQuery from '../common/utils/MediaQuery'

let storage = new LocalStorage({ 'taskTable': 1 })

@Entry(storage)
@Component

export default struct ToDoList {
  @State message: string = 'Hello World'
  @State currentIndex: number = 0
  @State taskList: Array<TaskListItemData> = []
  @State categoryList: Array<TaskCategoryData> = []

  @State taskTable: TaskTable = new TaskTable(() => {});
  @State categoryTable: CategoryTable = new CategoryTable(() => {})
  @State prefData: PreferenceData = new PreferenceData()

  private controller: TabsController = new TabsController();

  @Builder TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
        .fillColor(this.currentIndex === targetIndex ? '#0A59F7' : '#6B6B6B')
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#0A59F7' : '#6B6B6B')
        .fontSize(12)
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
      this.controller.changeIndex(targetIndex)
    })
  }

  async aboutToAppear() {

    await PreferenceDB.getPreferenceStorage()
    let prefFirstTimeOpen = await PreferenceDB.getPreference('firstOpen')
    Logger.debug(`PrefDB: query = ${prefFirstTimeOpen}`)
    if (prefFirstTimeOpen === '') {
      await PreferenceDB.putPreference('firstOpen', 'true')
      await PreferenceDB.putPreference('nowVerColumn', JSON.stringify(CommonConstants.TASK_TABLE_INIT.columns))
      // OOBE
      router.pushUrl({
        url: "pages/OOBE"
      }, router.RouterMode.Single, (err) => {
        if (err) {
          console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        }
      })
    } else {
      let last_columns: string[] = JSON.parse(await PreferenceDB.getPreference('nowVerColumn'))
      if (last_columns.length == CommonConstants.TASK_TABLE_INIT.columns.length) Logger.debug(`PrefDB: TaskTable Columns up to date`)
      else {
        this.taskTable.getRdbStore(() => {
          CommonConstants.TASK_TABLE_INIT.columns.forEach((column) => {
            if (last_columns.indexOf(column) == -1) {
              Logger.debug(`PrefDB: New Column detected: ${column}`)
              this.taskTable.updateColumns(column, CommonConstants.COLUMN_TYPE[column])
            }
          })
        })
      }
    }

    this.categoryTable.getRdbStore(() => {
      this.categoryTable.query(0, (res) => {
        // first-time
        if (res.length == 0) {
          Logger.debug('first install, loading Category')
          let newData = new TaskCategoryData()
          this.categoryTable.insertData(newData, (id) => {
            newData.id = id
            this.categoryList.push(newData)
          })
        } else res.forEach((value) => {
          this.categoryList.push(value)
        })

        this.taskTable.getRdbStore(() => {
          this.taskTable.queryTaskName('', (result: TaskListItemData[]) => {
            result.sort((a, b) => {
              return Number(b.topped == true ? 2 : 0) - Number(a.topped == true ? 2 : 0)
            })
            this.taskList = result
            for (let i = 0; i < this.taskList.length; ++i) {
              this.taskList[i].setAll(this.categoryList)
            }
            Logger.debug(`TaskListItemData = ${JSON.stringify(this.taskList)}`)
          }, true)
        })

      })
    })
  }

  pageTransition() {
    PageTransitionExit({ type: RouteType.Push, duration: 500, curve: Curve.Ease })
      .slide(SlideEffect.Left)
  }

  build() {
    Column() {
      Tabs({ barPosition: (BarPosition.End), controller: this.controller }) {
        TabContent() {
          TaskList({taskList: $taskList, taskTable: $taskTable, prefData: $prefData, categoryList: $categoryList, categoryTable: $categoryTable})
        }.tabBar(this.TabBuilder("清单", 0, $r('app.media.ic_public_home_filled'), $r('app.media.ic_public_home')))
        TabContent() {
          DDLState({tasks: $taskList, categoryList: $categoryList})
        }.tabBar(this.TabBuilder("截止时间", 1, $r('app.media.ic_public_time_filled'), $r('app.media.ic_public_time')))
        TabContent() {
          Settings({tasks: $taskList})
        }.tabBar(this.TabBuilder("设置", 2, $r('app.media.ic_public_settings_filled'), $r('app.media.ic_public_settings')))
      }.onChange((index: number) => {
        // future_TODO: animation
        this.currentIndex = index
      })
      .scrollable(false)
      // .height(50)
      // .width('100%')
    }.width('100%')
    .height('100%')
    .backgroundColor(CommonUI.COLOR_DEFAULT.background)
  }

}