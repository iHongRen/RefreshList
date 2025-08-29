/**
 * @fileName : RefreshGroupDataSource.ets
 * @author : @cxy
 * @date : 2024/9/20
 * @description : 分组数据源
 */
import { RefreshDataSource } from './RefreshDataSource'
import { RefreshGroupModel } from './RefreshGroupModel'

export class RefreshGroupDataSource extends RefreshDataSource {
  public isEmpty(): boolean {
    return this.totalItemCount() === 0
  }

  // 如果是Group，则计算所有的GroupItem之和
  public totalItemCount(): number {
    const count = this.list.length
    if (count === 0) {
      return 0
    }
    let itemCount = 0
    for (let index = 0; index < count; index++) {
      const e = this.list[index] as RefreshGroupModel
      itemCount += e.dataSource.totalCount()
    }
    return itemCount
  }

  public getGroupDataAll(): Object[] {
    const all: Object[] = []
    this.list.forEach((e: Object) => {
      const item = e as RefreshGroupModel
      all.push(...item.dataSource.getDataAll())
    })
    return all
  }


  public addListToGroup(list: Object[], getTitle: (e: ESObject) => string) {
    if (list.length === 0) {
      return
    }
    const lastData = this.getLastData()
    let prevTitle: string | undefined = lastData ? (lastData as RefreshGroupModel).title : ''

    let items: Object[] = []
    list.forEach((e: Object) => {

      const title = getTitle(e)
      if (title === prevTitle) {
        items.push(e)
      } else {
        if (prevTitle) {
          const lastData = this.getLastData() as RefreshGroupModel
          lastData.dataSource.pushDataArray(items)
        }
        const dataSource = new RefreshDataSource()
        const group = new RefreshGroupModel(title, dataSource)
        this.pushData(group)

        prevTitle = title
        items = [e]
      }
    });

    if (list.length > 0 && prevTitle && items.length > 0) {
      const lastData = this.getLastData() as RefreshGroupModel
      if (lastData.title === prevTitle) {
        lastData.dataSource.pushDataArray(items)
      }
    }
  }
}

