Class FCE.PhoneNumber Extends %Library.String
{
	Parameter MAXLEN = 12;
	Parameter PATTERN = "3n1""-""3n1""-""4n";
	ClassMethod LogicalToDisplay(%val As %String) As %String[ ServerOnly = 0 ]
	{
		return "(" _ $piece(%val, "-") _ ")-" _ $piece(%val, "-", 2, 3)
	}
}