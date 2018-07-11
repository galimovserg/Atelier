Class FCE.Tests.BasicTest Extends FCE.Tests.TestCase
{
	///holds a referenced FCE.RealEstate object, assigned in OnBeforeAllTests()
	property RefdRealEstate As FCE.RealEstate [Private];
	///holds an unreferenced FCE.RealEstate object, assigned in OnBeforeAllTests()
	Property UnrefdRealEstate As FCE.RealEstate [Private];
	
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