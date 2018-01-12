$ProcessesWithoutParents = @()
$ProcessesByParent = @{}
foreach ($Pair in $ProcessesById.GetEnumerator()) {
  $Process = $Pair.Value
  if (($Process.ParentProcessId -eq 0) -or !$ProcessesById.ContainsKey($Process.ParentProcessId)) {
    $ProcessesWithoutParents += $Process
    continue
  }
}
