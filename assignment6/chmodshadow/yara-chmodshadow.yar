rule chmodshadow {
	meta:
		description = "Personal rule"
	strings:
		$y1 = {2f 2f 73 68}
		$y2 = {2f 65 74 63}
		$y3 = {3e 1f 3a 56}
	condition:
	$y1 and $y2 and $y3
}