///Address properties for <class>FCE.RealEstate</class> and <class>FCE.MailingAddress</class>
Class FCE.Address Extends (%Persistent,%Library.Populate,%XML.Adaptor)[Abstract]
{
	Property Street As %String[Required];
	Property City As %String[Required];
	Property State As %String(MAXLEN=2,VALUELIST="-NY-NJ-MA-TX")[Required];
	//Property Zip As %String(PATTERN="5n.1""-""4n",MAXLEN=10)[Required];
	Property Zip As FCE.Regex(REGEX="\d{5}(-\d{4})?")[Required];
	
	Method Print(){
		write ..Street 
		write !, ..City," ", ..State," ", ..Zip
	}
Storage Default
{
<Data name="AddressDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Street</Value>
</Value>
<Value name="3">
<Value>City</Value>
</Value>
<Value name="4">
<Value>State</Value>
</Value>
<Value name="5">
<Value>Zip</Value>
</Value>
</Data>
<DataLocation>^FCE.AddressD</DataLocation>
<DefaultData>AddressDefaultData</DefaultData>
<IdLocation>^FCE.AddressD</IdLocation>
<IndexLocation>^FCE.AddressI</IndexLocation>
<StreamLocation>^FCE.AddressS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}