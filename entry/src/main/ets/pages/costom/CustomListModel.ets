/**
 * @fileName : CustomListModel.ets
 * @author : @cxy
 * @date : 2025/6/29
 * @description : 文件描述
 */

import { RefreshController, RefreshDataSource } from "refreshlist"
import { ItemModel } from "../../models/ItemModel"

export class CustomListModel {
  @Track dataSource: RefreshDataSource = new RefreshDataSource
  @Track controller: RefreshController = new RefreshController()
  private curpage: number = 1

  refresh(): void {
    this.requestData(1)
  }

  loadMore(): void {
    this.requestData(this.curpage + 1)
  }

  async requestData(page: number): Promise<void> {
    setTimeout(() => {
      const length = page === 1 ? 0 : this.dataSource.totalCount()
      const list: ItemModel[] = []
      for (let i = 0; i < 20; i++) {
        const item = new ItemModel(`${length + i}`, `item${length + i}`)
        list.push(item)
      }

      if (page === 1) {
        this.dataSource.deleteAll()
      }
      this.dataSource.pushDataArray(list)

      // 是否还有更多数据
      const hasmore = page === 1
      this.controller.setHasmore(hasmore)

      this.controller.finishRefresh()

      // 隐藏加载更多组件
      this.controller.hideLoadMore(true)

      this.curpage = page
    }, 500)
  }
}