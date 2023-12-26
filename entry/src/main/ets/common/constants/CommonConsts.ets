import relationalStore from '@ohos.data.relationalStore';
import { TaskListItemData } from '../bean/TaskListItemData'
import DDLDetail from '../bean/DDLDetailClass'

export default class CommonConstants {
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'database.db',
    securityLevel: relationalStore.SecurityLevel.S1
  }
  static readonly PREF_STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'pref_database.db',
    securityLevel: relationalStore.SecurityLevel.S1
  }

  static readonly CATEGORY_STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'category_database.db',
    securityLevel: relationalStore.SecurityLevel.S1
  }
  static readonly TASK_TABLE_INIT = {
    tableName: 'taskTable',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS taskTable' +
    '(id INTEGER PRIMARY KEY AUTOINCREMENT, task_name TEXT, ' +
    'subject INTEGER, start_date_stamp INTEGER, due_date_stamp INTEGER, ' +
    'is_completed BOOLEAN, detail TEXT, ddl_detail TEXT, category INTEGER, topped BOOLEAN)',
    columns: ['id', 'due_date_stamp', 'start_date_stamp', 'subject', 'detail', 'task_name', 'is_completed', 'ddl_detail', 'category', 'topped']
  }

  static readonly PREF_TABLE_INIT = {
    tableName: 'prefTable',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS prefTable' +
    '(id INTEGER PRIMARY KEY AUTOINCREMENT, pref TEXT)',
    columns: ['id', 'pref']
  }
  static readonly CATEGORY_TABLE_INIT = {
    tableName: 'categoryTable',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS categoryTable' +
            '(id INTEGER PRIMARY KEY AUTOINCREMENT, color TEXT, name TEXT)',
    columns: ['id', 'color', 'name']
  }

  static readonly RDB_TAG = "[DebugRDB]"

  static readonly DDL_COLOR = {
    easy: '#A5D61D',
    medium: '#F7CE00',
    hard: '#F9A01E',
    critical: '#E84026'
  }

  static readonly COLUMN_TYPE = {
    id: 'double',
    due_date_stamp: 'double',
    start_date_stamp: 'double',
    category: 'double',
    subject: 'string',
    detail: 'string',
    task_name: 'string',
    is_completed: 'boolean',
    ddl_detail: 'string',
    topped: 'boolean',
  }

  static readonly DDL_DETAIL_PRESET: Array<DDLDetail> = [
    new DDLDetail('不急', '0.2-0.45-0.6'),
    new DDLDetail('放松', '0.2-0.5-0.8'),
    new DDLDetail('正常', '0.3-0.5-0.8'),
    new DDLDetail('紧急', '0.3-0.75-0.9'),
    new DDLDetail('非常紧急', '0.5-0.8-0.99')
  ]

  static readonly CATEGORY_COLOR = [
    '#564AF7',
    '#46B1E3',
    '#64BB5C',
    '#A5D61D',
    '#AC49F5',
    '#E64566',
    '#E84026',
    '#ED6F21'
  ]

  static readonly BACKUP_FILEPATH = "Document/HomeworkTasklist/backup/"
  static readonly BACKUP_FILE = "backup.png"
}
