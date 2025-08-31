/**
 * @fileName : GridViewModel.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 网格布局数据管理
 */

import { RefreshDataSource, RefreshController } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'

export class GridViewModel {
  dataSource: RefreshDataSource = new RefreshDataSource()
  controller: RefreshController = new RefreshController()
  private currentPage: number = 1
  private pageSize: number = 20

  refresh(): void {
    this.requestPage(1)
  }

  loadMore(): void {
    this.requestPage(this.currentPage + 1)
  }

  requestPage(page: number) {
    // 模拟网络请求延迟
    setTimeout(() => {
      this.currentPage = page
      const data = this.generateData(this.pageSize)
      if (page === 1) {
        this.dataSource.deleteAll()
      }
      this.dataSource.pushDataArray(data)

      // 模拟最多5页数据
      const hasMore = page < 5
      this.controller.setHasmore(hasMore)
      this.controller.finishRefresh()
    }, 800)
  }

  private generateData(count: number): ItemModel[] {
    const products = [
      '苹果iPhone 15 Pro', '华为Mate 60 Pro', '小米14 Ultra', 'OPPO Find X7',
      'vivo X100 Pro', '三星Galaxy S24', '荣耀Magic6', '一加12',
      '真我GT5 Pro', 'iQOO 12 Pro', '红米K70 Pro', '魅族21 Pro'
    ]

    const categories = ['手机数码', '家用电器', '服装鞋包', '美妆护肤', '食品生鲜', '图书音像']

    const result: ItemModel[] = []
    for (let index = 0; index < count; index++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + index
      const productName = products[globalIndex % products.length]

      const item = new ItemModel(`grid_${globalIndex}`, `${productName} ${globalIndex + 1}`)
      item.price = (Math.random() * 5000 + 500).toFixed(2)
      item.sales = Math.floor(Math.random() * 10000) + 100
      item.rating = Math.floor(Math.random() * 2) + 4 // 4-5星
      item.category = categories[Math.floor(Math.random() * categories.length)]
      item.image = `https://picsum.photos/200/200?random=${globalIndex}`

      result.push(item)
    }
    return result
  }
}