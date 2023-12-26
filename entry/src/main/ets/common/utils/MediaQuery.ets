import mediaquery from '@ohos.mediaquery';
import deviceInfo from '@ohos.deviceInfo';

class MediaQuery {
  smListener = mediaquery.matchMediaSync('(width < ' + 520 + 'vp)');
  mdListener = mediaquery.matchMediaSync('(width >= ' + 520 + 'vp) and (width <= ' + 840 + 'vp)');
  lgListener = mediaquery.matchMediaSync('(width > ' + 840 + 'vp)');
  darkmodeListener = mediaquery.matchMediaSync('screen and (dark-mode: true)');
  portraitFuncSm = null;
  portraitFuncMd = null;
  portraitFuncLg = null;
  portraitFuncDarkmode = null;
  screenType: string = ''

  constructor() {
    var that = this;
    this.smListener = mediaquery.matchMediaSync('(width <= ' + 672 + ')');
    this.mdListener = mediaquery.matchMediaSync('(width > ' + 672 + ') and (width <= ' + 1250 + ')');
    this.lgListener = mediaquery.matchMediaSync('(width > ' + 1250 + ')');
    this.darkmodeListener = mediaquery.matchMediaSync('screen and (dark-mode: true)');
    this.portraitFuncSm = this.onPortraitSm.bind(this)
    this.smListener.on('change', this.portraitFuncSm)
    this.portraitFuncMd = this.onPortraitMd.bind(this)
    this.mdListener.on('change', this.portraitFuncMd)
    this.portraitFuncLg = this.onPortraitLg.bind(this)
    this.lgListener.on('change', this.portraitFuncLg)
  }
  public onPortraitSm(mediaQueryResult) {
    if (mediaQueryResult.matches) {
      this.screenType = 'sm'
      console.info('sm')
    }
  }

  public onPortraitMd(mediaQueryResult) {
    if (mediaQueryResult.matches) {
      this.screenType = 'md'
      console.info('md')
    }
  }

  public onPortraitLg(mediaQueryResult) {
    if (mediaQueryResult.matches) {
      this.screenType = 'lg'
      console.info('lg')
    }
  }
}

export default new MediaQuery()