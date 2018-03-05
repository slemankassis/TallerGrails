package tallerrr

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.maps.GeoApiContext
import com.google.maps.GeocodingApi
import com.google.maps.model.GeocodingResult
import groovy.json.JsonSlurper


class GeneralController {

    def index() {

        def url = new URL('https://api.mercadolibre.com/sites/MLA/payment_methods/')
        def connection = (HttpURLConnection)url.openConnection()
        connection.setRequestMethod("GET")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozzilla/5.0")
        JsonSlurper json = new JsonSlurper()
        def map = []
        json.parse(connection.getInputStream()).each {
            if(it.payment_type_id == "ticket") {
                map.add(['id': it.id, 'name': it.name])
            }
        }
        [listPaymentMethods: map]
    }

    def agencies() {

        def coordinates = getCoordinates(params.address)
        def url = new URL('https://api.mercadolibre.com/sites/MLA/payment_methods/' + params.payment_method + '/agencies?near_to=' + coordinates.lat + ',' + coordinates.lng + ',' + params.range)
        def connection = (HttpURLConnection)url.openConnection()
        connection.setRequestMethod("GET")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozzilla/5.0")
        JsonSlurper json = new JsonSlurper()
        def map = []
        json.parse(connection.getInputStream()).results.each {
            map.add(['description': it.description, 'distance': it.distance, 'id': it.id, 'address': it.address])
        }
        println(map)
        [listAgencies: map]
    }

    def getCoordinates(address) {

        GeoApiContext context = new GeoApiContext.Builder().apiKey('AIzaSyAEDdMcEkTMTI0xGppo2fx4rmKkOI21VHA').build()
        GeocodingResult[] results = GeocodingApi.geocode(context, address).await()
        Gson gson = new GsonBuilder().setPrettyPrinting().create()
        def lat = gson.toJson(results[0].geometry.location.lat).toString()
        def lng = gson.toJson(results[0].geometry.location.lng).toString()
        return [lat: lat, lng: lng]
    }
}
