Class FCE.Branch Extends (%Persistent,%Library.Populate,%XML.Adaptor)
{
	///Currency used by this branch's nation
	Property NationalCurrentcy As FCE.CurrencyName [ InitialExpression = "USD"];
	///Branch phone
	Property Phone as FCE.PhoneNumber [Required];
	///Unique index on Branch phone
	Index PhoneIndex on Phone  [Unique];
	///Branch address  
	Property Address as FCE.RealEstate;
	ForeignKey RealEstateFK(Address) References FCE.RealEstate()[OnDelete = setnull];
	///Unique index on Branch address
	index AddressIndex on Address[Unique];
	///Branch opens between 6:00am and 12:00n
	Property Opens As %Time(MINVAL = "$ztimeh(""6:00am"")",MAXVAL="$ztimeh(""12:00n"")");
	///Branch close between 1:00pm and 10:00pm
	Property Closes As %Time(MINVAL = "$ztimeh(""1:00pm"")",MAXVAL="$ztimeh(""10:00pm"")");
	///calculate DurationOpen from Opens, Closes
	Property DurationOpen As %String [Calculated, SqlComputed, SqlComputeCode = { 
	if ({Closes} = "")||({Opens} = "") {
			set {DurationOpen} = ""
		}
		else {
			set {DurationOpen} = $ztime({Closes} - {Opens})
		}
	}];
	/// create a JSON object from Branch properties
Method CopyToObject(object as %DynamicObject) as %Status
{
	set object.ID = ..%Id()
	set object.Phone = ..Phone
	set object.Opens = $ztime(..Opens)
	set object.Closes = $ztime(..Closes)
	return $$$OK
}

/// copy a JSON object into Branch properties
Method CopyFromObject(object as %DynamicObject) as %Status
{
	set ..Phone  = object.Phone
	set ..Opens = $ztimeh(object.Opens)
	set ..Closes = $ztimeh(object.Closes)
	return $$$OK
}

Storage Default
{
<Data name="BranchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NationalCurrentcy</Value>
</Value>
<Value name="3">
<Value>Phone</Value>
</Value>
<Value name="4">
<Value>Address</Value>
</Value>
<Value name="5">
<Value>Opens</Value>
</Value>
<Value name="6">
<Value>Closes</Value>
</Value>
</Data>
<DataLocation>^FCE.BranchD</DataLocation>
<DefaultData>BranchDefaultData</DefaultData>
<IdLocation>^FCE.BranchD</IdLocation>
<IndexLocation>^FCE.BranchI</IndexLocation>
<StreamLocation>^FCE.BranchS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}