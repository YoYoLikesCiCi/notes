# base in comparison 
## 1.  Bubble Sort O(N^2)
- 相邻比较, 直至最后  
给定一个 N 个元素的数组，冒泡法排序将：  
1. 比较一对相邻元素（a，b），  
2. 如果两项的大小关系不正确，交换这两个数（在本例中为a > b），  
3. 重复步骤1和2，直到我们到达数组的末尾（最后一对是第 N-2 和 N-1 项，因为我们的数组从零开始）  
4. 到目前为止，最大项将在最后的位置。 然后我们将 N 减少1，并重复步骤1，直到 N = 1。   

```c++
void bubbleSort(int a[], int N) { // 标准版本
  for (; N > 0; --N) // N次迭代
    for (int i = 0; i < N-1; ++i) // 除最后一次, O(N)
      if (a[i] > a[i+1]) // 若数组元素i和i+1成非递减次序
        swap(a[i], a[i+1]); // 在O(1)时间内交换
}
```


## 2. Selection Sort O(N^2)
- 选择最小或最大然后交换    
 给定 N 个项目和 L = 0 的数组，选择排序将：
1. 在 [L ... N-1] 范围内找出最小项目 X 的位置，
2. 用第 L 项交换第 X 项，
3. 将下限 L 增加1并重复步骤1直到 L = N-2。

```c++
void selectionSort(int a[], int N) {
  for (int L = 0; L <= N-2; ++L) { // O(N)
    int X = min_element(a+L, a+N) - a; // O(N)
    swap(a[X], a[L]); // O(1), X may be equal to L (no actual swap)
  }
}
```



## 3. Insection Sort O(N^2)
- 插入到合适的位置,类似摸扑克牌  
- 从你手中的一张牌开始，    
- 选择下一张牌并将其插入到正确的排序顺序中，    
- 对所有牌重复上一步。    
    

```c++
void insertionSort(int a[], int N) { //插入排序
  for (int i = 1; i < N; i++) { // O(N)
    X = a[i]; // X 是要被插入的那个数
    for (j = i-1; j >= 0 && a[j] > X; j--) // 速度有快有慢
      a[j+1] = a[j]; // 为 X 腾出一个空间
    a[j+1] = X; // 此处为插入点
  }
}
```

# Divide-and-Conquer 
## 4. Merge Sort  O(N log N)  also Comparison
- 
- 将每对单个元素（默认情况下，已排序）归并为2个元素的有序数组， 
- 将2个元素的每对有序数组归并成4个元素的有序数组，重复这个过程......，
- 最后一步：归并2个N / 2元素的排序数组（为了简化讨论，我们假设N是偶数）以获得完全排序的N个元素数组。
-
- 给定两个大小分别为 N1 和 N2 的排序数组 A 和 B，我们可以在O(N) 时间内将它们有效地归并成一个大小为 N = N1 + N2的组合排序数组。
这是通过简单地比较两个数组的首项并始终取两个中较小的一个来实现的。 但是，这个简单但快速的O(N)合并子程序将需要额外的数组来正确合并。

```c++
// subprocess of Merge Sort 
void merge(int a[], int low, int mid, int high) {
  // subarray1 = a[low..mid], subarray2 = a[mid+1..high], both sorted
  int N = high-low+1;
  int b[N]; // 讨论: 为什么我们需要一个临时的数组 b?
  int left = low, right = mid+1, bIdx = 0;
  while (left <= mid && right <= high) // 归并
    b[bIdx++] = (a[left] <= a[right]) ? a[left++] : a[right++];
  while (left <= mid) b[bIdx++] = a[left++]; // leftover, if any
  while (right <= high) b[bIdx++] = a[right++]; // leftover, if any
  for (int k = 0; k < N; k++) a[low+k] = b[k]; // copy back
}

// main process 
void mergeSort(int a[], int low, int high) {
  // 要排序的数组是 a[low..high]
  if (low < high) { // 基础情况: low >= high (0或1项)
    int mid = (low+high) / 2;
    mergeSort(a, low  , mid ); // 分成两半
    mergeSort(a, mid+1, high); // 递归地将它们排序
    merge(a, low, mid, high); // 解决步骤: 归并子程序
  }
}
```

## 5. Quick Sort 
