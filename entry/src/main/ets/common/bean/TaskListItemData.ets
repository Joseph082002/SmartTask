import CategoryTable from '../database/CategoryTable'
import Logger from '../utils/Logger'
import TaskCategoryData from './TaskCategoryData'

export interface ItemDataInterface {
  id: number
  detail: string
  task_name: string
  start_date_stamp: number
  due_date_stamp: number
  is_completed: boolean
  ddl_detail: string
  category: number
  topped: boolean
}

@Observed
export class TaskListItemData implements ItemDataInterface {
  id: number = -1
  start_date_stamp: number = 0
  due_date_stamp: number = 0
  detail: string = ''
  subject: number = 0
  task_name: string = ''
  is_completed: boolean = false
  ddl_detail: string = '0.3-0.5-0.8'
  ddl_state = {
    critical: 0.3,
    hard: 0.5,
    medium: 0.8
  }
  category: number = 1
  categoryName: string = ''
  topped: boolean = false

  setAll(categoryList: TaskCategoryData[]) {
    let ddl_arr = this.ddl_detail.split('-')
    Logger.debug(`TaskDDL Info: arr = ${JSON.stringify(ddl_arr)}, det = ${this.ddl_detail}`)
    this.ddl_state.critical = Number(ddl_arr[0])
    this.ddl_state.hard = Number(ddl_arr[1])
    this.ddl_state.medium = Number(ddl_arr[2])
    this.setCategoryName(categoryList)
  }
  setCategoryName(categoryList: TaskCategoryData[]) {
    for (let i = 0; i < categoryList.length; ++i) {
      if (categoryList[i].id == this.category) {
        this.categoryName = categoryList[i].name
        break;
      }
    }
  }
  getDDLState(): string {
    let taskFullTime = this.due_date_stamp - this.start_date_stamp
    let nowTime = new Date()
    let remainingTime = this.due_date_stamp - nowTime.getTime()
    let resultPercentage = remainingTime / taskFullTime
    Logger.debug(`TaskDDL State: full = ${taskFullTime}, remaining = ${remainingTime}, per = ${resultPercentage}`)
    Logger.debug(`TaskDDL ------ due: ${new Date(this.due_date_stamp).toString()}, now: ${new Date().toString()}, start: ${new Date(this.start_date_stamp).toString()}`)
    Logger.debug(`TaskDDL ------: arr = ${JSON.stringify(this.ddl_state)}`)

    if (remainingTime < 0) return 'critical'
    if (resultPercentage < this.ddl_state.critical) return 'critical'
    else if (resultPercentage < this.ddl_state.hard) return 'hard'
    else if (resultPercentage < this.ddl_state.medium) return 'medium'
    else return 'easy'
  }
  getDDLPer(): number {
    let taskFullTime = this.due_date_stamp - this.start_date_stamp
    let nowTime = new Date()
    let remainingTime = this.due_date_stamp - nowTime.getTime()
    if (remainingTime <= 0) return 0
    let resultPercentage = remainingTime / taskFullTime
    return resultPercentage * 100
  }
}