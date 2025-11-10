/**
 * @fileName : RefreshGlobalConfig.ets
 * @author : @cxy
 * @date : 2025/9/3
 * @description : 全局配置
 */
import { RefreshFooterData, RefreshHeaderData } from "./RefreshState";

export interface IRefreshHeaderData {
  data: RefreshHeaderData
}

export interface IRefreshFooterData {
  data: RefreshFooterData
}

export class RefreshGlobalConfig {
  // 自定义组件
  static headerBuilder?: WrappedBuilder<[IRefreshHeaderData]>
  static footerBuilder?: WrappedBuilder<[IRefreshFooterData]>
  static loadingBuilder?: WrappedBuilder<[]>
  static emptyBuilder?: WrappedBuilder<[]>
  // header 文本
  static headerInactiveText: ResourceStr = '刷新'
  static headerDragText: ResourceStr = '下拉刷新'
  static headerOverDragText: ResourceStr = '释放刷新'
  static headerRefreshText: ResourceStr = '刷新中...'
  static headerDoneText: ResourceStr = '刷新完成'
  // footer 文本
  static footerNoneText: ResourceStr = '上拉加载更多'
  static footerLoadingText: ResourceStr = '加载中...'
  static footerNoMoreText: ResourceStr = '没有更多了'
  // 文本颜色
  static headerTextColor: ResourceColor = '#bbb'
  static footerTextColor: ResourceColor = '#bbb'
  // 字体
  static headerTextFont: Font = { size: 13 }
  static footerTextFont: Font = { size: 13 }
  // loading 颜色
  static headerLoadingColor: ResourceColor | LinearGradient = new LinearGradient([{ color: "#d8eaff", offset: 0 },
    { color: "#0b72ea", offset: 1 }])
  static footerLoadingColor: ResourceColor = '#bbb'
  // loading 大小
  static headerLoadingSize: SizeOptions = { width: 20, height: 20 }
  static footerLoadingSize: SizeOptions = { width: 20, height: 20 }
  // 设置触发刷新的下拉偏移量，当下拉距离小于该属性设置值时离手不会触发刷新。默认64
  static refreshOffset: number
  // 设置下拉跟手系数。数值越大，跟随手势下拉的反应越灵敏，有效值为0-1之间的值
  static pullDownRatio: number
  // 设置最大下拉距离。从API version 20开始
  // static maxPullDownDistance: number
}

