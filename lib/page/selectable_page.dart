import 'package:engbooster/model/country.dart';
import 'package:engbooster/utils.dart';
import 'package:engbooster/widget/flag_widget.dart';
import 'package:engbooster/widget/scrollable_widget.dart';
import 'package:flutter/material.dart';

class SelectablePage extends StatefulWidget {
  @override
  _SelectablePageState createState() => _SelectablePageState();
}

class _SelectablePageState extends State<SelectablePage> {
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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: countries.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(child: ScrollableWidget(child: buildDataTable())),
                  buildSubmit(),
                ],
              ),
      );

  Widget buildDataTable() {
    final columns = ['Flag', 'Name', 'Native Name'];

    return DataTable(
      sortColumnIndex: sortColumnIndex,
      sortAscending: isAscending,
      onSelectAll: (isSelectedAll) {
        setState(() => selectedCountries = isSelectedAll ? countries : []);

        Utils.showSnackBar(context, 'All Selected: $isSelectedAll');
      },
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

  List<DataRow> getRows(List<Country> countries) {
    return countries
        .map((Country country) => DataRow(
              onSelectChanged: (isSelected) => setState(() {
                final isAdding = isSelected != null && isSelected;
                isAdding
                    ? selectedCountries.add(country)
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
                DataCell(Container(
                  width: 100,
                  child: Text(country.nativeName),
                )),
              ],
            ))
        .toList();
  }

  Widget buildSubmit() => Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        color: Colors.black,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            minimumSize: Size.fromHeight(40),
          ),
          child: Text('Select ${selectedCountries.length} Countries'),
          onPressed: () {
            final names =
                selectedCountries.map((country) => country.name).join(', ');
            print(names);
            // Utils.showSnackBar(context, 'Selected countries: $names');
          },
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
