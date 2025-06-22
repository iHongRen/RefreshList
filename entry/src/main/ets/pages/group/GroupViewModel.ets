/**
 * @fileName : GroupViewModel.ets
 * @author : @cxy
 * @date : 2025/4/16
 * @description : 文件描述
 */

import { RefreshController, RefreshGroupModel, RefreshGroupDataSource } from "refreshlist"
import { ItemModel } from "../../models/ItemModel"

export class GroupViewModel {
  @Track dataSource: RefreshGroupDataSource = new RefreshGroupDataSource()
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
        const item = new ItemModel(`${length + i}`, `title${length + i}`)
        list.push(item)
      }

      if (page === 1) {
        this.dataSource.deleteAll()
      }
      this.dataSource.pushDataArray(list)
      this.controller.finishRefresh()

      this.curpage = page
    }, 500)
  }
}