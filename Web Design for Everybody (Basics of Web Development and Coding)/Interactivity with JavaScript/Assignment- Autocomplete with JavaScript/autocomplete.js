//This function is responsible for setting and clearing the fields in Billing Information

function billingFunction() {
	//Checks if the checkbox is checked
	if (document.getElementById("same").checked) {
		//Copy the values from the shipping information to the billing information
		document.getElementById("billingName").readOnly = true;
		document.getElementById("billingZip").readOnly = true;
		document.getElementById("billingName").value = document.getElementById("shippingName").value;
		document.getElementById("billingZip").value = document.getElementById("shippingZip").value
	} else {
		//Clears the values of the billing information
		document.getElementById("billingName").value = "";
		document.getElementById("billingZip").value = "";
		document.getElementById("billingName").readOnly = false;
		document.getElementById("billingZip").readOnly = false;
	}
}