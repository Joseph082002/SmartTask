export interface TaskCategoryDataInterface {
  color: string
  name: string
  id: number
}

export default class TaskCategoryData implements TaskCategoryDataInterface {
  color: string = '#000000'
  name: string = '默认清单'
  id: number = 0
}