package com.unact.yandexmapkit;

import android.util.Log;

import androidx.annotation.NonNull;

import com.yandex.mapkit.directions.driving.Action;
import com.yandex.mapkit.directions.driving.Annotation;
import com.yandex.mapkit.directions.driving.DrivingRoute;
import com.yandex.mapkit.directions.driving.DrivingSection;
import com.yandex.mapkit.directions.driving.DrivingSectionMetadata;
import com.yandex.mapkit.directions.driving.DrivingSession;
import com.yandex.mapkit.directions.driving.Weight;
import com.yandex.mapkit.geometry.PolylinePosition;
import com.yandex.mapkit.geometry.Subpolyline;
import com.yandex.runtime.Error;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class YandexDrivingListener implements DrivingSession.DrivingRouteListener  {
  private final MethodChannel.Result result;

  public YandexDrivingListener(MethodChannel.Result result) {
    this.result = result;
  }

  @Override
  public void onDrivingRoutes(@NonNull List<DrivingRoute> list) {
    List<Map<String, Object>> resultRoutes = new ArrayList<>();
    for (DrivingRoute route : list) {
      Weight weight = route.getMetadata().getWeight();
      Map<String, Object> resultWeight = new HashMap<>();
      resultWeight.put("time", Utils.localizedValueToJson(weight.getTime()));
      resultWeight.put("timeWithTraffic", Utils.localizedValueToJson(weight.getTimeWithTraffic()));
      resultWeight.put("distance", Utils.localizedValueToJson(weight.getDistance()));
      Map<String, Object> resultMetadata = new HashMap<>();
      resultMetadata.put("weight", resultWeight);

      List<Map<String, Object>> resultSections = new ArrayList<>();

      List<Map<String, Object>> resultWaypoints = new ArrayList<>();
      for (PolylinePosition wayPoint : route.getWayPoints()) {
        Map<String, Object> resultWayPoint = new HashMap<>();
        resultWayPoint.put("segmentIndex",wayPoint.getSegmentIndex());
        resultWayPoint.put("segmentPosition",wayPoint.getSegmentPosition());
        resultWaypoints.add(resultWayPoint);
      }

      for (DrivingSection drivingSection : route.getSections()) {
        Map<String, Object> section = new HashMap<>();

        // Metadata
        Map<String, Object> resultDrivingMetadata = new HashMap<>();
        DrivingSectionMetadata drivingSectionMetadata = drivingSection.getMetadata();

        // Metadata.Weight
        Weight sectionWeight = drivingSectionMetadata.getWeight();

        Map<String, Object> resultDrivingWeight = new HashMap<>();
        resultDrivingWeight.put("time", Utils.localizedValueToJson(sectionWeight.getTime()));
        resultDrivingWeight.put("timeWithTraffic", Utils.localizedValueToJson(sectionWeight.getTimeWithTraffic()));
        resultDrivingWeight.put("distance", Utils.localizedValueToJson(sectionWeight.getDistance()));

        // Metadata.Annotation
        Annotation metaDataAnnotation = drivingSectionMetadata.getAnnotation();

        Map<String, Object> resultAnnotation = new HashMap<>();
        Action annonationAction = metaDataAnnotation.getAction();

        resultAnnotation.put("action", annonationAction != null ? annonationAction.ordinal() : null);
        resultAnnotation.put("toponym",metaDataAnnotation.getToponym());
        resultAnnotation.put("descriptionText",metaDataAnnotation.getDescriptionText());

        resultDrivingMetadata.put("weight",resultDrivingWeight);
        resultDrivingMetadata.put("annotation",resultAnnotation);

        // Geometry
        Subpolyline drivingSectionGeometry = drivingSection.getGeometry();
        Map<String, Object> resultGeometryGeometry = new HashMap<>();

        PolylinePosition polylinePositionBegin = drivingSectionGeometry.getBegin();
        Map<String, Object> resultPolylineBegin = new HashMap<>();
        resultPolylineBegin.put("segmentIndex", polylinePositionBegin.getSegmentIndex());
        resultPolylineBegin.put("segmentPosition", polylinePositionBegin.getSegmentPosition());
        PolylinePosition polylinePositionEnd = drivingSectionGeometry.getEnd();

        Map<String, Object> resultPolylineEnd = new HashMap<>();
        resultPolylineEnd.put("segmentIndex", polylinePositionEnd.getSegmentIndex());
        resultPolylineEnd.put("segmentPosition", polylinePositionEnd.getSegmentPosition());

        resultGeometryGeometry.put("begin",resultPolylineBegin);
        resultGeometryGeometry.put("end",resultPolylineEnd);

        section.put("metadata", resultDrivingMetadata);
        section.put("geometry", resultGeometryGeometry);
        resultSections.add(section);
      }

      Map<String, Object> resultRoute = new HashMap<>();
      resultRoute.put("polyline", Utils.polylineToJson(route.getGeometry()));
      resultRoute.put("sections", resultSections);
      resultRoute.put("metadata", resultMetadata);
      resultRoute.put("waypoints", resultWaypoints);

      resultRoutes.add(resultRoute);
    }

    Map<String, Object> resultMap = new HashMap<>();
    resultMap.put("routes", resultRoutes);


    result.success(resultMap);
  }

  @Override
  public void onDrivingRoutesError(@NonNull Error error) {
    result.success(Utils.errorToJson(error));
  }
}
