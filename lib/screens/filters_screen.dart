import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String fieldValue = 'Tài chính - ngân hàng';
  int statusIndex = 0;
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
      "value": 0,
      "color": Colors.green,
      "description": "Đang hoạt động",
    },
    {
      "value": 1,
      "color": Colors.red,
      "description": "Ngừng hoạt động",
    },
    {
      "value": 2,
      "color": Colors.black,
      "description": "Ngừng tuyển",
    },
  ];

  @override
  Widget build(BuildContext context) {
    SharedPreferences sharedPreferences;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your filters'),
        actions: <Widget>[
          IconButton(
              onPressed: () async => {
                    sharedPreferences = await SharedPreferences.getInstance(),
                    sharedPreferences.setString("status", statusIndex.toString()),
                    sharedPreferences.setString("field", fieldValue),
                  },
              icon: const Icon(Icons.save))
        ],
      ),
      drawer: const MainDrawer(),
      body: Column(children: <Widget>[
        const SizedBox(height: 30),
        Row(children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(
              'Lĩnh vực',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: DropdownButton<String>(
              selectedItemBuilder: (BuildContext context) {
                return fields.map<Widget>((String item) {
                  return Text(item);
                }).toList();
              },
              value: fieldValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: TextStyle(color: Theme.of(context).primaryColor),
              underline: Container(
                height: 2,
                color: Theme.of(context).primaryColor,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  fieldValue = newValue!;
                });
              },
              items: fields.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ]),
        const SizedBox(height: 30),
        Row(children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(
              'Trạng thái',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: DropdownButton<int>(
              value: statusIndex,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: TextStyle(color: Theme.of(context).primaryColor),
              underline: Container(
                height: 2,
                color: Theme.of(context).primaryColor,
              ),
              onChanged: (int? index) {
                setState(() {
                  statusIndex = index!;
                });
              },
              items: statuses.map<DropdownMenuItem<int>>((dynamic value) {
                return DropdownMenuItem<int>(
                  value: value['value'] as int,
                  child: Text(value['description'] as String),
                );
              }).toList(),
            ),
          ),
        ]),
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
