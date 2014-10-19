<!DOCTYPE html>
<html>

<head>
<script src="js/jquery-1.11.1.js"></script>
<!--<link rel="stylesheet" type="text/css" href="css/styles.css">-->
<link href='http://fonts.googleapis.com/css?family=Open+Sans:700,400' rel='stylesheet' type='text/css'>
<script>
	//Check if connected device is mobile
	var isMobile = {
		Android: function() {
			return navigator.userAgent.match(/Android/i);
		},
		BlackBerry: function() {
			return navigator.userAgent.match(/BlackBerry/i);
		},
		iOS: function() {
			return navigator.userAgent.match(/iPhone|iPad|iPod/i);
		},
		Opera: function() {
			return navigator.userAgent.match(/Opera Mini/i);
		},
		Windows: function() {
			return navigator.userAgent.match(/IEMobile/i);
		},
		any: function() {
			return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
		}
	};
	if( isMobile.any() ){
		$("link[rel=stylesheet]").attr({href : "css/styles-mobile.css"});

	} else {
		$("link[rel=stylesheet]").attr({href : "css/styles.css"});
	}

	$(document).ready(function(){
		//temp code cuz its too long to type
		$("#input").val("599b27f53b3dd7f79120");
		
		$("#go-button").click(function(){
			var code = $("#input").val(); //user code
			if(code.length != 20){
				$("#input-error").text("Code should be 20 alphanumeric characters");
			} else if( /[^a-zA-Z0-9]/.test(code)){
				$("#input-error").text("Invalid characters in code");
			} else{
				if(isMobile.any()){
					$("#popout-background").hide();
				} else {
					
					$("#popout-background").fadeOut("slow");
				}
			}
			thing(code);
			/*var dataString = "usercode=" + code;

			$.ajax({
				type: "POST",
				url: "/ajax_retrieve_events.php",
				data: dataString,
				async: false, 
				success: function(msg) {
					data = JSON.parse(msg);
					for (var i = 0; i < data.length; i++) {
						var time = timeConverter(data[i].timestamp);
						if(i % 2 == 0){
							$("#event-content").append("<div class=\"event\">" + time + " - " + data[i].text + "</div>");
						} else if(i % 2 != 0){
							$("#event-content").append("<div class=\"event2\">" + time + " - " + data[i].text + "</div>");
						}
					}
				}
			});*/
		});
		var i = 0;
		$("#wait").click(function(){
			var code = $("#input").val(); //user code
			var date = new Date();
			date = date.getTime();
			var dataString = "usercode=" + code + "&text=" + "Wait" + "&timestamp=" + date/1000;
			$.ajax({
				type: "POST",
				url: "/ajax_add_event.php",
				data: dataString,
				async: false, 
				success: function(msg) {

				}
			});
			thing(code);
		});
		
		$("#continue").click(function(){
			if(i % 2 == 0){
				$("#event-content").append("<div class=\"event\">Continue requested at " + time + ".</div>");
			} else if(i % 2 != 0){
				$("#event-content").append("<div class=\"event2\">Continue requested at " + time + ".</div>");
			}
			i++;
		});
		
		if( !isMobile.any()){
			setHeight();
		}
	});
	
	//function displays all events in the event or event2 class
	//input: code
	function thing(code){
		var dataString = "usercode=" + code;
		$(".event").remove();
		$(".event2").remove();
		$.ajax({
			type: "POST",
			url: "/ajax_retrieve_events.php",
			data: dataString,
			async: false, 
			success: function(msg) {
				data = JSON.parse(msg);
				for (var i = 0; i < data.length; i++) {
					var time = timeConverter(data[i].timestamp);					
					if(data[i].who == 0 && i % 2 == 0){
						$("#event-content").append("<div class=\"event\"><div class=\"event-green\">" + time + " - " + data[i].text + "</div></div>");
					} else if(data[i].who == 0 && i % 2 != 0){
						$("#event-content").append("<div class=\"event2\"><div class=\"event-green\">" + time + " - " + data[i].text + "</div></div>");
					} else if(data[i].who == 1 && i % 2 == 0){
						$("#event-content").append("<div class=\"event\"><div class=\"event-red\">" + time + " - " + data[i].text + "</div></div>");
					} else if(data[i].who == 1 && i % 2 != 0){
						$("#event-content").append("<div class=\"event2\"><div class=\"event-red\">" + time + " - " + data[i].text + "</div></div>");
					}
				}
			}
		});
	}
	
	//Function to convert a unix timestamp into a readable time
	function timeConverter(UNIX_timestamp){
		var a = new Date(UNIX_timestamp*1000);
		var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
		var year = a.getFullYear();
		var month = months[a.getMonth()];
		var date = a.getDate();
		var hour = a.getHours();
		var min = a.getMinutes();
		var sec = a.getSeconds();
		if(min < 10){
			min = "0" + min;
		}
		if(hour > 12){
			hour -= 12;
		}
		var time = hour + ':' + min ;
		return time;
	}
	
	function setHeight(){
		//Set the size of the div to the percent of page remaining after the control
		//div is loaded so they scale well with no scroll bar.
		var height = $(document).height() - 3
		controlHeight = 64 + 3;
		var pageHeightWithoutControl = height - 64;
		var otherPercent = ((height - controlHeight) / height) * 100 + "%";
		$("#map-canvas").css("height",otherPercent); //set map and event content to the remainder
		$("#event-content").css("height",otherPercent);
	}
</script>
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB8nP8zW5doATgHCBiJCaGe4r5cNeS1V1g&sensor=false">
 </script>
<script type="text/javascript">
	var directionsDisplay;
	var directionsService = new google.maps.DirectionsService();
	var map;

	function initialize() {
		directionsDisplay = new google.maps.DirectionsRenderer();
		var chicago = new google.maps.LatLng(41.850033, -87.6500523);
		var mapOptions = {
		zoom:10,
		center: chicago
	};
	map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
	directionsDisplay.setMap(map);
}

	function calcRoute(){
		var request = {
			origin: "Sydney,NS",
			destination: "Toronto,ON",
			travelMode: google.maps.TravelMode.DRIVING,
			unitSystem: google.maps.UnitSystem.METRIC,
			//provideRouteAlternatives: Boolean,
			avoidHighways: false,
			avoidTolls: false
		};
		directionsService.route(request, function(result, status){
			if (status == google.maps.DirectionsStatus.OK) {
				directionsDisplay.setDirections(result);
			}
		});
	}
	google.maps.event.addDomListener(window, 'load', initialize);
</script>

</head>
<body>
	<div id="popout-background">
		<div id="popout">
			<div id="popout-description-text">
				Enter your code
			</div>
			<div id="input-container">
				<input type="text" id="input"/>
			</div>
			<div id="input-error"></div>
			<div id="go-button-container">
				<div id="go-button"><div id="go-inner-button-text">GO</div></div>
			</div>
		</div>
	</div>
	<div id="content-container" onmouseover="calcRoute()">
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