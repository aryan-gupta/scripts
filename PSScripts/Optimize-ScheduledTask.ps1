
$tasks = @(
	"Microsoft\Windows\Shell\FamilySafetyMonitor"
	"Microsoft\Windows\Shell\FamilySafetyRefreshTask"
)

foreach($task in $tasks) {
	Disable-ScheduledTask -TaskName $task
}
