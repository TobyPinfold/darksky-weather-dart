// Copyright (c) 2017, 'rinukkusu'. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of darksky_weather;

abstract class DarkSkyWeatherBase {
  final String _apiToken;
  final Language language;
  final Units units;

  static const String _baseUrl = 'https://api.darksky.net';
  String _getForecastUrl(
      double lat, double lon, String time, String excludes, String lang, String units) =>
      '$_baseUrl/forecast/$_apiToken/$lat,$lon,$time' +
          '?exclude=$excludes' +
          '&lang=$lang' +
          '&units=$units';

  DarkSkyWeatherBase(this._apiToken,
      {this.language = Language.English, this.units = Units.US});

  Future<Forecast> getForecast(double lat, double lon,
      {List<Exclude> excludes = const [], double time}) async {

    time ??= DateTime.now().millisecondsSinceEpoch.roundToDouble();
    var timeFormattedForApiCall = (time / 1000).toInt().toString();
    var rExcludes = _renderExcludes(excludes);
    var rLanguage = LanguageHelper.get(language);
    var rUnits = getUnitName(units);

    var url = _getForecastUrl(lat, lon, timeFormattedForApiCall, rExcludes, rLanguage, rUnits);
    print(url);

    var bytes = await _getImpl(url);

    var decoded = utf8.decode(bytes);
    var map = json.decode(decoded);
    var forecast = new Forecast.fromJson(map);

    return forecast;
  }

  String _renderExcludes(List<Exclude> list) {
    return list.map(getExcludeName).join(',');
  }

  Future<List<int>> _getImpl(String url);
}
