Class FCE.Tests.BasicTest Extends FCE.Tests.TestCase
{
	///holds a referenced FCE.RealEstate object, assigned in OnBeforeAllTests()
	property RefdRealEstate As FCE.RealEstate [Private];
	///holds an unreferenced FCE.RealEstate object, assigned in OnBeforeAllTests()
	Property UnrefdRealEstate As FCE.RealEstate [Private];
	/// test FCE.ATM.Update()
	Method TestUpdateATM()
	{

		// create branch and ATM

		set branch = ##class(FCE.Branch).%New()

		set ATM = ##class(FCE.ATM).%New()

		set ATM.SerialNumber = "X1111Y2222"
		set euros = 150, dollars = 50

		do ATM.CurrencyBalances.SetAt(dollars,"USD")

		do ATM.CurrencyBalances.SetAt(euros,"EUR")

		set ATM.Branch = branch  // must do this so that ATM is valid (Saveable) at this point

		///TODO 1
		
		set status = ATM.Update("USD", 1000000, "EUR", 123)
		
		do $$$AssertStatusNotOK(status, $system.Status.GetErrorText(status))
		
		set lasteuros = ATM.CurrencyBalances.GetAt("EUR")
		
		set lastdollars = ATM.CurrencyBalances.GetAt("USD")
		
		do $$$AssertEquals(dollars, lastdollars)
		
		do $$$AssertEquals(euros, lasteuros)
		
		///TODO 2
		
		set status = ATM.Update("USD", 100, "EUR", 1237886)
		
		do $$$AssertStatusNotOK(status, $system.Status.GetErrorText(status))
		
		set lasteuros = ATM.CurrencyBalances.GetAt("EUR")
		
		set lastdollars = ATM.CurrencyBalances.GetAt("USD")
		
		do $$$AssertEquals(dollars, lastdollars)
		
		do $$$AssertEquals(euros, lasteuros)
		
		///TODO 3
		
		set status = ATM.Update("USD", 10, "EUR", 12)
		
		do $$$AssertStatusOK(status)
		
		set lasteuros = ATM.CurrencyBalances.GetAt("EUR")
		
		set lastdollars = ATM.CurrencyBalances.GetAt("USD")
		
		do $$$AssertEquals(dollars - 10, lastdollars)
		
		do $$$AssertEquals(euros + 12, lasteuros)
		
		///TODO 4
		
		set euros = lasteuros
		set dollars = lastdollars
		
		set status = ATM.Update("USD", 10)
		
		do $$$AssertStatusOK(status)
		
		set lasteuros = ATM.CurrencyBalances.GetAt("EUR")
		
		set lastdollars = ATM.CurrencyBalances.GetAt("USD")
		
		do $$$AssertEquals(dollars - 10, lastdollars)
		
		do $$$AssertEquals(euros, lasteuros)
		
		///TODO 4
		
		set euros = lasteuros
		set dollars = lastdollars
		
		set status = ATM.Update(, , "EUR", 15)
		
		do $$$AssertStatusOK(status)
		
		set lasteuros = ATM.CurrencyBalances.GetAt("EUR")
		
		set lastdollars = ATM.CurrencyBalances.GetAt("USD")
		
		do $$$AssertEquals(dollars , lastdollars)
		
		do $$$AssertEquals(euros +15, lasteuros)

	}
	
	/// test FCE.Branch.Update()
	Method TestUpdateBranch()
	{

		// create branch

		set branch = ##class(FCE.Branch).%New()

		set dollars = 50

		do branch.CurrencyBalances.SetAt(dollars,"USD")

		set currencyIn = "USD", amountIn = 100

		set status = branch.Update(currencyIn, amountIn)

		do $$$AssertStatusOK(status, "Branch updated")

		set currentDollars = branch.CurrencyBalances.GetAt("USD")

		set dollars = dollars + amountIn

		do $$$AssertEquals(currentDollars, dollars, "Incoming currency updated")

	}

	
	//Basic tests for FCE.Branch
	Method TestBranch(){
			// assertion 1

			set branch = ##class(FCE.Branch).%New()
				do $$$AssertTrue($isobject(branch),"Created New Branch")
			
			// assertion 2

			set status = branch.%Save()
			do $$$AssertStatusNotOK(status, "Phone is required")
			
			// assertion 3

			set branch.Phone = "9999999999" // bad pattern

			set status = branch.%Save()
			do $$$AssertStatusNotOK(status, "Phone doesn't match pattern: ###-###-####")
			
			// assertion 4

			set branch.Phone = "999-999-9999" // pre-existing number

			set status = branch.%Save()
			
			do $$$AssertStatusNotOK(status, "Phone must be unique")
			
			// assertion 5

			set branch.Phone = "999-999-0000"

			set branch.Address = ..RefdRealEstate

			set status = branch.%Save()

			do $$$AssertStatusNotOK(status, "Another Branch already has this address")
			
			// assertion 6

			set branch.Address = ..UnrefdRealEstate

			set branch.Opens = 18000 // open at 5am

			set status = branch.%Save()

			do $$$AssertStatusNotOK(status, "Opening at 5am too early")
			
			// assertion 7

			set branch.Opens = 28800 // open at 8am

			set branch.Closes = 82800 // close at 11pm

			set status = branch.%Save()
			
			do $$$AssertStatusNotOK(status, "Closing at 11pm too late")

			// assertion 8

			set branch.Closes = 64800 // close at 6pm

			set branch.NationalCurrency = "ABC" // invalid currency

			set status = branch.%Save()
			
			do $$$AssertStatusNotOK(status, "ABC is invalid currency")

			// assertion 9

			set branch.NationalCurrency = "USD" // valid currency

			set status = branch.%Save()
			
			do $$$AssertStatusOK(status, "Branch saved")

			// assertion 10

			set branchID = branch.%Id()
			
			do $$$AssertNotEquals(branchID, "", "ID assigned")
			
			// assertion 11

			set status = ##class(FCE.Branch).%DeleteId(branchID)

			do $$$AssertStatusOK(status, "Branch deleted")
	}
	/// set up test environment
	Method OnBeforeAllTests() As %Status
	{
		 	// create a Branch with this phone #

	set branch = ##class(FCE.Branch).%New()

	set branch.Phone = "999-999-9999"

 

 	/* create a dummy RealEstate object, link it to the Branch above

           and save the object in the "global" RefdRealEstate property */

	set realestate = ##class(FCE.RealEstate).%New()

	set realestate.Street = "10 Main Street"

	set realestate.City = "New York"

	set realestate.State = "NY"

	set realestate.Zip = "99999"

	set status = realestate.%Save()

	set branch.Address = realestate

	set status = branch.%Save()

	set ..RefdRealEstate = realestate

	

	/* create a dummy RealEstate object that *isn't* referenced by a Branch

	   save the object in the "global" UnrefdRealEstate property */

	set realestate = ##class(FCE.RealEstate).%New()

	set realestate.Street = "20 Oak Street"

	set realestate.City = "Boston"

	set realestate.State = "MA"

	set realestate.Zip = "99999"

	set status = realestate.%Save()

	set ..UnrefdRealEstate = realestate

 	return $$$OK

		
	}
	///clean up test environment
	Method OnAfterAllTests() As %Status
	{
		/// in case any tests fail to *complete*

		/// remove the leftover branch and the initial branch

		&sql(delete from FCE.Branch

		where (Phone = '999-999-9999' or Phone = '999-999-0000'))

		set ID1 = ..RefdRealEstate.%Id(), ID2 = ..UnrefdRealEstate.%Id()

		&sql(delete from FCE.RealEstate where ID in (:ID1, :ID2))

		return $$$OK
	}
}