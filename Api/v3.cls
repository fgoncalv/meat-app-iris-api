Class Api.v3 Extends (%CSP.REST, Api.BS.REST.Service)
{

XData UrlMap
{
<Routes>
	    <Route Url="/" Method="POST" Call="NewTransaction" />
	  </Routes>
}

ClassMethod NewTransaction() As %Status
{
		Set tSC = $$$OK
		Try
		{
			Set doResponse={}
			Set doResponse.TransactionResult={}

			Set %response.ContentType=..#CONTENTTYPEJSON
			Set doNewTransaction=##class(%DynamicObject).%FromJSON(%request.Content)
			
			Set oRequest = ##class(Apli.BS.Msg.NewTransactionReq).CreateNewFromDynamicObj(doNewTransaction)
			
			// I can't call ProcessInput directly because I am running on a class method that was called
			// by the dispatcher. The Business Service's instance hasn't been created yet. This method will
			// create it for me and call ProcessInput:
			Do ..DispatchTo("Transaction Process", oRequest, .oResponse)

			Set doResponse.TransactionResult.Status="OK"
			Set doResponse.TransactionResult.TransactionId=oResponse.TransactionId
		}
		Catch (oException)
		{
			Set doResponse.TransactionResult.Status="Error"
			Set doResponse.TransactionResult.Exception=$$$ExceptionAsJSON(oException)
		}
		
		Write doResponse.%ToJSON()
		
		Quit $$$OK
}

}

