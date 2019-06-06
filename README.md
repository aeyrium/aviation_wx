 # aviation_wx (NOT READY FOR USE)
 Dart API frontend for the Aviation Digital Data Service (ADDS).

 ## About Aviation Digital Data Service (ADDS)
 ADDS makes available to the aviation community text, digital
 and graphical forecasts, analyses, and observations of
 aviation-related weather variables. ADDS was developed as a
 joint effort of NCAR Research Applications Program (RAP),
 Global Systems Division (GSD) of NOAA's Earth System Research
 Laboratory (ESRL), and the National Centers for Environmental
 Prediction (NCEP) Aviation Weather Center (AWC).

 ## Currently Supported Data Services
 The Aviation Digital Data Service (ADDS) provide a broad range
 of data.  The following is a high level breakdown of what is
 supported by the `aviation-wx` package.

 | Service Type     | Supported | 
 |------------------|-----------|
 | METARs           | Yes       |
 | TAFs             | Yes       |
 | Station Info     | Yes       |
 | Aircraft Reports | No        |
 | Air/SigMets      | No        |
 | G-AIRMETS        | No        |

## Station Queries
To avoid having to make multiple requests for multiple [METAR] or [TAF] reports, the API 
supports the ability to define a list of stations.  But in some cases, you may want to retrieve 
more stations that you can specify explicitly.  For that case the API supports various 
means of making querys.  

### Query by Station Identifiers
The most basic search filter is to provide one or more station ids.
A station id is an ICAO identifier and often an airport code 
(e.g. KSFO, KOAK, etc).

```dart
// Here we are downloading the METARs reported in the 
// last hour for SFO and OAK airports ...
var metars = METAR.download(stations: ['KSFO', 'KOAK'])
```

### Search by Station Wildcard Expression
You can also use a wildcard expression to specify any station that matches the expression.

```dart
// Here we are downloading the METARs for airports with 
// ident codes that start with a 'KM'.
var metars = METAR.download(stations: ['KM*'])
```

> **WARNING** There is a limit of 1000 responses so if your query matches too many airports, you won't get a full result set.  For example, a search for `K*` would try to return all airports in the United States, which exceeds the 1000 repsonse maximum.

### Search by State/Region
To retrieve [METAR]s or [TAF]s for an entire state or region, use the `@` symbol followed
by two-letter state abbreveation (or two-letter Canadian province.)

```dart
// Here we are downloading the METARs for stations in 
// the state of Washington and California.
var metars = METAR.download(stations: ['@WA', '@CA'])
```

> **WARNING** There is a limit of 1000 responses so if you query too many states you may not get the full data set.

### Search by Country
To retrieve [METAR]s or [TAF]s for an entire country, use the `~` symbol followed
by two-letter country abbreveation.
```dart
// Here we are downloading the METARs for stations in 
// the all of the US and Canada.
var metars = METAR.download(stations: ['~US', '~CA'])
```

> **WARNING** There is a limit of 1000 responses so if you query an entire country you may not get the full data set if the country have a lot of stations (like the United States.)



