<!DOCTYPE html>
<html>

<head>
<script src="js/jquery-1.11.1.js"></script>
<link rel="stylesheet" type="text/css" href="css/styles.css">
<script>
$(document).ready(function(){
	$("#popout").hide();
	$("#popout").fadeIn("slow");
});

/*$(document).ready(function(){
  $("#go-button").click(function(){
    $("#popout-background").fadeOut("slow");
  });
});*/
</script>
<script>
	$(document).ready(function(){
		//temp code cuz its too long to type
		$("#input").val("12345678901234567890");
		
		$("#go-button").click(function(){
			var code = $("#input").val();

			if(code.length != 20){
				$("#input-error").text("Code should be 20 alphanumeric characters");
			} else if( /[^a-zA-Z0-9]/.test(code)){
				$("#input-error").text("Invalid characters in code");
			} else{
				//TODO connect to php file
				$("#popout-background").fadeOut("slow");
			}
		});
	});
</script>
</head>
<body>
	<div id="popout-background">
		<div id="popout">
			Enter your code
			<input type="text" id="input"/>
			<div id="input-error"></div>
			<button id="go-button">Go</button>
		</div>
	</div>
	<div id="content-container">
		<div id="control-content">
			controls
			<button id="button1">add this</button>
			<button id="button1">add this</button>
			<button id="button1">add this</button>
			<button id="button1">add this</button>
		</div>
		<div id="map-content">
			map
		</div>
		<div id="event-content">
			event log
		</div>
	</div>
</body>
</html>