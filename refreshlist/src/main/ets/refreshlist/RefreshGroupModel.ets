/**
 * @fileName : RefreshGroupModel.ets
 * @author : @cxy
 * @date : 2024/9/20
 * @description : 文件描述
 */
import { RefreshDataSource } from './RefreshDataSource'

export class RefreshGroupModel {
  title: string
  dataSource: RefreshDataSource
  data?: Object

  constructor(title: string, dataSource: RefreshDataSource) {
    this.title = title
    this.dataSource = dataSource
  }
}