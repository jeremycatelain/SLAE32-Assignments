rule download_exec_shell {
	meta:
		description = "Personal rule"
	strings:
		$y1 = {74 2f 2f 78}
		$y2 = {6C 68 6F 73}
		$y3 = {6C 6f 63 61}
		$y4 = {2f 77 67 65}
		$y5 = {2f 62 69 6e}
		$y6 = {2f 75 73 72}
	condition:
	$y1 and $y2 and $y3 or $y4 and $y5 and $y6 
}