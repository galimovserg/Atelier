Class FCE.RealEstate Extends (%Persistent,%Library.Populate,FCE.Address)
{

Storage Default
{
<Data name="RealEstateDefaultData">
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
<DataLocation>^FCE.RealEstateD</DataLocation>
<DefaultData>RealEstateDefaultData</DefaultData>
<IdLocation>^FCE.RealEstateD</IdLocation>
<IndexLocation>^FCE.RealEstateI</IndexLocation>
<StreamLocation>^FCE.RealEstateS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}