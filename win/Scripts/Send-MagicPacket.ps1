function Send-MagicPacket {
	[CmdletBinding()] param (
		[Parameter (Mandatory = $true, Position = 1)]
		[String] $MACAddress,
		[String] $IPAddress = "255.255.255.255", 
		[int] $Port = 9
	)
	
	$broadcast = [Net.IPAddress]::Parse($IPAddress)
	
	$MACAddress=(($MACAddress.replace(":", "")).replace("-", "")).replace(".", "")
	$target = (0, 2, 4, 6, 8, 10 | % { [Convert]::ToByte($MACAddress.substring($_, 2), 16) } ) # mac address to a byte array
	$packet = (,[byte]255 * 6) + ($target * 16) # magic packet: 6 iterations of 255 and then 16 iterations of mac address
	
	$UDPclient = New-Object System.Net.Sockets.UdpClient
	$UDPclient.Connect($broadcast, $Port)
	[void]$UDPclient.Send($packet, 102) 

}
