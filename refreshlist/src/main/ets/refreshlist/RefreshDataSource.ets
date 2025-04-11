/**
 * @fileName : RefreshDataSource.ets
 * @author : @cxy
 * @date : 2024/9/19
 * @description : 文件描述
 */


export class RefreshDataSource implements IDataSource {
  protected list: Object[] = []
  private listeners: DataChangeListener[] = []
  onDataCountChange: (count: number) => void = () => {
  }

  public isEmpty(): boolean {
    return this.list.length === 0
  }

  public totalCount(): number {
    return this.list.length
  }

  public totalItemCount(): number {
    return this.totalCount()
  }

  public getData(index: number): Object | undefined {
    return this.list[index]
  }

  public getLastData(): Object | undefined {
    return this.list.length === 0 ? undefined : this.list[this.list.length-1]
  }

  public getDataAll(): Object[] {
    return this.list
  }

  insertData(index: number, data: Object): void {
    this.list.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  insertDataArray(index: number, arr: Object[]): void {
    this.list.splice(index, 0, ...arr)
    this.notifyDataAdd(index, arr.length)
  }

  pushData(data: Object): void {
    this.list.push(data)
    this.notifyDataAdd(this.list.length - 1)
  }

  pushDataArray(arr: Object[]) {
    const index = this.list.length
    this.list.push(...arr)
    this.notifyDataAdd(index, arr.length)
  }

  deleteIndex(index: number): void {
    if (index >= 0) {
      this.list.splice(index, 1)
      this.notifyDataDelete(index)
    }
  }

  deleteData(data: Object): void {
    const index = this.list.indexOf(data)
    this.deleteIndex(index)
  }

  deleteAll(): void {
    const count = this.list.length
    if (count === 0) {
      return
    }
    this.list = []
    this.notifyDataListDelete(0, count)
  }

  deleteIndexCount(index: number, count: number): void {
    if (index >= 0) {
      this.list.splice(index, count)
      this.notifyDataListDelete(index, count)
    }
  }

  repalceIndex(index: number, data: Object, key?: string) {
    if (index >= 0) {
      this.list.splice(index, 1, data)
      this.notifyDataChange(index, key)
    }
  }


  reloadIndex(index: number, key?: string): void {
    this.notifyDataChange(index, key)
  }

  reloadData(data: Object, key?: string): void {
    const index = this.list.indexOf(data)
    if (index >= 0) {
      this.notifyDataChange(index, key)
    }
  }

  reloadDataAll(): void {
    this.notifyDataReload()
  }

  moveDataIndex(from: number, to: number): void {
    const tmp = this.list.splice(from, 1)
    this.list.splice(to, 0, tmp[0])
    this.notifyDataMove(from, to)
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  private notifyDataAdd(index: number, count: number = 1): void {
    this.notifyDatasetChange([{ type: DataOperationType.ADD, index: index, count: count }])
    this.onDataCountChange(this.totalItemCount())
  }

  private notifyDataChange(index: number, key?: string): void {
    this.notifyDatasetChange([{ type: DataOperationType.CHANGE, index: index, key: key }])
  }

  private notifyDataDelete(index: number): void {
    this.notifyDataListDelete(index)
  }

  private notifyDataListDelete(index: number, count: number = 1): void {
    this.notifyDatasetChange([{ type: DataOperationType.DELETE, index: index, count: count }])
    this.onDataCountChange(this.totalItemCount())
  }

  private notifyDataMove(from: number, to: number): void {
    this.notifyDatasetChange([{ type: DataOperationType.MOVE, index: { from: from, to: to } }])
  }


  private notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    })
  }

  private notifyDataReload(): void {
    const total = this.totalCount()
    for (let i = 0; i < total; i++) {
      this.notifyDataChange(i)
    }
  }
}