Get-WinEvent -FilterHashtable @{logname='security'; id=4624;} source address
https://livebook.manning.com/book/powershell-deep-dives/chapter-6/46

$result = Get-EventLog -LogName Security -InstanceId 4624 |
   ForEach-Object {
     [PSCustomObject]@{
     Time = $_.TimeGenerated
     Machine = $_.ReplacementStrings[6]
     User = $_.ReplacementStrings[5]
     Access = $_.ReplacementStrings[10]
     SourceAddr = $_.ReplacementStrings[18]
     }
   }

$result | Select-Object Time, Machine, User, Access, SourceAddr |  Export-Csv -NoTypeInformation -Path .\Access_Log.csv


Get-WinEvent -ComputerName 'sql' -MaxEvents 1 -Logname 'security'
   -FilterXPath '*[System[EventID=4624]]' | select -expand message

$xmlquery=@'
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">
     *[System[(EventID='4624')]
     and
     EventData[Data[@Name='LogonType'] and (Data='2' or Data='7')]] 
    </Select>
  </Query>
</QueryList>
'@
Get-WinEvent -FilterXml $xmlquery -MaxEvents
