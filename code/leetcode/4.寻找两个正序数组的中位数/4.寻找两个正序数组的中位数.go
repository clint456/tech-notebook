/*
 * @lc app=leetcode.cn id=4 lang=golang
 *
 * [4] 寻找两个正序数组的中位数
 */

import "math"

// @lc code=start
func findMedianSortedArrays(nums1 []int, nums2 []int) float64 {
	// 保证 nums1 是较短的数组，避免对较长数组进行二分查找
	if len(nums1) > len(nums2) {
		return findMedianSortedArrays(nums2, nums1) // 递归调用，交换数组
	}

	m, n := len(nums1), len(nums2) // 获取两个数组的长度
	left, right := 0, m            // 初始二分查找的范围，左指针和右指针
	halfLen := (m + n + 1) / 2     // 中位数位置：halfLen 是左边部分的元素个数

	// 进行二分查找
	for left <= right {
		// 二分查找的中间位置
		i := (left + right) / 2 // nums1 的切割位置
		j := halfLen - i        // nums2 的切割位置，由 i 推导出

		// 计算 nums1 切割点的左边最大值和右边最小值
		nums1LeftMax := math.Inf(-1) // 默认为负无穷
		if i > 0 {
			nums1LeftMax = float64(nums1[i-1]) // nums1 左侧的最大值
		}
		nums1RightMin := math.Inf(1) // 默认为正无穷
		if i < m {
			nums1RightMin = float64(nums1[i]) // nums1 右侧的最小值
		}

		// 计算 nums2 切割点的左边最大值和右边最小值
		nums2LeftMax := math.Inf(-1) // 默认为负无穷
		if j > 0 {
			nums2LeftMax = float64(nums2[j-1]) // nums2 左侧的最大值
		}
		nums2RightMin := math.Inf(1) // 默认为正无穷
		if j < n {
			nums2RightMin = float64(nums2[j]) // nums2 右侧的最小值
		}

		// 判断当前划分是否满足中位数的条件
		if nums1LeftMax <= nums2RightMin && nums2LeftMax <= nums1RightMin {
			// 满足条件，返回中位数
			if (m+n)%2 == 0 {
				// 总长度为偶数，中位数是左侧最大值和右侧最小值的平均数
				return (math.Max(nums1LeftMax, nums2LeftMax) + math.Min(nums1RightMin, nums2RightMin)) / 2
			} else {
				// 总长度为奇数，中位数是左侧的最大值
				return math.Max(nums1LeftMax, nums2LeftMax)
			}
		} else if nums1LeftMax > nums2RightMin {
			// nums1 的左边最大值大于 nums2 的右边最小值，说明 i 太大，减少右边界
			right = i - 1
		} else {
			// nums2 的左边最大值大于 nums1 的右边最小值，说明 i 太小，增加左边界
			left = i + 1
		}
	}

	panic("逻辑错误") // 如果无法找到有效的划分，说明程序有问题
}

// @lc code=end
