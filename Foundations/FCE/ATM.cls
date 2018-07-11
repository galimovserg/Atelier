Class FCE.ATM Extends (%Persistent,%Library.Populate,%XML.Adaptor)
{
	Property SerialNumber As %String [Required];
	///Unique index on Serial Number ATM
	Index SerialIndex on SerialNumber  [Unique];
	
	Property Address As FCE.RealEstate;
	ForeignKey RealEstateFK(Address) References FCE.RealEstate();
	Property CurrencyBalances as array of %Numeric (MINVAL = 0, MAXVAL = 10000)[SqlFieldname = Balance];
	Index CBIndex on CurrencyBalances(KEYS);
	
	
Storage Default
{
<Data name="ATMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SerialNumber</Value>
</Value>
<Value name="3">
<Value>Address</Value>
</Value>
</Data>
<Data name="CurrencyBalances">
<Attribute>CurrencyBalances</Attribute>
<Structure>subnode</Structure>
<Subscript>"CurrencyBalances"</Subscript>
</Data>
<DataLocation>^FCE.ATMD</DataLocation>
<DefaultData>ATMDefaultData</DefaultData>
<IdLocation>^FCE.ATMD</IdLocation>
<IndexLocation>^FCE.ATMI</IndexLocation>
<StreamLocation>^FCE.ATMS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}