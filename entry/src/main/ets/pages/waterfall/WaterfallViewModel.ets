/**
 * @fileName : WaterfallViewModel.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 瀑布流数据管理
 */

import { RefreshDataSource, RefreshController } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'

export class WaterfallViewModel {
  dataSource: RefreshDataSource = new RefreshDataSource()
  controller: RefreshController = new RefreshController()
  private currentPage: number = 1
  private pageSize: number = 15

  refresh(): void {
    this.currentPage = 1

    setTimeout(() => {
      this.dataSource.deleteAll()
      const data = this.generateWaterfallData(this.pageSize)
      this.dataSource.pushDataArray(data)
      this.controller.finishRefresh()
      this.controller.setHasmore(true)
    }, 2000)
  }

  loadMore(): void {
    this.currentPage++

    setTimeout(() => {
      const data = this.generateWaterfallData(this.pageSize)
      this.dataSource.pushDataArray(data)

      // 模拟最多加载8页
      if (this.currentPage >= 8) {
        this.controller.setHasmore(false)
      }

      this.controller.finishRefresh()
    }, 1200)
  }

  private generateWaterfallData(count: number): ItemModel[] {
    const titles = [
      '美丽的日落风景', '城市夜景摄影', '可爱的小猫咪', '美味的甜品制作',
      '旅行中的美好时光', '手工艺品制作过程', '健身运动分享', '读书心得体会',
      '音乐演奏视频', '绘画创作过程', '烹饪美食教程', '宠物日常生活',
      '时尚穿搭分享', '摄影技巧教学', '园艺种植经验', '科技产品评测'
    ]

    const descriptions = [
      '分享生活中的美好瞬间，记录每一个值得纪念的时刻。',
      '用镜头捕捉世界的美丽，发现生活中的小确幸。',
      '热爱生活，享受当下，与大家分享快乐时光。',
      '探索新的可能性，创造属于自己的精彩故事。',
      '用心感受生活的美好，传递正能量给每一个人。'
    ]

    const authors = [
      '摄影师小王', '美食达人', '旅行博主', '手工爱好者',
      '健身教练', '读书分享者', '音乐人', '艺术创作者'
    ]

    const result: ItemModel[] = []
    for (let index = 0; index < count; index++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + index

      const item = new ItemModel(`waterfall_${globalIndex}`, titles[globalIndex % titles.length])
      item.description = descriptions[globalIndex % descriptions.length]
      item.author = authors[globalIndex % authors.length]
      item.likes = Math.floor(Math.random() * 1000) + 10
      item.comments = Math.floor(Math.random() * 100) + 1
      item.imageHeight = Math.floor(Math.random() * 100) + 120 // 120-220的随机高度
      item.image = `https://picsum.photos/300/${Math.floor(Math.random() * 200) + 200}?random=${globalIndex}`
      item.avatar = `https://i.pravatar.cc/40?img=${(globalIndex % 20) + 1}`

      result.push(item)
    }
    return result
  }
}