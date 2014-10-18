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
		var dt = new Date();
		var dtHour = dt.getHours();
		if(dtHour > 12){
			dtHour -= 12;
		}
		var time = dtHour + ":" + dt.getMinutes();
		var i = 0;
		$("#wait").click(function(){
			if(i % 2 == 0){
				$("#event-content").append("<div class=\"event\">Wait requested at " + time + ".</div>");
			} else if(i % 2 != 0){
				$("#event-content").append("<div class=\"event2\">Wait requested at " + time + ".</div>");
			}
			i++;
		});
		
		$("#continue").click(function(){
			if(i % 2 == 0){
				$("#event-content").append("<div class=\"event\">Continue requested at " + time + ".</div>");
			} else if(i % 2 != 0){
				$("#event-content").append("<div class=\"event2\">Continue requested at " + time + ".</div>");
			}
			i++;
		});
	});
</script>
<script type="text/javascript"
  src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB8nP8zW5doATgHCBiJCaGe4r5cNeS1V1g&sensor=false">
</script>
<script type="text/javascript">
  function initialize() {
	var mapOptions = {
	  center: { lat: 46.600, lng: -60.500},
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
			<div id="control-label"><div id="control-label-text">Controls</div></div>
			<div id="button-cluster">
				<div id="wait" class="control-buttons"><div class="inner-button-text">Wait</div></div>
				<div id="continue" class="control-buttons"><div class="inner-button-text">Continue</div></div>
				<!--<div id="unused" class="control-buttons"><div class="inner-button-text">unused</div></div>
				<div id="unused" class="control-buttons"><div class="inner-button-text">unused</div></div>-->
			</div>
		</div>
		<div id="map-canvas">
		</div>
		<div id="event-content">
			<div id="event-title">
				event log
			</div>
		</div>
	</div>
</body>
</html>