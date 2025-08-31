/**
 * @fileName : PerformanceViewModel.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 性能优化数据管理
 */

import { RefreshDataSource, RefreshController } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'

export class PerformanceViewModel {
  dataSource: RefreshDataSource = new RefreshDataSource()
  controller: RefreshController = new RefreshController()
  private currentPage: number = 1
  private pageSize: number = 50 // 大批量加载
  private visibleStart: number = 0
  private visibleEnd: number = 0
  private scrollState: ScrollState = ScrollState.Idle
  private lastScrollOffset: number = 0
  private frameCount: number = 0
  private lastFrameTime: number = 0

  refresh(): void {
    this.currentPage = 1

    // 模拟快速数据加载
    setTimeout(() => {
      this.dataSource.deleteAll()
      const data = this.generatePerformanceData(this.pageSize)
      this.dataSource.pushDataArray(data)
      this.controller.finishRefresh()
      this.controller.setHasmore(true)
    }, 300) // 快速响应
  }

  loadMore(): void {
    this.currentPage++

    // 快速加载更多数据
    setTimeout(() => {
      const data = this.generatePerformanceData(this.pageSize)
      this.dataSource.pushDataArray(data)

      // 模拟大量数据 - 最多20页
      if (this.currentPage >= 20) {
        this.controller.setHasmore(false)
      }

      this.controller.finishRefresh()
    }, 200)
  }

  updateScrollInfo(scrollOffset: number, scrollState: ScrollState): void {
    this.lastScrollOffset = scrollOffset
    this.scrollState = scrollState
    this.updateFPS()
  }

  updateVisibleRange(start: number, end: number): void {
    this.visibleStart = start
    this.visibleEnd = end
  }

  getFPS(): string {
    return `${Math.min(60, Math.max(0, this.frameCount))}`
  }

  getVisibleRange(): string {
    return `${this.visibleStart}-${this.visibleEnd}`
  }

  getMemoryUsage(): string {
    // 模拟内存使用计算
    const itemCount = this.dataSource.totalCount()
    const estimatedMemory = Math.floor(itemCount * 0.5) // 每项约0.5KB
    return `${estimatedMemory}KB`
  }

  getScrollState(): string {
    switch (this.scrollState) {
      case ScrollState.Idle:
        return '静止'
      case ScrollState.Scroll:
        return '滚动'
      case ScrollState.Fling:
        return '惯性'
      default:
        return '未知'
    }
  }

  private updateFPS(): void {
    const now = Date.now()
    if (this.lastFrameTime === 0) {
      this.lastFrameTime = now
      return
    }

    const deltaTime = now - this.lastFrameTime
    if (deltaTime > 0) {
      this.frameCount = Math.floor(1000 / deltaTime)
    }
    this.lastFrameTime = now
  }

  private generatePerformanceData(count: number): ItemModel[] {
    const categories = [
      '高频数据', '实时更新', '大数据量', '性能测试', '压力测试',
      '内存优化', '渲染优化', '滚动优化', '缓存策略', '异步加载'
    ]

    const colors = [
      '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
      '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9'
    ]

    const result: ItemModel[] = []
    for (let index = 0; index < count; index++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + index + 1
      const categoryIndex = globalIndex % categories.length

      const item = new ItemModel(`perf_${globalIndex}`, `性能测试项目 ${globalIndex}`)
      item.index = globalIndex
      item.subtitle = `优化类型: ${categories[categoryIndex]}`
      item.category = categories[categoryIndex]
      item.avatarColor = colors[categoryIndex]
      item.initial = categories[categoryIndex].charAt(0)
      item.score = Math.floor(Math.random() * 100) + 1
      item.isHot = Math.random() > 0.8 // 20%概率为热门
      item.timestamp = Date.now() - Math.random() * 86400000 // 24小时内随机时间
      
      // 性能相关属性
      item.renderTime = Math.random() * 10 + 1 // 1-11ms渲染时间
      item.memorySize = Math.floor(Math.random() * 1000) + 100 // 100-1100字节
      item.priority = Math.floor(Math.random() * 5) + 1 // 1-5优先级

      result.push(item)
    }
    return result
  }
}