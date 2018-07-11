Class FCE.ATM Extends (%Persistent,%Library.Populate,%XML.Adaptor)
{
	Property SerialNumber As %String (POPSPEC = "##class(%PopulateUtils).String(5)_##class(%PopulateUtils).String(5)") [Required];
	///Unique index on Serial Number ATM
	Index SerialIndex on SerialNumber [Unique];
	
	Property Address As FCE.RealEstate;
	ForeignKey RealEstateFK(Address) References FCE.RealEstate();
	Property CurrencyBalances as array of %Numeric (MINVAL = 0, MAXVAL = 10000,  POPSPEC = ":5:##class(FCE.Currency).Currency()")[SqlFieldname = Balance];
	Index CBIndex on CurrencyBalances(KEYS);
	
	Relationship Branch As FCE.Branch [Cardinality = parent, Inverse = ATMs];
	Method fillRandom(){
		set ..SerialNumber = ##class(%PopulateUtils).String(5)_##class(%PopulateUtils).String(5)
		set ..Address = ##class(FCE.Address).%New(initvalue)
	}
	
	Method %OnValidateObject() As %Status [Private, ServerOnly = 1]	{
		return ##class(FCE.Currency).CurrencyKeysValidate(..CurrencyBalances)
	}
	
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