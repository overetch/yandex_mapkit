package com.unact.yandexmapkit;

import androidx.annotation.NonNull;

import com.yandex.mapkit.geometry.Point;
import com.yandex.mapkit.geometry.Subpolyline;
import com.yandex.mapkit.transport.masstransit.Route;
import com.yandex.mapkit.transport.masstransit.Section;
import com.yandex.mapkit.transport.masstransit.SectionMetadata;
import com.yandex.mapkit.transport.masstransit.Session;
import com.yandex.mapkit.transport.masstransit.TravelEstimation;
import com.yandex.mapkit.transport.masstransit.WayPoint;
import com.yandex.mapkit.transport.masstransit.Weight;
import com.yandex.runtime.Error;
import com.yandex.runtime.network.NetworkError;
import com.yandex.runtime.network.RemoteError;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class YandexPedestrianListener implements Session.RouteListener {
    private final MethodChannel.Result result;

    public YandexPedestrianListener(MethodChannel.Result result) {
        this.result = result;
    }

    @Override
    public void onMasstransitRoutes(@NonNull List<Route> list) {
        List<Map<String, Object>> resultRoutes = new ArrayList<>();
        for (Route route : list) {
            List<Map<String, Double>> resultPoints = new ArrayList<>();
            for (Point point : route.getGeometry().getPoints()) {
                resultPoints.add(Utils.pointToJson(point));
            }
            List<Map<String, Object>> resultSections = new ArrayList<>();

            for (Section section : route.getSections()) {
              Map<String, Object> resultSection = new HashMap<>();

              SectionMetadata metadata = section.getMetadata();
              Map<String, Object> resultMetadata = new HashMap<>();
              Weight sectionWeight = metadata.getWeight();

              Map<String, Object> resultWeight = new HashMap<>();
              resultWeight.put("time", Utils.localizedValueToJson(sectionWeight.getTime()));
              resultWeight.put("walkingDistance", Utils.localizedValueToJson(sectionWeight.getWalkingDistance()));
              resultWeight.put("transfersCount", sectionWeight.getTransfersCount());


              TravelEstimation estimation = metadata.getEstimation();
              Map<String, Object> resultEstimation = new HashMap<>();
              if (estimation != null) {
                resultEstimation.put("departureTime",
                        Utils.timeToJson(estimation.getDepartureTime()));
                resultEstimation.put("arrivalTime",
                        Utils.timeToJson(estimation.getArrivalTime()));
                resultMetadata.put("estimation", resultEstimation);
              }


              resultMetadata.put("weight", resultWeight);
              resultSection.put("metadata", resultMetadata);
              resultSection.put("geometry", Utils.subpolylineToJson(section.getGeometry()));

              resultSections.add(resultSection);
            }
            List<Map<String, Object>> resultWayPoints = new ArrayList<>();
            for (WayPoint wayPoint : route.getWayPoints()) {

              Map<String, Object> resultWayPoint = new HashMap();
              resultWayPoint.put("position",Utils.pointToJson(wayPoint.getPosition()));
              if (wayPoint.getSelectedArrivalPoint() != null) {
                resultWayPoint.put("selectedArrivalPoint", Utils.pointToJson(wayPoint.getSelectedArrivalPoint()));
              }

              if (wayPoint.getSelectedDeparturePoint() != null) {
                resultWayPoint.put("selectedDeparturePoint", Utils.pointToJson(wayPoint.getSelectedDeparturePoint()));
              }
              resultWayPoints.add(resultWayPoint);
            }

            Weight weight = route.getMetadata().getWeight();
            Map<String, Object> resultWeight = new HashMap<>();
            resultWeight.put("time", Utils.localizedValueToJson(weight.getTime()));
            resultWeight.put("walkingDistance", Utils.localizedValueToJson(weight.getWalkingDistance()));
            resultWeight.put("transfersCount", weight.getTransfersCount());
            Map<String, Object> resultMetadata = new HashMap<>();
            resultMetadata.put("weight", resultWeight);

            Map<String, Object> resultRoute = new HashMap<>();
            resultRoute.put("geometry", resultPoints);
            resultRoute.put("sections", resultSections);
            resultRoute.put("metadata", resultMetadata);
            resultRoute.put("waypoints", resultWayPoints);

            resultRoutes.add(resultRoute);
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("routes", resultRoutes);

        result.success(resultMap);
    }

    @Override
    public void onMasstransitRoutesError(@NonNull Error error) {
        String errorMessage = "Unknown error";

        if (error instanceof NetworkError) {
            errorMessage = "Network error";
        }

        if (error instanceof RemoteError) {
            errorMessage = "Remote server error";
        }

        Map<String, Object> arguments = new HashMap<>();
        arguments.put("error", errorMessage);

        result.success(arguments);
    }
}