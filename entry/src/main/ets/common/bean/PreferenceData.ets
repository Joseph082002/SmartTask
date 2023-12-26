import CommonConstants from '../constants/CommonConsts'
import TaskCategoryData from './TaskCategoryData'
export interface PreferenceInterface {
  id: number
}
export default class PreferenceData implements PreferenceInterface {
  id: number = 1
}