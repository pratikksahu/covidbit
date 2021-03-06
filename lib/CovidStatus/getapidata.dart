
import 'package:covid19bitdurg/SetData/Setdata.dart';
import 'package:covid19bitdurg/CovidStatus/totaltestedmodel.dart';
import 'package:covid19bitdurg/CovidStatus/covidStatus.dart';
import 'package:covid19bitdurg/CovidStatus/Districtdatamodel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'Statedatamodel.dart';

void getSeletedData( Statelist shape) {
  shape.std.forEach((f){
    if(f.state.contains(setSeletedState.selectedstate)){
      print("ACTTIVE CASEE${f.active}");
      print("CONFIRMED CASEE${f.confirmed}");
      print("DEATHS CASEE${f.deaths}");
      print("RECOVERED CASEE${f.recovered}");
      print("LAST UPDATED ON ${f.updateon}");
      statetotaldata(f.active,f.confirmed,f.deaths,f.recovered,f.state,f.updateon);
    }
  });
  //  print("LIST CREATED IS ${stategraphdata.positive}");

}
void getSeletedData1( Statelist1 shape1) {

  shape1.std1.forEach((f){
    if(f.status.contains("Confirmed")) {
      stateconfirmed(f.statec);
    }
    if(f.status.contains("Recovered")) {
      staterecoverd(f.statec);
    }
    if(f.status.contains("Deceased")) {
      statedeaths(f.statec);
    }
  });
  double k=0,p=0;
  for(int i=0;i<stateconfirmed.confirmed.length;i++){
    k=k+stateconfirmed.confirmed[i];
    p=p+staterecoverd.recovered[i];
    stateactive(k-p);
  }
  stateactive.activecount=stateactive.active[stateactive.active.length-1];
  listcreated=true;
  //  print("LIST CREATED IS ${stategraphdata.positive}");

}
getSeletedData2() async {
  final response2 = await http.get("https://api.covid19india.org/state_district_wise.json");
  if (response2.statusCode == 200) {
    var jsonresponce2=await json.decode(response2.body);
    Shape shape2 = new Shape.fromJson(jsonresponce2);
    print(shape2);
    print(setSeletedState.selectedstate);
    print("${shape2.stateUuassigned.districtData.unassigned.active},${shape2.stateUuassigned.districtData.unassigned.recovered}${shape2.stateUuassigned.districtData.unassigned.confirmed}");
    districtData(shape2.stateUuassigned.districtData.unassigned.active,shape2.stateUuassigned.districtData.unassigned.recovered,shape2.stateUuassigned.districtData.unassigned.confirmed);

  } else {
    throw Exception('Failed to load data');
  }
 }

void getSeletedData3( Slist shape) {
  bool datefound=false;
  int i=0;
  shape.std.forEach((f){
    if(f.state.contains(setSeletedState.selectedstate)){
      var now = new DateTime.now();
      var previousdate = now.subtract(Duration(days: i));
      var formatter = new DateFormat('dd/MM/yyyy');
      String formattedDate = formatter.format(previousdate);
      if(f.updatedon.contains(formattedDate)) {
        datefound=true;
      }
    }
  });
  while(!datefound && i<5){
    i++;
    shape.std.forEach((f){
      if(f.state.contains(setSeletedState.selectedstate)){
        var now = new DateTime.now();
        var previousdate = now.subtract(Duration(days: i));
        var formatter = new DateFormat('dd/MM/yyyy');
        String formattedDate = formatter.format(previousdate);
        if(f.updatedon.contains(formattedDate)) {
          datefound=true;
          stateData(f.totaltested);
        }
      }
    });
  }
}