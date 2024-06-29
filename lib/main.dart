import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('University Search app',
            style: TextStyle(
            fontFamily: 'Cardo',
            fontSize: 34,
             color: Colors.black,
          )),
          backgroundColor:Colors.grey,


        ),
        body: Center(

          child: UniversitySearch(



          ),
        ),
      ),
    );
  }
}

class UniversitySearch extends StatefulWidget {
  @override
  _UniversitySearchState createState() => _UniversitySearchState();
}

class _UniversitySearchState extends State<UniversitySearch> {
  String _searchText = '';
  List<dynamic> _universities = [];

  Future<void> fetchData(String searchText) async {
    final url = Uri.parse('http://universities.hipolabs.com/search?country=$searchText');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Successful request, parse the response body
        final jsonData = json.decode(response.body);
        setState(() {
          // Update the state with the data from the API
          _universities = jsonData;
        });
      } else {
        // Handle error if the request was not successful
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occurred during the request
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 10,width: 70,),
        Container(

          child: Container(
            margin: const EdgeInsets.only(top:10)

          ),
        ),
        TextField(
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
            fetchData(value);
          },
          decoration: InputDecoration(

            labelText: 'Enter Country Name',


            border: OutlineInputBorder(),
          ),
        ),

        SizedBox(height: 20,width: 80,),

        Expanded(
          child: ListView.builder(
            itemCount: _universities.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle the click event here
                  print('University clicked: ${_universities[index]['name']}');

                  },
                child: ListTile(
                  title: Text(_universities[index]['name']),
                  subtitle: Text(_universities[index]['country']),

                ),

              );
            },


          ),
        ),
      ],
    );
  }
}

