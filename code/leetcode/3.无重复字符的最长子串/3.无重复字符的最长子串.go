
/*
s = "abcabcbb"
s = "bbbbb"
s = "pwwkew"
*/

func lengthOfLongestSubstring(s string) int {
	maxLen := 0

	for start := 0; start < len(s); start++ {
		seen := make(map[byte]bool) // 每个起点重新清空
		for end := start; end < len(s); end++ {
			ch := s[end]
			if seen[ch] {
				// 当前字符重复，停止扩展
				break
			}
			seen[ch] = true
			currentLen := end - start + 1
			if currentLen > maxLen {
				maxLen = currentLen
			}
		}
	}
	return maxLen
}
