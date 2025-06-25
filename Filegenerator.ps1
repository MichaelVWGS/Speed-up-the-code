Measure-Command {
    $bigFileName = "plc_log.txt"
    $plcNames = 'PLC_A', 'PLC_B', 'PLC_C', 'PLC_D'
    $errorTypes = @(
        'Sandextrator overload',
        'Conveyor misalignment',
        'Valve stuck',
        'Temperature warning'
    )
    $statusCodes = 'OK', 'WARN', 'ERR'
    $logLines = [System.Collections.Generic.List[string]]::new(50000)
    $random = [System.Random]::new()
    $baseDate = [DateTime]::Now

    for ($i = 0; $i -lt 50000; $i++) {
        $date = $baseDate.AddSeconds(-$i)
        $timestamp = "{0:D4}-{1:D2}-{2:D2} {3:D2}:{4:D2}:{5:D2}" -f $date.Year, $date.Month, $date.Day, $date.Hour, $date.Minute, $date.Second
        $plc = $plcNames[$random.Next(0, $plcNames.Count)]
        $operator = $random.Next(101, 121)
        $batch = $random.Next(1000, 1101)
        $status = $statusCodes[$random.Next(0, $statusCodes.Count)]
        $machineTemp = [int](($random.Next(60, 110) + $random.NextDouble()) * 100 + 0.5) / 100
        $load = $random.Next(0, 101)
        if ($random.Next(1, 8) -eq 4) {
            $errorType = $errorTypes[$random.Next(0, $errorTypes.Count)]
            if ($errorType[0] -eq 'S') {
                $value = $random.Next(1, 11)
                $msg = "ERROR; $timestamp; $plc; $errorType; $value; $status; $operator; $batch; $machineTemp; $load"
            }
            else {
                $msg = "ERROR; $timestamp; $plc; $errorType; ; $status; $operator; $batch; $machineTemp; $load"
            }
        }
        else {
            $msg = "INFO; $timestamp; $plc; System running normally; ; $status; $operator; $batch; $machineTemp; $load"
        }
        $logLines.Add($msg)
    }

    [System.IO.File]::WriteAllLines($bigFileName, $logLines)
}
