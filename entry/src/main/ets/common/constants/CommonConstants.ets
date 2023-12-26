/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Common constants for all features.
 */
export default class CommonConstants {
  /**
   * Input length of the account.
   */
  static readonly INPUT_ACCOUNT_LENGTH = 11;

  /**
   *  Input length of the password.
   */
  static readonly INPUT_PASSWORD_LENGTH = 8;

  /**
   *  Left padding of the input box
   */
  static readonly INPUT_PADDING_LEFT = 0;

  /**
   * Delay time of simulated login
   */
  static readonly LOGIN_DELAY_TIME = 2000;

  /**
   * Common Spacing of Components
   */
  static readonly COMMON_SPACE = 12;

  /**
   * Title text of the home page
   */
  static readonly ST_TodoList = '清单';

  /**
   * Title text of the home page
   */
  static readonly ST_Calendar = '日历';

  /**
   * Title text of the home page
   */
  static readonly ST_FourQuaDrant = '四象限';

  /**
   * Title text of the home page
   */
  static readonly ST_preTodo = '计划生成';

  /**
   * Title text of the setting page
   */
  static readonly ST_MINE = '我的';

  /**
   * Spacing of other login methods
   */
  static readonly LOGIN_METHODS_SPACE = 44;

  /**
   * The width or height of the component is spread across the parent component.
   */
  static readonly FULL_PARENT = '100%';

  /**
   * The width of button
   */
  static readonly BUTTON_WIDTH = '90%';

  /**
   * The width of setting list
   */
  static readonly SET_LIST_WIDTH = '42%';

  /**
   * Home tab index
   */
  static readonly ST_TodoList_TAB_INDEX = 0;

  /**
   * Mine tab index
   */
  static readonly ST_Calendar_TAB_INDEX = 1;

  /**
   * Home tab index
   */
  static readonly ST_FourQuaDrant_TAB_INDEX = 2;

  /**
   * Home tab index
   */
  static readonly ST_preTodo_TAB_INDEX = 3;

  /**
   * Home tab index
   */
  static readonly ST_MINE_TAB_INDEX = 4;

}

