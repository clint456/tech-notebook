/*
 * @lc app=leetcode.cn id=14 lang=golang
 *
 * [14] 最长公共前缀
 */

// @lc code=start
func longestCommonPrefix(strs []string) string {
	// 边界条件
	if len(strs) == 0 {
		return ""
	}
	var res []byte
	// 求得字符串中最小长度
	minlen := len(strs[0])
	for j := 0; j <= len(strs)-1; j++ {
		if len([]byte(strs[j])) < minlen {
			minlen = len(strs[j])
		}
	}

	for i := 0; i <= minlen-1; i++ {
		pre := []byte(string(strs[0]))[i]
		for j := 0; j <= len(strs)-1; j++ {
			if pre != []byte(string(strs[j]))[i] {
				return string(res)
			}
		}
		res = append([]byte(res), pre)
	}
	return string(res)
}

// @lc code=end
