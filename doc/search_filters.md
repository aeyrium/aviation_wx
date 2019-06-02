# Search Filters
There are a number ways you can retrieve [METAR] and [TAF] data.  

## Search by Station
The most basic search filter is to provide one or more station ids.
A station id is an ICAO identifier and often an airport code 
(e.g. KSFO, KOAK, etc).

```dart
// Here we are downloading the METARs reported in the last hour
// for SFO and OAK airports ...
var metars = METAR.download(stations: ['KSFO', 'KOAK'])
```