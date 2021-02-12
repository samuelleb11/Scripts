# User vars
$DesiredLang = "fr-ca"
$DesiredKeyboardLang = "0C0C:00001009" # "0C0C:00011009" for CMS "0C0C:00001009" for Canadian French

# Sys vars
$SysLangArr = @('en-us','en-ca','fr-fr','fr-ca')
$KeyboardLangArr = @('1009:00011009','1009:00000409','0C0C:00001009','0C0C:00011009','0C0C:0000040C','0C0C:00000409','0409:00000409}')

# Logic
$languages = Get-WinUserLanguageList
foreach ($SysLang in $SysLangArr)
{
    $languages.Add($SysLang)
}

$count = 0
foreach ($lang in $languages)
{
    $languages[$count].InputMethodTips.Clear()
    foreach ($KeyboardLang in $KeyboardLangArr)
    {
        $languages[$count].InputMethodTips.Add($KeyboardLang)
    }
    $count++
}
Set-WinUserLanguageList $languages -Force
$languages = Get-WinUserLanguageList
$languages.Clear()
$languages.add($DesiredLang)
foreach ($KeyboardLang in $KeyboardLangArr)
{
    $languages[0].InputMethodTips.Add($KeyboardLang)
}
$languages[0].InputMethodTips.Clear()
$languages[0].InputMethodTips.Add($DesiredKeyboardLang)

Set-WinUserLanguageList $languages -Force
