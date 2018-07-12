Class FCE.ATM Extends (%Persistent,%Library.Populate,%XML.Adaptor)
{
	Property SerialNumber As %String (POPSPEC = "##class(%PopulateUtils).String(5)_##class(%PopulateUtils).String(5)") [Required];
	///Unique index on Serial Number ATM
	Index SerialIndex on SerialNumber [Unique];
	
	Property Address As FCE.RealEstate;
	ForeignKey RealEstateFK(Address) References FCE.RealEstate();
	Property CurrencyBalances as array of %Numeric (MINVAL = 0, MAXVAL = 10000,  POPSPEC = ":5:##class(FCE.Currency).Currency()")[SqlFieldname = Balance];
	Index CBIndex on CurrencyBalances(KEYS);
	property Note As %Stream.GlobalCharacter;
	Relationship Branch As FCE.Branch [Cardinality = parent, Inverse = ATMs];
	
	/// Update ATM by debiting/crediting currencies<br>

/// This method can be called with:<br>

/// * all 4 arguments (cash in – cash out). currencyOut and currencyIn <b>must</b> be different<br>

/// * the first 2 arguments (cash out only, paid for by credit card or bank account)<br>

/// * the last 2 arguments (cash in only, to be credited to bank balance)<br>

	Method Update(

		currencyOut As FCE.CurrencyName = "",

		amountOut As %Numeric = 0,

		currencyIn As FCE.CurrencyName = "",

		amountIn As %Numeric = 0) As %Status

		{

			try {

			set status = $$$OK

			set (outChanged, inChanged) = 0

			// debit stock amount by amount taken out

			if (currencyOut '= "") && (amountOut > 0) {

				set outChanged = 1

				set stockAmountOut = ..CurrencyBalances.GetAt(currencyOut)
				
				set localvalue = stockAmountOut  - amountOut
				
				do ..CurrencyBalances.SetAt(localvalue, currencyOut)
				
				set status = ..%ValidateObject()

				if $$$ISERR(status) {

					set ex = ##class(%Exception.StatusException).CreateFromStatus(status)

					throw ex

					}

				}

		

				// credit stock amount by amount put in

				if (currencyIn '= "") && (amountIn > 0) {

				set inChanged = 1

				set stockAmountIn = ..CurrencyBalances.GetAt(currencyIn)
				
				set localvalue = stockAmountIn + amountIn
				
				do ..CurrencyBalances.SetAt(localvalue, currencyIn)
				
				set status = ..%ValidateObject()

				if $$$ISERR(status) {

					set ex = ##class(%Exception.StatusException).CreateFromStatus(status)

					throw ex

					}

				}		

		// create unforseen <DIVIDE> exception 10% of the time

		// if '$r(10) {write 1/0}

		}

		catch ex {

			#dim ex, exCustom as %Exception.StatusException // enable Studio Assist for the exception objects

			// return custom error status depending on value of ex.Code

			if (ex.Code = $$$ERRORCODE($$$DTMinVal)) {

				set status = $$$ERROR($$$GeneralError, "Not enough stok in ATM for "_currencyOut_" SerialNumber = "_..SerialNumber)
				set exCustom = ##class(%Exception.StatusException).CreateFromStatus(status)

				do exCustom.Log()

			}

			elseif (ex.Code = $$$ERRORCODE($$$DTMaxVal)) {

				set status = $$$ERROR($$$GeneralError, "ATM has no more room for "_currencyOut_" SerialNumber = "_..SerialNumber)

				set exCustom = ##class(%Exception.StatusException).CreateFromStatus(status)

				do exCustom.Log()

			}

			// or change unforeseen exception back into a status

			else {

				set status = ex.AsStatus()

				do ex.Log()

			}

		// reset ATM's currencyIn and currencyOut

			if (outChanged){
				do ..CurrencyBalances.SetAt(stockAmountOut, currencyOut)
			}
			
			if (inChanged){
				do ..CurrencyBalances.SetAt(stockAmountIn, currencyIn)
			}



			// write to console log, optionally triggering notification

			set consoleMsg = "ATM " _ ..SerialNumber _ " Stock Problem - Check Error Log for details: "

			set portalLink = "http://localhost:57772/csp/sys/op/UtilSysAppErrorNamespaces.csp"

			do ##class(%SYS.System).WriteToConsoleLog(consoleMsg _ portalLink, , 2)

		}

		return status

	}
	Method fillRandom(){
		set ..SerialNumber = ##class(%PopulateUtils).String(5)_##class(%PopulateUtils).String(5)
		set ..Address = ##class(FCE.RealEstate).%New()
		do ..Address.fillrandom()
		set list = ##class(FCE.Currency).ConvertCurrenciestoListString(##class(FCE.CurrencyName).#VALUELIST)
		
		
		
		set key =  $list(list,1)
		
		for i=2:1:$listlength(list) 
		{
			if (key'="")
			{
			}else{
				set value=random(10000)
				do CurrencyBalances.SetAt(value,key)
			}
			set key =  $list(list,i)
		}
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
<Value name="4">
<Value>Note</Value>
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