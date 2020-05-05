class CovidData {
  bool success;
  Data data;
  String lastRefreshed;
  String lastOriginUpdate;

  CovidData({
    this.success,
    this.data,
    this.lastRefreshed,
    this.lastOriginUpdate
});
  factory CovidData.fromJson(Map<String, dynamic> parsedJson){
    return CovidData(
        success: parsedJson['success'],
        data : Data.fromJson(parsedJson['data']),
        lastRefreshed : parsedJson ['lastRefreshed'],
        lastOriginUpdate: parsedJson['lastOriginUpdate']
    );
  }
}

class Summary {
  int total;
  int confirmedCasesIndian;
  int confirmedCasesForeign;
  int discharged;
  int deaths;
  int confirmedButLocationUnidentified;

  Summary({
    this.total,
    this.confirmedCasesIndian,
    this.confirmedCasesForeign,
    this.discharged,
    this.deaths,
    this.confirmedButLocationUnidentified
  });

  factory Summary.fromJson(Map<String, dynamic> parsedJson){
    return Summary(
        total: parsedJson['total'],
        confirmedCasesIndian : parsedJson['confirmedCasesIndian'],
        confirmedCasesForeign : parsedJson ['confirmedCasesForeign'],
        discharged: parsedJson['discharged'],
        deaths: parsedJson['deaths'],
        confirmedButLocationUnidentified: parsedJson['confirmedButLocationUnidentified']
    );
  }
}

class UnofficialSummary {
  String source;
  int total;
  int recovered;
  int deaths;
  int active;

  UnofficialSummary({
    this.source,
    this.total,
    this.recovered,
    this.deaths,
    this.active
  });

  factory UnofficialSummary.fromJson(Map<String, dynamic> parsedJson){
    return UnofficialSummary(
        source: parsedJson['source'],
        total : parsedJson['total'],
        recovered : parsedJson ['recovered'],
        deaths: parsedJson['deaths'],
        active: parsedJson['active'],
    );
  }
}

class RegionalData {
  String loc;
  int confirmedCasesIndian;
  int discharged;
  int deaths;
  int confirmedCasesForeign;
  int totalConfirmed;

  RegionalData({
    this.loc,
    this.confirmedCasesIndian,
    this.discharged,
    this.deaths,
    this.confirmedCasesForeign,
    this.totalConfirmed
});

  factory RegionalData.fromJson(Map<String, dynamic> parsedJson){
    return RegionalData(
      loc: parsedJson['loc'],
      confirmedCasesIndian : parsedJson['confirmedCasesIndian'],
      discharged : parsedJson ['discharged'],
      deaths: parsedJson['deaths'],
      confirmedCasesForeign: parsedJson['confirmedCasesForeign'],
        totalConfirmed: parsedJson['totalConfirmed']
    );
  }
}

class Data {
  Summary summary;
  List<UnofficialSummary> unofficialSummary;
  List<RegionalData> regionalData;

  Data({
    this.summary,
    this.unofficialSummary,
    this.regionalData
});
  factory Data.fromJson(Map<String, dynamic> parsedJson){
    List<UnofficialSummary> unofficialSummaryList = new List<UnofficialSummary>();
    for (dynamic i in parsedJson['unofficial-summary'] ) {
      UnofficialSummary us = UnofficialSummary.fromJson(i);
      unofficialSummaryList.add(us);
    }

    List<RegionalData> regionalDataList = new List<RegionalData>();
    for (dynamic i in parsedJson['regional'] ) {
//      print(i);
      RegionalData rd = RegionalData.fromJson(i);

      regionalDataList.add(rd);
//      print(regionalDataList.length);
    }
    return Data(
        summary: Summary.fromJson(parsedJson['summary']),
        unofficialSummary :unofficialSummaryList,
        regionalData : regionalDataList
    );
  }
}

