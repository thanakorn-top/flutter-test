import 'package:flutter/material.dart';
import 'package:engbooster/model/country.dart';
import 'package:engbooster/utils.dart';
import 'package:engbooster/widget/flag_widget.dart';
import 'package:engbooster/widget/scrollable_widget.dart';

class SelectCourseFirstPage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _SelectCourseFirstPageState createState() => _SelectCourseFirstPageState();
}

class _SelectCourseFirstPageState extends State<SelectCourseFirstPage> {
  List<Country> countries = [];
  List<Country> selectedCountries = [];
  int sortColumnIndex;
  bool isAscending = true;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    final countries = await Utils.loadCountries();

    setState(() => this.countries = countries);
  }

  void nextPage() {
    Navigator.pushNamed(context, '/selectCourseSecondPage',
        arguments: selectedCountries);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: new EdgeInsets.only(
                left: 15.0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Choose Language Want To learn",
                  style: new TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 25.0),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            countries.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    // height: 500,
                    child: ScrollableWidget(child: buildDataTable())),
            SizedBox(
              height: 25,
            ),
            buildSubmit(),
            // ],
            // Center(
            //   child: Column(
            //     children: [
            //       Expanded(
            //           child: ScrollableWidget(child: buildDataTable())),
            //       buildSubmit(),
            //     ],
            //   ),
            // )
          ],
        ),
      );

  Widget buildDataTable() {
    final columns = ['Flag', 'Name'];

    return DataTable(
      dataRowColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) return Colors.lightBlue;
        return null; // Use the default value.
      }),
      headingRowHeight: 0,
      showCheckboxColumn: false,
      sortColumnIndex: sortColumnIndex,
      sortAscending: isAscending,
      // onSelectAll: (isSelectedAll) {
      //   setState(() => selectedCountries = isSelectedAll ? countries : []);

      //   Utils.showSnackBar(context, 'All Selected: $isSelectedAll');
      // },
      columns: getColumns(columns),
      rows: getRows(countries),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns
        .map((String column) => DataColumn(
              onSort: onSort,
              label: Text(column),
            ))
        .toList();
  }

  void addCountry(Country country) {
    selectedCountries = [];
    selectedCountries.add(country);
  }

  List<DataRow> getRows(List<Country> countries) {
    return countries
        .map((Country country) => DataRow(
              onSelectChanged: (isSelected) => setState(() {
                final isAdding = isSelected != null && isSelected;
                isAdding
                    ? addCountry(country)
                    : selectedCountries.remove(country);
                // print(selectedCountries[0]);
              }),
              selected: selectedCountries.contains(country),
              cells: [
                DataCell(FlagWidget(code: country.code)),
                DataCell(Container(
                  width: 100,
                  child: Text(country.name),
                )),
                // DataCell(Container(
                //   width: 100,
                //   child: Text(country.nativeName),
                // )),
              ],
            ))
        .toList();
  }

  Widget buildSubmit() => Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        // color: Colors.black,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            minimumSize: Size.fromHeight(40),
          ),
          child: Text('Next'),
          // child: Text('Select ${selectedCountries.length} Countries'),
          onPressed: selectedCountries.isEmpty ? null : nextPage,
          // onPressed: () {
          //   Navigator.pushNamed(context, '/selectCourseSecondPage',
          //       arguments: selectedCountries);
          //   // Navigator.pushNamed(context, '/selectCourseSecondPage');

          //   // final names =
          //   //     selectedCountries.map((country) => country.name).join(', ');
          //   // print(names);
          //   // Utils.showSnackBar(context, 'Selected countries: $names');
          // },
        ),
      );

  void onSort(int columnIndex, bool ascending) {
    print(columnIndex);
    print(ascending);
    if (columnIndex == 1) {
      countries.sort((country1, country2) =>
          compareString(ascending, country1.name, country2.name));
    }
    if (columnIndex == 2) {
      countries.sort((country1, country2) =>
          compareString(ascending, country1.nativeName, country2.nativeName));
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String val1, String val2) {
    // print(val1);
    // print(val2);
    return ascending ? val1.compareTo(val2) : val2.compareTo(val1);
  }
}
