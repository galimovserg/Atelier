Class FCE.Tests.CurrencyOrderRests Extends FCE.Tests.TestCase
{
	/// test unified trigger FCE.CurrencyOrder.UpdateDeleteInNotes for updates and deletes
	Method TestCOTrigger() {
	
		// create branch

		set branch = ##class(FCE.Branch).%New()

		set phone = "949-997-3`50", branch.Phone = phone

		set status = branch.%Save()



		// create ATM and order

		set ATM = ##class(FCE.ATM).%New()
		do ATM.fillRandom()
		set order = ##class(FCE.CurrencyOrder).%New()
		set order.CurrencyOut = "EUR"
		set order.AmountOut = 95
		set order.CurrencyIn = "USD"
		set order.AmountIn = 100

		set order.Requestor = "Smith,John"

		set order.RequestorEmail = "Smith@abcd.com"

		set order.ATM = ATM

		set order.ATM.Branch = branch

		set status = order.%Save()

		do $$$AssertStatusOK(status, "Order saved")

		

		set order.Fee = 50

		set status = order.%Save()

		do $$$AssertStatusOK(status, "Fee changed, Order saved")

	

		set atmNotes = order.ATM.Note

		set length1 = atmNotes.Size

		do $$$AssertTrue(length1 > 0, "ATM Notes got longer")

		set found = atmNotes.FindAt(1, "updated")

		do $$$AssertTrue((found '= -1), "ATM notes contain an ""update"" entry")

	

		// delete order

		set orderID = order.%Id()

		&sql(delete fce.currencyorder where ID = :orderID)

		do $$$AssertStatusOK(status, "Order deleted")



		set length2 = atmNotes.Size

		do $$$AssertTrue(length2 > length1, "ATM Notes got longer again")

		set found = atmNotes.FindAt(1, "deleted")

		do $$$AssertTrue((found '= -1), "ATM notes contain a ""delete"" entry")



		// delete Branch and ATM

		do ##class(FCE.Branch).%DeleteId(branch.%Id())

	}
}