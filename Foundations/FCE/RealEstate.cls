Class FCE.RealEstate Extends (%Persistent,%Library.Populate,FCE.Address)
{
Method fillrandom(){
		set dataStreet(1)="7197 Second Drive"
		set dataStreet(2)="8717 Washington Drive"
		set dataStreet(3)="6537 Main Avenue"
		set dataStreet(4)="8874 Elm Drive"
		set dataStreet(5)="1885 Madison Court"
		set dataStreet(6)="3786 Clinton Drive"
		set dataStreet(7)="6433 Maple Drive"
		set dataStreet(8)="7182 Second Street"
		set dataStreet(9)="432 Elm Drive"
		
		set dataCity(1)="Boston"
		set dataCity(2)="Queensbury"
		set dataCity(3)="Xavier"
		set dataCity(4)="Oak"
		set dataCity(5)="Creek"
		set dataCity(6)="Vail"
		set dataCity(7)="Denver"
		set dataCity(8)="Chicago"
		set dataCity(9)="Youngstown"
		
		set dataState(1)="MA"
		set dataState(2)="NY"
		set dataState(3)="NY"
		set dataState(4)="NJ"
		set dataState(5)="MA"
		set dataState(6)="MA"
		set dataState(7)="NY"
		set dataState(8)="TX"
		set dataState(9)="TX"
		
		set dataZip(1)="37653"
		set dataZip(2)="99407"
		set dataZip(3)="88151"
		set dataZip(4)="51522"
		set dataZip(5)="54378"
		set dataZip(6)="78385"
		set dataZip(7)="23146"
		set dataZip(8)="75343"
		set dataZip(9)="81452"
		
		set indexStreetRandom = $Random(8)+1
		set indexCityRandom = $Random(8)+1
		set indexStateRandom = $Random(8)+1
		set indexZipRandom = $Random(8)+1
		
		set ..Street = dataStreet(indexStreetRandom)
		set ..City = dataCity(indexCityRandom)
		set ..State = dataState(indexStateRandom)
		set ..Zip = dataZip(indexZipRandom)
		
	}
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