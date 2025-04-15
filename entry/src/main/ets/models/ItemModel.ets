/**
 * @fileName : ItemModel.ets
 * @author : @cxy
 * @date : 2025/4/15
 * @description : 文件描述
 */

export class ItemModel {
  id: string = ''
  title: string = ''

  constructor(id: string, title: string) {
    this.id = id
    this.title = title
  }
}