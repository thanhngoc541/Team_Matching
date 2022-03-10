import 'package:flutter/material.dart';
import 'package:team_matching/models/filter.dart';

import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';
  final Function saveFilters;
  final Function saveFilters2;
  final Map<String, bool> filters;
  final FilterObject filterObject;
  const FiltersScreen(
      {Key? key,
      required this.saveFilters,
      required this.filters,
      required this.filterObject,
      required this.saveFilters2})
      : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String dropdownValue = 'One';
  late bool _gluten = false;
  late bool _lactose = false;
  late bool _vegetarian = false;
  late bool _vegan = false;
  late FilterObject _filterObject;
  static const fields = [
    "Tài chính - ngân hàng",
    "Khoa học - công nghệ",
    "Nông nghiệp xanh",
    "Công nghệ hoá-sinh",
    "Dịch vụ",
    "Du lịch",
    "Giáo dục",
    "Y tế",
    "Công nghiẹp chế tạo, sản xuất",
  ];

  static const statuses = [
    {
      "value": "0",
      "color": Colors.green,
      "description": "Đang hoạt động",
    },
    {
      "value": "1",
      "color": Colors.red,
      "description": "Ngừng hoạt động",
    },
    {
      "value": "2",
      "color": Colors.black,
      "description": "Ngừng tuyển",
    },
  ];
  @override
  void initState() {
    _gluten = widget.filters['gluten']!;
    _lactose = widget.filters['lactose']!;
    _vegetarian = widget.filters['vegetarian']!;
    _vegan = widget.filters['vegan']!;
    _filterObject = widget.filterObject;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your filters'),
        actions: <Widget>[
          IconButton(
              onPressed: () => {
                    widget.saveFilters({
                      'gluten': _gluten,
                      'lactose': _lactose,
                      'vegetarian': _vegetarian,
                      'vegan': _vegan,
                    })
                  },
              icon: const Icon(Icons.save))
        ],
      ),
      drawer: const MainDrawer(),
      body: Column(children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Adjust your meals selection',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: ListView(children: <Widget>[
            buildSwitchListTile(
              'Gluten-free',
              'Only include gluten-free meals.',
              _gluten,
              (value) {
                setState(() {
                  _gluten = value;
                });
              },
            ),
            buildSwitchListTile(
              'Lactose-free',
              'Only include Lactose-free meals.',
              _lactose,
              (value) {
                setState(() {
                  _lactose = value;
                });
              },
            ),
            buildSwitchListTile(
              'Vegeterian',
              'Only include Vegeterian meals.',
              _vegetarian,
              (value) {
                setState(() {
                  _vegetarian = value;
                });
              },
            ),
            buildSwitchListTile(
              'Vegan',
              'Only include Vegan meals.',
              _vegan,
              (value) {
                setState(() {
                  _vegan = value;
                });
              },
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['One', 'Two', 'Free', 'Four']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ]),
        )
      ]),
    );
  }

  SwitchListTile buildSwitchListTile(
      String title, String subtitle, bool value, Function updateValue) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: (value) {
        updateValue(value);
      },
    );
  }
}
