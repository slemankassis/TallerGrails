<g:each in="${listAgencies}" var="a">
    <div class="details"><p>${a.description} ${a.distance}</p></div>
    <p style="display: none" id="details">
        ${a.address.address_line} ${a.address.city} ${a.address.country} ${a.address.location} ${a.address.other_info} ${a.address.state} ${a.address.zip_code}
    </p>
</g:each>

<div id="map_wrapper">
    <div id="map_canvas" class="mapping"></div>
</div>


<script
        src="https://code.jquery.com/jquery-3.3.1.min.js"
        integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
        crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.0/jquery-confirm.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.0/jquery-confirm.min.js"></script>

<style>
#map_wrapper {
    height: 400px;
}

#map_canvas {
    width: 100%;
    height: 100%;
}
</style>

<script>
    $(".details").on("click", function(){
        $.alert({
            title: 'Details',
            content: document.getElementById('details').innerHTML
        });
    });

    jQuery(function($) {
        // Asynchronously Load the map API
        var script = document.createElement('script');
        script.src = "//maps.googleapis.com/maps/api/js?callback=initialize&key=AIzaSyBm2H5mtR8dOc2l39-cZD0s9oFwSV-6d-Y";
        document.body.appendChild(script);
    });

    function initialize() {
        var map;
        var bounds = new google.maps.LatLngBounds();
        var mapOptions = {
            mapTypeId: 'roadmap'
        };

        // Display a map on the page
        map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
        map.setTilt(45);

        // Multiple Markers
        var markers = [];
        var infoWindowContent = [];
        <g:each in="${listAgencies}" var="a">
            var location = "${a.address.location}".split(',');
            markers.push(["${a.description}", parseFloat(location[0]), parseFloat(location[1])]);
            infoWindowContent.push(['<div class="info_content"><h3>${a.description} ${a.address.address_line}</h3></div>']);
        </g:each>

        // Display multiple markers on a map
        var infoWindow = new google.maps.InfoWindow(), marker, i;

        // Loop through our array of markers & place each one on the map
        for( i = 0; i < markers.length; i++ ) {
            var position = new google.maps.LatLng(markers[i][1], markers[i][2]);
            bounds.extend(position);
            marker = new google.maps.Marker({
                position: position,
                map: map,
                title: markers[i][0]
            });

            // Allow each marker to have an info window
            google.maps.event.addListener(marker, 'click', (function(marker, i) {
                return function() {
                    infoWindow.setContent(infoWindowContent[i][0]);
                    infoWindow.open(map, marker);
                }
            })(marker, i));

            // Automatically center the map fitting all markers on the screen
            map.fitBounds(bounds);
        }

        // Override our map zoom level once our fitBounds function runs (Make sure it only runs once)
        var boundsListener = google.maps.event.addListener((map), 'bounds_changed', function(event) {
            this.setZoom(14);
            google.maps.event.removeListener(boundsListener);
        });
    }
</script>