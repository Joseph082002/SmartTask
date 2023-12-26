import dataPreferences from '@ohos.data.preferences'
import Logger from '../utils/Logger'

let context = getContext(this)
let preference: dataPreferences.Preferences
let preferenceTemp: dataPreferences.Preferences

class PreferenceDB {
  async getPreferenceStorage() {
    try {
      preference = await dataPreferences.getPreferences(context, 'Pref.db')
    } catch(err){
      Logger.error(`PrefDB: failed to get storage: ${err}`)
    }
  }
  async putPreference(key: string, value: string) {
    try {
      await preference.put(key, value)
    } catch(err) {
      Logger.error(`PrefDB: failed to put pref: ${err}`)
    }
    await preference.flush()
  }
  async getPreference(key: string): Promise<string> {
    let res: string = ''
    if (!preference) preference = await dataPreferences.getPreferences(context, 'Pref.db')
    try {
      res = (await preference.get(key, '')).toString()
    } catch(err) {
      Logger.error(`PrefDB: failed to get pref: ${err}`)
    }
    return res
  }
}

export default new PreferenceDB()