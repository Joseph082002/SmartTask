import relationalStore from '@ohos.data.relationalStore';
import Logger from '../utils/Logger'
import CommonConstants from '../constants/CommonConsts'

export default class TaskDB {
  private rdbStore: relationalStore.RdbStore | null = null
  private tableName: string
  private sqlCreateTable: string
  private columns: Array<string>
  private RDB_TAG: string = '[DEBUG_RDB]'
  private StoreConfig: relationalStore.StoreConfig


  constructor(tableName: string, sqlCreateTable: string, columns: Array<string>, Config: relationalStore.StoreConfig = CommonConstants.STORE_CONFIG) {
    this.tableName = tableName
    this.sqlCreateTable = sqlCreateTable
    this.columns = columns
    this.StoreConfig = Config
  }

  getRdbStore(callback: Function = () => {}) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(this.RDB_TAG, 'getRdbStore() has no callback!');
      return;
    }
    if (this.rdbStore !== null) {
      callback();
      return;
    }
    let context: Context = getContext(this) as Context
    relationalStore.getRdbStore(context, this.StoreConfig, (err, rdb) => {
      if (err) {
        Logger.error(this.RDB_TAG, `gerRdbStore() failed, err: ${err}`);
        return;
      }
      this.rdbStore = rdb
      this.rdbStore.executeSql(this.sqlCreateTable)
      // 假定这里 execute 之后不会出事
      callback();
    })
  }

  updateColumns(newColumn: string, newColumnData: string) {
    this.rdbStore.executeSql(`ALTER TABLE ${this.tableName} ADD COLUMN ${newColumn} ${newColumnData}`)
  }

  // test() {
  //   let vb: relationalStore.ValuesBucket = {
  //     id: 1,
  //     task_name: "123",
  //     subject: 2
  //   }
  //   this.rdbStore.insert('cateTable', vb, (err, ret) => {
  //     Logger.debug(`Test Error: ${(JSON).stringify(err)}, ret = ${ret}`)
  //   })
  // }
  insertData(data: relationalStore.ValuesBucket, callback: Function = () => {}) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(this.RDB_TAG, 'insertData() has no callback!');
      return;
    }
    const valueBucket: relationalStore.ValuesBucket = data
    if (this.rdbStore) {
      Logger.debug(this.RDB_TAG, this.tableName)
      this.rdbStore.insert(this.tableName, valueBucket, (err, ret) => {
        if (err) {
          Logger.error(this.RDB_TAG, `insertData() failed, err: ${err.code}, ${err.name}, ${err.message}, valueB = ${JSON.stringify(valueBucket)}, ret = ${ret}`);
          callback(false)
          return
        }
        Logger.debug(this.RDB_TAG, `insert finished: ${ret}`)
        callback(ret)
      })
    }
  }
  deleteData(predicates:  relationalStore.RdbPredicates, callback: Function = () => {}) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(this.RDB_TAG, 'deleteData() has no callback!');
      return;
    }
    if (this.rdbStore) {
      this.rdbStore.delete(predicates, (err, ret) => {
        if (err) {
          Logger.error(this.RDB_TAG, `deleteData() failed, err: ${err}`);
          callback(false);
          return;
        }
        Logger.info(this.RDB_TAG, `deleteData() finished: ${ret}`);
        callback(true);
      })
    }
  }
  updateData(predicates: relationalStore.RdbPredicates, data: relationalStore.ValuesBucket, callback: Function = () => {}) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(this.RDB_TAG, 'updateDate() has no callback!');
      return;
    }
    const valueBucket: relationalStore.ValuesBucket = data
    if (this.rdbStore) {
      this.rdbStore.update(valueBucket, predicates, (err, ret) => {
        if (err) {
          Logger.error(this.RDB_TAG, `updateData() failed, err: ${err}`);
          callback(false);
          return;
        }
        Logger.info(this.RDB_TAG, `updateData() finished: ${ret}`);
        callback(true);
      })
    }
  }
  query(predicates: relationalStore.RdbPredicates, callback: Function = () => {}) {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(this.RDB_TAG, 'queryTaskName() has no callback!');
      return;
    }
    if (this.rdbStore) {
      this.rdbStore.query(predicates).then((resultSet) => {
        Logger.debug(this.RDB_TAG, `query finished.`)
        callback(resultSet)
        resultSet.close()
      }).catch((err) => {
        if (err) {
          Logger.error(this.RDB_TAG, `query() failed, err:  ${err}`);
          return;
        }
      })
    }
  }

}