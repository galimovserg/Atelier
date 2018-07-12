/// Utilities for development
Class FCE.Tests.Utilities
{

/// Delete all data and run tests
ClassMethod DestroyAll()
{
	do ##class(FCE.Branch).%DeleteExtent() // also deletes FCE.ATM Notes (stream) data
	do ##class(FCE.RealEstate).%KillExtent()
	read !, "Data deleted. Press <Enter> to run tests.", x
	do ##class(FCE.Tests.BasicTests).Run()
	read !, "Press <Enter> to continue.", x
}

/// Create data and run tests
ClassMethod CreateAll(base As %Integer = 5)
{
	do ##class(FCE.RealEstate).Populate(base * 10)
	// assigns real estate objects to new branches and ATMs
	do ##class(FCE.Branch).Populate(base)
	do ##class(FCE.ATM).Populate(base * 3)
	read !, "Data added. Press <Enter> to run tests.", x
	do ##class(FCE.Tests.BasicTests).Run()
	read !, "Press <Enter> to continue.", x
}

}
