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
		
		$("#button1").click(function(){
			$("#event-content").append("<div class=\"event\"></div>");
			$(".event").text("Wait requested");
		});
		
		$("#button2").click(function(){
			$("#event-content").append("<div class=\"event\"></div>");
			$(".event").text("Continue requested");
		});
	});
</script>
<script type="text/javascript"
  src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB8nP8zW5doATgHCBiJCaGe4r5cNeS1V1g&sensor=false">
</script>
<script type="text/javascript">
  function initialize() {
	var mapOptions = {
	  center: { lat: -34.397, lng: 150.644},
	  zoom: 6
	};
	var map = new google.maps.Map(document.getElementById('map-canvas'),
		mapOptions);
  }
  google.maps.event.addDomListener(window, 'load', initialize);
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
			<div id="button-cluster">
				<div id="button1" class="control-buttons"><div class="inner-button-text">add this</div></div>
				<div id="button2" class="control-buttons"><div class="inner-button-text">add this</div></div>
				<div id="button3" class="control-buttons"><div class="inner-button-text">add this</div></div>
				<div id="button4" class="control-buttons"><div class="inner-button-text">add this</div></div>
			</div>
		</div>
		<div id="map-canvas">
		</div>
		<div id="event-content">
			event log
		</div>
	</div>
</body>
</html>