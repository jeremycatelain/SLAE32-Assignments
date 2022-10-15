rule addr00tuser {
	meta:
		description = "Personal rule"
	strings:
		$y1 = {73 73 77 64}
		$y2 = {2f 2f 70 61}
		$y3 = {2f 65 74 63}
		$y4 = {30 3a 3a 3a}
		$y5 = {3a 3a 30 3a}
		$y6 = {72 30 30 74}
	condition:
	$y1 and $y2 and $y3 or $y4 and $y5 and $y6 
}