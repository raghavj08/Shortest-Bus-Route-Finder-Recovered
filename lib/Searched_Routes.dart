import 'package:daa_project/Home_Page.dart';
import 'package:flutter/material.dart';

class SearchedRoutes extends StatelessWidget {
  final String source;
  final String destination;
  final Map<String, dynamic> searchResults;
  const SearchedRoutes(
      {required this.source,
      required this.destination,
      required this.searchResults,
      super.key});

  @override
  Widget build(BuildContext context) {
    List<dynamic> allRoutes = searchResults['all_available_routes'] ?? [];
    String? bestBus = searchResults['best_bus'];
    List<dynamic> bestRoute = searchResults['best_route'] ?? [];
    dynamic totalDistance = searchResults['total_distance_km'];

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 2, 75, 201),
                  borderRadius: BorderRadius.all(Radius.circular(35))),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 60, 0, 0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 60, 0, 0),
                    child: Text(
                      'Results',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                          color: Colors.white),
                    )),
                SizedBox(
                  width: 80,
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(55, 130, 55, 0),
              child: Container(
                color: Colors.white,
                height: 50,
                width: double.infinity,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      source,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.start,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(55, 200, 55, 0),
              child: Container(
                color: Colors.white,
                height: 50,
                width: double.infinity,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      destination,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.start,
                    )),
              ),
            ),
            Positioned(
              top: 160,
              child: Transform.rotate(
                angle: 3 * 3.14159 / 2,
                child: Icon(
                  Icons.linear_scale_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 160,
              left: 400,
              child: Transform.rotate(
                angle: 3.14159 / 2,
                child: Icon(Icons.compare_arrows_outlined,size: 40,color: Colors.white,),
              )
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 310,
                  ),
                  Text(
                    'All Available Routes',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  if (allRoutes.isEmpty)
                    Text('No Route Found')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: allRoutes.length,
                      itemBuilder: (context, index) {
                        final routeData = allRoutes[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Bus: ${routeData['bus']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                Text('Distance: ${routeData['distance_km'] ?? routeData['distance'] ?? ''} km'),
                                finalRouteText(routeData),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20,),
                    Text('Shortest Route:',style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                    SizedBox(height: 10,),
                    if(bestBus != null)
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bus: $bestBus',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              Text('Total Distance: ${totalDistance ?? ''} km',),
                              Text('Route: ${bestRoute.join(' --> ')}'),
                            ],
                          ),
                        ),
                      ),
                    )
                    else
                    Text('No shortest route found')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget finalRouteText(Map<String, dynamic> routeData) {
    final route = routeData['route'];
    if (route is List) {
      return Text('Route: ${route.join(' --> ')}');
    } else if (routeData['from'] != null && routeData['to'] != null) {
      return Text('Route: ${routeData['from']} --> ${routeData['to']}');
    } else {
      return Text('');
    }
  }
}
