import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';


const String apiKey = '1CE14F27-D1F0-4F6C-8950-B820663B811D';
const String apiURL = 'https://rest.coinapi.io/v1/exchangerate/BTC/';


//Function to fetch the price of cryptocurrency in USD

// Function to fetch the price of Bitcoin in USD
Future<double?> fetchCryptoPrice(String currency, String crypto) async {
  try{
    // Build URL dynamically with the currency and API key
    final response = await http.get(
      Uri.parse('$apiURL$currency?apikey=$apiKey'), // Build the URL with
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Decode the JSON response
      var decodeData = jsonDecode(response.body);
      return (decodeData['rate'] as num).toDouble();
      // Extract the 'rate' field from the JSON(price of BTC
    } else {
      // Handle errors like 404, 500, etc
      print('Failed to load data: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Handle any exceptions that might occur during the request
    print('Error: $e');
    return null;
  }
}


class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  double? bitcoinPrice;
  double? ethPrice;
  double? ltcPrice;

  // Function to fetch the bitcoin price
  Future<void> getCoinData(String currency) async {
    double? btcPrice = await fetchCryptoPrice(currency, 'BTC');
    double? ethPriceFetched = await fetchCryptoPrice(currency, 'ETH');
    double? ltcPriceFetched = await fetchCryptoPrice(currency, 'LTC');


      if (btcPrice != null) {
        setState(() {
          bitcoinPrice = btcPrice; // Format the price to
        });
      } else {
        setState(() {
          bitcoinPrice = null;
        });
      }
    if (ethPriceFetched != null) {
      setState(() {
        ethPrice = ethPriceFetched; // Format the price to
      });
    } else {
      setState(() {
        ethPrice = null;
      });
    }
    if (ltcPriceFetched != null) {
      setState(() {
        ltcPrice = ltcPriceFetched; // Format the price to
      });
    } else {
      setState(() {
        ltcPrice = ltcPriceFetched;
      });
    }
    }

  DropdownButton<String> androidDropdown() {

    List<DropdownMenuItem<String>> dropDownItems = [];
    for( String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropDownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value!;
            getCoinData(selectedCurrency); // Fetch data when currency char
          });
        },
    );
  }
  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for(String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getCoinData(selectedCurrency); // Fetch new data when currency
        });
      },
      children: pickerItems,
    );
  }

@override
void initState() {
    super.initState();
    getCoinData(selectedCurrency); // Fetch data when the screen first loads
}


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Coin Ticker')),
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child:
            Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0),
              child: Text('1 BTC = ${bitcoinPrice?.toStringAsFixed(2) ?? 'Error'} USD',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Padding(padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                child: Text('1 ETH =${ethPrice?.toStringAsFixed(2) ?? 'Error'} USD',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Padding(padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                child: Text('1 LTC =${ltcPrice?.toStringAsFixed(2) ?? 'Error'} USD',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
            ),
        ],
      ),
    );
  }
}
