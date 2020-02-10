#$LastChangedBy: josullivan $
#$LastChangedDate: 2014-08-11 17:05:23 +0100 (Mon, 11 Aug 2014) $
#$Revision: 54016 $


function escapeSpecialCharacters($string) {
	$string = $string.Replace('$','`$')
	$string = $string.Replace('(','`(')
	$string = $string.Replace(')','`)')
	$string = $string.Replace('*','`*')
	$string = $string.Replace('+','`+')
	$string = $string.Replace('.','`.')
	$string = $string.Replace('[','`[')
	$string = $string.Replace(']','`]')
	$string = $string.Replace('?','`?')
	$string = $string.Replace('\','`\')
	$string = $string.Replace('/','`/')
	$string = $string.Replace('^','`^')
	$string = $string.Replace('&','`&')
	$string = $string.Replace('{','`{')
	$string = $string.Replace('}','`}')
	$string = $string.Replace('|','`|')
	return $string
}

$password = escapeSpecialCharacters("ITglobalcomms2020!")

$settings = @{
	"API_USER" = "donna.cornwell@iff.com";
	"API_PASSWORD" = "$($password)";
	"AD_SERVER" = "usubdcpv1:3268";
	"EXCHANGE_SERVER" = "webmail.iff.com";
	"USE_PROXY" = "false";
	"VERBOSE_MODE"  = "false";
	"SCHEDULED" = "false";
	"PROFILE" = "false";
}

Export-Clixml -Path c:\temp\nw-config.xml -InputObject $settings