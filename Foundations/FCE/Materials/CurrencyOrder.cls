/// An order for currency.
Class FCE.CurrencyOrder Extends (%Persistent, %Populate, %XML.Adaptor)
{

	/// name of requestor
	Property Requestor As %String(POPSPEC = "Name()");

	Property RequestorEmail As %String;

	Property AmountOut As %Numeric(MINVAL = 0);

	Property CurrencyOut As FCE.CurrencyName;

	Property AmountIn As %Numeric(MINVAL = 0);

	Property CurrencyIn As FCE.CurrencyName;

	Property ExchangeRate As %Decimal(MINVAL = .001, SCALE = 3);

	Property Fee As %Numeric;

	Property DateStamp As %Date(MINVAL = 59901, MAXVAL = "+$system.SYS.TimeStamp()");

	Property TimeStamp As %Time [SqlFieldName = TS];

	/// Satisfaction with the service on this order
	Property Satisfaction As %String(VALUELIST = "-1-2-3-4-5", DISPLAYLIST = "-Great-Good-OK-Bad-Horrible");

	Relationship ATM As FCE.ATM [Cardinality = one, Inverse = Orders];
	Index ATMIndex on ATM;

	/// Requested: initial request<br>
	/// Pending:   only if awaiting approval<br>
	/// Rejected:  not approved by bank<br>
	/// Paid:      currency received by ATM, outgoing currency to be picked up<br>
	/// Completed: outgoing currency paid to customer<br>
	/// Problem:   problem in system<br>
	/// Canceled:  canceled by customer<br>

	Property Status As %String (VALUELIST = "-Requested-Pending-Rejected-Paid-Completed-Problem-Canceled"); 

	/// When a CurrencyOrder is update or deleted, record that the ATM Notes
	Trigger UpdateDeleteNotes [Time = AFTER, Event = UPDATE/DELETE, Foreach = row/object]{
			new changed, note, atm, st // ensure variables are private to trigger
			return:({ATM} = "")   // if this CurrencyOrder has no ATM, just exit
			set changed = $case({%%OPERATION}, "DELETE":"deleted", "UPDATE":"updated")
			set note = "At " _ $zdt($h) _ ", " _ $username _ " " _ changed _ " Order #"
			_ {ID} _ " originally requested by " _ {Requestor}
			_ " (for " _ {AmountOut} _ " " _ {CurrencyOut} _ ")"
			
			set atm = ##class(FCE.ATM).%OpenId({ATM}, 4, .st)
			if $$$ISOK(st) {
				do atm.Note.MoveToEnd()
				do atm.Note.WriteLine(note)
				
				set st = atm.%Save()
			}
			if ($$$ISERR(st)) { set %msg = "Couldn't update ATM notes." }
	}
	///Display all orders in a given status, sorted by branch city
	ClassMethod OrdersByCity(orderStatus As %String = "Pending"){
		&sql(declare ATMS cursor for 
		select ATM->Branch->Address->City, AmountIn, CurrencyIn, AmountOut, CurrencyOut, DateStamp, TS from FCE.CurrencyOrder where Status = :orderStatus order by ATM->Branch->Address->City
		
		)
		
		&sql(open ATMS)

	    for {

	    	&sql(fetch ATMS into :city, :amountin, :currencyin, :amountout, :currencyout, :datestamp, :ts)

	    	quit:(SQLCODE '= 0)

	    	write !, city, " |   ", amountin, " ", currencyin, " |   ", amountout, " ", currencyout, " |   ", datestamp, " |   ", ts

	    }

	    if SQLCODE = 100 {

	    	write !!, %ROWCOUNT, " row(s) returned."

	    	set status = $$$OK

	    	}

	    	else { set status = $$$ERROR($$$GeneralError, "SQLCODE: " _ SQLCODE _ " " _ %msg) }

	    	&sql(close ATMS)

	    	return $$$OK
	}
	Method OnPopulate() As %Status
	{
		// only 10% of CurrencyOrders happen at a Branch (no ATM)
		if ($random(10) = 0) { set ..ATM = "" }
		// 80% CurrencyOrders are Status = Completed
		if ($random(10) > 1) {
			set ..Status = "Completed"
		}
		else {
			set ..Status = ##class(%PopulateUtils).ValueList("-Requested-Pending-Rejected-Paid-Problem-Canceled")
		}
		// make sure CurrencyIn and CurrencyOut are different
		while (..CurrencyIn = ..CurrencyOut) {
			set ..CurrencyOut = ##class(FCE.Currency).Currency()
		}
		// set fee
		set ..Fee = ..AmountIn * .025
		// get exchange rate
		set rate = ##class(FCE.Currency).ComputeRate(..CurrencyIn, ..CurrencyOut)
		set ..ExchangeRate = rate
		// set correct AmountOut
		set ..AmountOut = (..AmountIn - ..Fee) * rate
		return $$$OK
	}

Storage Default
{
<Data name="CurrencyOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Requestor</Value>
</Value>
<Value name="3">
<Value>RequestorEmail</Value>
</Value>
<Value name="4">
<Value>AmountOut</Value>
</Value>
<Value name="5">
<Value>CurrencyOut</Value>
</Value>
<Value name="6">
<Value>AmountIn</Value>
</Value>
<Value name="7">
<Value>CurrencyIn</Value>
</Value>
<Value name="8">
<Value>ExchangeRate</Value>
</Value>
<Value name="9">
<Value>Fee</Value>
</Value>
<Value name="10">
<Value>DateStamp</Value>
</Value>
<Value name="11">
<Value>TimeStamp</Value>
</Value>
<Value name="12">
<Value>Satisfaction</Value>
</Value>
<Value name="13">
<Value>Status</Value>
</Value>
<Value name="14">
<Value>ATM</Value>
</Value>
</Data>
<DataLocation>^FCE.CurrencyOrderD</DataLocation>
<DefaultData>CurrencyOrderDefaultData</DefaultData>
<IdLocation>^FCE.CurrencyOrderD</IdLocation>
<IndexLocation>^FCE.CurrencyOrderI</IndexLocation>
<StreamLocation>^FCE.CurrencyOrderS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
